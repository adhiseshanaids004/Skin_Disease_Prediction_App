// lib/services/ai_service.dart

class AIService {
  static Future<Map<String, dynamic>> predictDisease(String imagePath) async {
    // Simulate delay to mimic real AI model prediction
    await Future.delayed(const Duration(seconds: 2));

    // Return a mock result
    return {
      'disease': 'Eczema',
      'description':
          'Eczema is a condition that causes the skin to become inflamed, itchy, red, cracked, and rough.',
      'remedy':
          'Apply moisturizers frequently, use anti-itch creams, avoid long hot showers.',
      'doctor': 'Consult a Dermatologist',
      'prevent': 'Keep your skin hydrated and avoid known irritants or allergens.',
    };
  }
}
