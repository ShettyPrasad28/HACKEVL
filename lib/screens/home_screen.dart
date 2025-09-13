import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vision_vox/screens/note_detection_screen.dart';
import 'package:vision_vox/screens/text_to_speech_screen.dart';
import 'package:vision_vox/screens/navigation_screen.dart';
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
      tts.speak("Welcome to Vision Vox. You have three options. "
          "Text to Speech for reading text aloud. "
          "Note Detection for recognizing Indian currency. "
          "Or Navigation for real-time obstacle detection.");
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tts = Provider.of<TtsService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vision Vox'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: ListView(
            children: [
              // Header banner
              Container(
                // ... (header code is unchanged)
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

              // ✅ CORRECTED ROW: Using a Spacer to push cards apart
              Row(
                children: [
                  Expanded(
                    flex: 5, // Give it 5 parts of the space
                    child: FeatureCard(
                      title: 'Text to Speech',
                      caption: 'OCR → Voice',
                      icon: Icons.record_voice_over,
                      accentBlend: true,
                      onTapAction: () {
                        tts.speak("Text to Speech. Reads text aloud.");
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
                  ),
                  const Spacer(flex: 1), // This creates the gap in the middle
                  Expanded(
                    flex: 5, // Give it 5 parts of the space
                    child: FeatureCard(
                      title: 'Note Detection',
                      caption: 'Currency helper',
                      icon: Icons.currency_rupee_rounded,
                      onTapAction: () {
                        tts.speak("Note Detection. Recognizes Indian currency.");
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
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Full width Navigation card (this remains the same)
              FeatureCard(
                title: 'Navigation',
                caption: 'Real-time obstacle alerts',
                icon: Icons.explore_rounded,
                onTapAction: () {
                  tts.speak(
                      "Navigation. Get real-time obstacle alerts to navigate your surroundings.");
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
            ],
          ),
        ),
      ),
    );
  }
}