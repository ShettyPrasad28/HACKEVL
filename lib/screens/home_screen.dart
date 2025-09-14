import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vision_vox/screens/note_detection_screen.dart';
import 'package:vision_vox/screens/text_to_speech_screen.dart';
import 'package:vision_vox/screens/navigation_screen.dart';
import 'package:vision_vox/screens/object_detection_screen.dart';
import 'package:vision_vox/services/tts_service.dart';
import 'package:vision_vox/widgets/feature_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tts = Provider.of<TtsService>(context, listen: false);
      tts.speak(
        "Welcome to Vision Vox. You have four options. "
        "Text to Speech, Note Detection, Navigation, and Object Detection. "
        "Single tap to hear the feature name, double tap to open."
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tts = Provider.of<TtsService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vision Vox'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: ListView(
            children: [
              // Header banner
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      cs.primary.withOpacity(.12),
                      cs.secondary.withOpacity(.12)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.visibility, size: 40, color: cs.primary),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Assistive AI for everyday independence',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: cs.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Text to Speech
              FeatureCard(
                title: 'Text to Speech',
                caption: 'OCR → Voice',
                icon: Icons.record_voice_over,
                accentBlend: true,
                onTapAction: () {
                  tts.speak("Text to Speech. Double tap to open this feature.");
                },
                onDoubleTapAction: () {
                  tts.speak("Opening Text to Speech");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TextToSpeechScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Note Detection
              FeatureCard(
                title: 'Note Detection',
                caption: 'Currency helper',
                icon: Icons.currency_rupee_rounded,
                onTapAction: () {
                  tts.speak("Note Detection. Double tap to open this feature.");
                },
                onDoubleTapAction: () {
                  tts.speak("Opening Note Detection");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NoteDetectionScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Navigation
              FeatureCard(
                title: 'Navigation',
                caption: 'Real-time obstacle alerts',
                icon: Icons.explore_rounded,
                onTapAction: () {
                  tts.speak("Navigation. Double tap to open this feature.");
                },
                onDoubleTapAction: () {
                  tts.speak("Opening Navigation");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NavigationScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            // Object Detection
            FeatureCard(
              title: 'Object Detection',
              caption: 'Identify surrounding objects',
              icon: Icons.camera_alt, // changed from camera_search_rounded
              accentBlend: true,
              onTapAction: () {
                tts.speak("Object Detection. Double tap to open this feature.");
              },
              onDoubleTapAction: () {
                tts.speak("Opening Object Detection");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ObjectDetectionScreen(),
                  ),
                );
              },
            ),

            ],
          ),
        ),
      ),
    );
  }
}
