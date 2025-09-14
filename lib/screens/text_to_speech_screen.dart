import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vision_vox/services/tts_service.dart';
import 'package:vision_vox/services/ocr_service.dart';

class TextToSpeechScreen extends StatefulWidget {
  const TextToSpeechScreen({super.key});

  @override
  State<TextToSpeechScreen> createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final TtsService _tts = TtsService();
  final OcrService _ocr = OcrService();
  final TextEditingController _ctrl = TextEditingController();

  File? _pickedImage;
  bool _isSpeaking = false;

  int _tapCounter = 0;
  DateTime? _lastTapTime;

  DateTime? _lastButtonTapTime;
  int _buttonTapCounter = 0;

  @override
  void initState() {
    super.initState();
    _tts.speak(
      "Welcome to Text to Speech. Capture a photo or pick from gallery. "
      "Text will be extracted and spoken automatically. "
      "Triple tap anywhere to pause or resume speech."
    );
  }

  Future<void> _captureImage() async {
    final picker = ImagePicker();
    final captured = await picker.pickImage(source: ImageSource.camera);
    if (captured != null) {
      _tts.speak("Camera opened");
      await _processImage(File(captured.path));
    } else {
      _tts.speak("No image captured.");
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      _tts.speak("Gallery opened");
      await _processImage(File(picked.path));
    } else {
      _tts.speak("No image selected.");
    }
  }

  Future<void> _processImage(File file) async {
    setState(() => _pickedImage = file);
    String extracted = await _ocr.extractText(file);

    setState(() => _ctrl.text = extracted.isNotEmpty ? extracted : "No text found in image.");

    if (extracted.isNotEmpty) {
      await _speakExtractedText(extracted);
    } else {
      await _tts.speak("No text found in the image.");
    }
  }

  Future<void> _speakExtractedText(String text) async {
    if (text.trim().isEmpty) return;
    setState(() => _isSpeaking = true);
    try {
      await _tts.speak(text);
    } finally {
      if (mounted) setState(() => _isSpeaking = false);
    }
  }

  Future<void> _toggleSpeaking() async {
    if (_isSpeaking) {
      _tts.stop();
      setState(() => _isSpeaking = false);
      await _tts.speak("Paused");
    } else {
      final text = _ctrl.text.trim();
      if (text.isNotEmpty) {
        await _speakExtractedText(text);
      } else {
        await _tts.speak("No text to read.");
      }
    }
  }

  void _handleTap() {
    final now = DateTime.now();
    if (_lastTapTime == null || now.difference(_lastTapTime!) > const Duration(milliseconds: 600)) {
      _tapCounter = 1;
    } else {
      _tapCounter++;
    }
    _lastTapTime = now;

    if (_tapCounter >= 3) {
      _toggleSpeaking();
      _tapCounter = 0;
      _lastTapTime = null;
    }
  }

  void _handleButtonTap(Future<void> Function() action, String name) {
    final now = DateTime.now();
    if (_lastButtonTapTime == null || now.difference(_lastButtonTapTime!) > const Duration(milliseconds: 500)) {
      _buttonTapCounter = 1;
    } else {
      _buttonTapCounter++;
    }
    _lastButtonTapTime = now;

    if (_buttonTapCounter == 1) {
      _tts.speak("$name option selected");
    } else if (_buttonTapCounter == 2) {
      action();
      _buttonTapCounter = 0;
      _lastButtonTapTime = null;
    }
  }

  @override
  void dispose() {
    _tts.stop();
    _ocr.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleTap,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Text to Speech',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          centerTitle: true,
          backgroundColor: cs.primary,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Updated heading to match the screenshot style
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Text to Speech',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: cs.primary,
                        letterSpacing: 1.0,
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
                    onPressed: () => _handleButtonTap(_captureImage, "Camera"),
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

                const SizedBox(height: 28),

                // Gallery button
                SizedBox(
                  width: double.infinity,
                  height: 130,
                  child: ElevatedButton.icon(
                    onPressed: () => _handleButtonTap(_pickImage, "Gallery"),
                    icon: Icon(Icons.photo_library, size: 60, color: cs.onSecondary),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28.0),
                      child: Text(
                        'Gallery',
                        style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: cs.onSecondary),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      backgroundColor: cs.secondary.withOpacity(0.85),
                      elevation: 8,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Extracted text area
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
                      child: TextField(
                        controller: _ctrl,
                        readOnly: true,
                        maxLines: null,
                        style: const TextStyle(fontSize: 18, height: 1.4),
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Extracted text will appear here...',
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Status row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Triple-tap anywhere to pause/resume',
                      style: TextStyle(color: cs.onBackground.withOpacity(.7)),
                    ),
                    Row(
                      children: [
                        Icon(
                          _isSpeaking ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                          color: _isSpeaking ? cs.primary : Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _isSpeaking ? 'Speaking' : 'Idle',
                          style: TextStyle(
                            color: _isSpeaking ? cs.primary : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}