import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';

class SkinDiseaseClassifier {
  static const String _modelPath = 'assets/models/skin_disease_model.tflite';
  static const String _labelsPath = 'assets/models/labels.txt';
  
  late Interpreter _interpreter;
  late List<String> _labels;
  bool _isInitialized = false;

  Future<void> initialize() async {
  if (_isInitialized) return;

  try {
    final interpreterOptions = InterpreterOptions();
    
    // Load model
    _interpreter = await Interpreter.fromAsset(
      _modelPath,
      options: interpreterOptions,
    );

    // Print input and output details
    final inputTensors = _interpreter.getInputTensors();
    final outputTensors = _interpreter.getOutputTensors();
    
    debugPrint('Input tensors: ${inputTensors.map((t) => t.toString())}');
    debugPrint('Output tensors: ${outputTensors.map((t) => t.toString())}');

    // Load labels
    final labelData = await rootBundle.loadString(_labelsPath);
    _labels = labelData.split('\n').map((e) => e.trim()).toList();
    
    _isInitialized = true;
  } catch (e) {
    debugPrint('Failed to initialize TFLite model: $e');
    rethrow;
  }
}

Future<Map<String, dynamic>> predict(File imageFile) async {
  if (!_isInitialized) {
    await initialize();
  }

  try {
    // Preprocess the image
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);
    
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Preprocess image
    final input = _preprocessImage(image);
    
    // Prepare output buffer with correct shape [1, 8]
    final output = <List<double>>[<double>[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
    
    // Run inference
    _interpreter.run(input, output);
    
    // Process output
    final prediction = _processOutput(output[0]);
    
    return {
      'disease': _labels[prediction['index']],
      'confidence': prediction['confidence'],
      'description': _getDiseaseDescription(_labels[prediction['index']]),
      'remedy': _getRemedy(_labels[prediction['index']]),
      'doctor': _getDoctorRecommendation(_labels[prediction['index']]),
    };
  } catch (e) {
    debugPrint('Error during prediction: $e');
    rethrow;
  }
}
   
List<List<List<List<double>>>> _preprocessImage(img.Image image) {
  // Convert to RGB if it's not already
  img.Image rgbImage;
  if (image.numChannels == 4) {
    rgbImage = img.Image(width: image.width, height: image.height);
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        rgbImage.setPixelRgba(x, y, pixel.r, pixel.g, pixel.b, 255);
      }
    }
  } else {
    rgbImage = image;
  }
  
  // Resize to 128x128 (changed from 224x224)
  final resized = img.copyResize(rgbImage, width: 128, height: 128);
  
  // Create a 4D tensor [1, 128, 128, 3]
  final input = List.generate(
    1,
    (_) => List.generate(
      128,
      (y) => List.generate(
        128,
        (x) {
          final pixel = resized.getPixel(x, y);
          return [
            (pixel.r.toDouble() / 255.0),  // R
            (pixel.g.toDouble() / 255.0),  // G
            (pixel.b.toDouble() / 255.0),  // B
          ];
        },
      ),
    ),
  );
  
  return input;
}


  Map<String, dynamic> _processOutput(List<double> output) {
    double maxProb = 0;
    int maxIndex = 0;
    
    for (int i = 0; i < 7; i++) {
      if (output[i] > maxProb) {
        maxProb = output[i];
        maxIndex = i;
      }
    }
    
    return {
      'index': maxIndex,
      'confidence': maxProb,
    };
  }

  String _getDiseaseDescription(String disease) {
    // Map the disease names to their localization keys
    final diseaseKeys = {
      'Actinic keratoses and intraepithelial carcinoma': 'actinic_keratoses',
      'Basal cell carcinoma': 'basal_cell_carcinoma',
      'Benign keratosis-like lesions': 'benign_keratosis',
      'Dermatofibroma': 'dermatofibroma',
      'Melanoma': 'melanoma',
      'Melanocytic nevi': 'melanocytic_nevi',
      'Vascular lesions': 'vascular_lesions',
    };
    
    final key = diseaseKeys[disease] ?? '';
    return key.isNotEmpty 
        ? 'descriptions.$key'.tr() 
        : 'No description available.';
  }

  String _getRemedy(String disease) {
    // Map the disease names to their localization keys
    final diseaseKeys = {
      'Actinic keratoses and intraepithelial carcinoma': 'actinic_keratoses',
      'Basal cell carcinoma': 'basal_cell_carcinoma',
      'Benign keratosis-like lesions': 'benign_keratosis',
      'Dermatofibroma': 'dermatofibroma',
      'Melanoma': 'melanoma',
      'Melanocytic nevi': 'melanocytic_nevi',
      'Vascular lesions': 'vascular_lesions',
    };
    
    final key = diseaseKeys[disease] ?? '';
    return key.isNotEmpty 
        ? 'remedies.$key'.tr() 
        : 'Consult a healthcare professional for treatment options.';
  }

  String _getDoctorRecommendation(String disease) {
    // Map the disease names to their localization keys
    final diseaseKeys = {
      'Actinic keratoses and intraepithelial carcinoma': 'actinic_keratoses',
      'Basal cell carcinoma': 'basal_cell_carcinoma',
      'Benign keratosis-like lesions': 'benign_keratosis',
      'Dermatofibroma': 'dermatofibroma',
      'Melanoma': 'melanoma',
      'Melanocytic nevi': 'melanocytic_nevi',
      'Vascular lesions': 'vascular_lesions',
    };
    
    final key = diseaseKeys[disease] ?? '';
    return key.isNotEmpty 
        ? 'doctor_recommendations.$key'.tr() 
        : 'Consult a dermatologist for proper evaluation.';
  }

 
  void dispose() {
    _interpreter.close();
    _isInitialized = false;
    debugPrint('SkinDiseaseClassifier disposed');
  }
}