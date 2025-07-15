// lib/services/ai_service.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'skin_disease_classifier.dart';

class AIService {
  static final SkinDiseaseClassifier _classifier = SkinDiseaseClassifier();
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await _classifier.initialize();
      _isInitialized = true;
      debugPrint('AI Service initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize AI Service: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> predictDisease(String imagePath) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('Image file not found');
      }

      final result = await _classifier.predict(file);
      
      // Format the result to match what the UI expects
      return {
        'prediction': result['disease'],
        'confidence': (result['confidence'] as double).toStringAsFixed(2),
        'description': result['description'],
        'remedy': result['remedy'],
        'doctor': result['doctor'],
      };
    } catch (e) {
      debugPrint('Error during prediction: $e');
      rethrow;
    }
  }

  static void dispose() {
    _classifier.dispose();
    _isInitialized = false;
  }
}
