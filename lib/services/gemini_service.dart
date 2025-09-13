import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';


class GeminiService {
  // Use a private constructor for the singleton pattern
  GeminiService._();
  static final GeminiService instance = GeminiService._();

  // NOTE: Replace this with your actual API key
  // You can get one from Google AI Studio: https://aistudio.google.com/
  static const String _apiKey = 'AIzaSyBKeY62MZPIF0wHMAMqJkOYnjPQkcDLUMU';

  // Initialize the Generative AI model
  final GenerativeModel _model = GenerativeModel(
    // Use the 'gemini-1.5-flash' model for faster vision responses
    model: 'gemini-1.5-flash-latest', 
    apiKey: _apiKey,
  );

  /// Takes image bytes and returns a textual description of the scene.
  Future<String> getDescriptionFromImage(Uint8List imageBytes) async {
    try {
      // This is the instruction you give to the AI.
      // A well-crafted prompt gives much better results.
      final prompt = TextPart(
          "You are an assistant for a visually impaired person. "
          "Briefly and clearly describe the immediate surroundings. "
          "Focus on obstacles, potential hazards, and the direction of the path. "
          "Be concise and direct."
      );

      // The image data
      final imagePart = DataPart('image/jpeg', imageBytes);

      // Send the prompt and image to the Gemini API
      final response = await _model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      // Return the AI's response, or a fallback message if it's empty
      return response.text ?? "I'm sorry, I couldn't describe what I see.";
    } catch (e) {
      // Handle potential errors (e.g., network issues, invalid API key)
      print("Error calling Gemini API: $e");
      return "Error: Could not analyze the image.";
    }
  }
}