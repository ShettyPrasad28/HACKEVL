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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blueAccent,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Camera button
                SizedBox(
                  width: double.infinity,
                  height: 120,
                  child: ElevatedButton.icon(
                    onPressed: _captureImage,
                    icon: const Icon(Icons.camera_alt, size: 50),
                    label: const Text(
                      'Camera',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Gallery button
                SizedBox(
                  width: double.infinity,
                  height: 120,
                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_library, size: 50),
                    label: const Text(
                      'Gallery',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

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
                      'Triple-tap to pause/resume',
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
