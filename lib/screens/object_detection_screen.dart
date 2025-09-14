import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vision_vox/services/tts_service.dart';

// Placeholder service for object detection
class ObjectDetectionService {
  Future<List<String>> detectObjects(File image) async {
    // For now, return dummy results
    await Future.delayed(const Duration(seconds: 1));
    return ["Bottle", "Laptop"]; // Example detected objects
  }

  void dispose() {}
}

class ObjectDetectionScreen extends StatefulWidget {
  const ObjectDetectionScreen({super.key});

  @override
  State<ObjectDetectionScreen> createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
  final TtsService _tts = TtsService();
  final ObjectDetectionService _odService = ObjectDetectionService();

  File? _pickedImage;
  String _detectedObjects = '';
  DateTime? _lastButtonTapTime;
  int _buttonTapCounter = 0;

  @override
  void initState() {
    super.initState();
    _tts.speak(
      "Welcome to Object Detection. Tap the camera button to detect objects around you."
    );
  }

  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final captured = await picker.pickImage(source: ImageSource.camera);

    if (captured != null) {
      setState(() => _pickedImage = File(captured.path));
      _tts.speak("Camera opened. Detecting objects...");
      await _detectObjects(File(captured.path));
    } else {
      _tts.speak("No image captured.");
    }
  }

  Future<void> _detectObjects(File image) async {
    final results = await _odService.detectObjects(image);

    if (results.isNotEmpty) {
      setState(() => _detectedObjects = results.join(", "));
      _tts.speak("Detected objects: $_detectedObjects");
    } else {
      setState(() => _detectedObjects = "No objects detected.");
      _tts.speak("No objects detected.");
    }
  }

  void _handleButtonTap() {
    final now = DateTime.now();
    if (_lastButtonTapTime == null || now.difference(_lastButtonTapTime!) > const Duration(milliseconds: 500)) {
      _buttonTapCounter = 1;
    } else {
      _buttonTapCounter++;
    }
    _lastButtonTapTime = now;

    if (_buttonTapCounter == 1) {
      _tts.speak("Camera option selected");
    } else if (_buttonTapCounter == 2) {
      _openCamera();
      _buttonTapCounter = 0;
      _lastButtonTapTime = null;
    }
  }

  @override
  void dispose() {
    _tts.stop();
    _odService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Object Detection',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Heading
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [cs.primary.withOpacity(0.3), cs.secondary.withOpacity(0.3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Object Detection',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Camera button
              SizedBox(
                width: double.infinity,
                height: 130,
                child: ElevatedButton.icon(
                  onPressed: _handleButtonTap,
                  icon: Icon(Icons.camera_alt, size: 60, color: cs.onPrimary),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28.0),
                    child: Text(
                      'Camera',
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: cs.onPrimary),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    backgroundColor: cs.primary.withOpacity(0.85),
                    elevation: 8,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Display detected objects
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black26, width: 1.5),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _detectedObjects.isEmpty ? "Detected objects will appear here..." : _detectedObjects,
                      style: const TextStyle(fontSize: 20, height: 1.4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
