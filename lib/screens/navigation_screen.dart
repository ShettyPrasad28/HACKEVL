import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/gemini_service.dart';
import '../services/tts_service.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isBusy = false; // Prevents multiple simultaneous API calls
  
  // Initialize services
  final GeminiService _geminiService = GeminiService.instance;
  late final TtsService _ttsService;

  @override
  void initState() {
    super.initState();
    _ttsService = Provider.of<TtsService>(context, listen: false);
    _initializeCamera();

    // Speak instructions when the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ttsService.speak(
        "Navigation screen opened. Point your camera forward and tap the button at the bottom to describe your surroundings."
      );
    });
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      // Use the first camera in the list (usually the back camera)
      final backCamera = cameras.first;

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high, // Use high resolution for better analysis
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      // Handle camera errors (e.g., permissions denied)
      print("Error initializing camera: $e");
      if (mounted) {
        _ttsService.speak("Could not access the camera. Please check app permissions.");
        Navigator.pop(context); // Go back if camera fails
      }
    }
  }
  
  Future<void> _analyzeAndSpeak() async {
    if (_isBusy || !_isCameraInitialized) return;

    setState(() { _isBusy = true; });
    _ttsService.speak("Analyzing, please wait.");

    try {
      // 1. Capture Image
      final image = await _cameraController!.takePicture();
      final Uint8List imageBytes = await image.readAsBytes();
      
      // 2. Send to Gemini for description
      final String description = await _geminiService.getDescriptionFromImage(imageBytes);

      // 3. Speak the result
      _ttsService.speak(description);

    } catch (e) {
      print("Error analyzing frame: $e");
      _ttsService.speak("Sorry, an error occurred while analyzing the image.");
    } finally {
      // Ensure we always release the busy flag
      if (mounted) {
        setState(() { _isBusy = false; });
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Assistant'),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (!_isCameraInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    // Use a Stack to overlay the button on top of the camera preview
    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_cameraController!),
        
        // Button positioned at the bottom
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onPressed: _isBusy ? null : _analyzeAndSpeak,
            icon: _isBusy
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
                : const Icon(Icons.remove_red_eye_outlined),
            label: Text(_isBusy ? 'Analyzing...' : 'Describe Surroundings'),
          ),
        ),
      ],
    );
  }
}