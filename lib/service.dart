import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class TFService {
  Interpreter? _interpreter;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/mobilenet_v1_1.0_224.tflite',
      );
      debugPrint('Model loaded successfully');
      if (_interpreter != null) {
        final inputShape = _interpreter!.getInputTensor(0).shape;
        final outputShape = _interpreter!.getOutputTensor(0).shape;
        debugPrint('Input shape: $inputShape, output shape: $outputShape');
      }
    } catch (e) {
      debugPrint('Error loading model: $e');
    }
  }

  Future<List<double>> runModel(List<List<List<List<double>>>> input) async {
    if (_interpreter == null) {
      debugPrint('Model not loaded');
      return [];
    }
    final formatedOutput = [
      List<double>.generate(1001, (i) => 0.0).toList(),
    ];

    try {
      _interpreter!.run(input, formatedOutput);
      // debugPrint('Result sample is ${formatedOutput[0].toStringAsFixed(10)}');
      // debugPrint('Result is $formatedOutput');
      debugPrint('Result output is ${formatedOutput[0]}');
      return formatedOutput[0];
    } catch (e) {
      debugPrint('Error running model: $e');
      return [];
    }
  }

  // List<List<List<List<double>>>> input = List.generate(
  //   1, (i) => List.generate(
  //     224, (j) => List.generate(
  //       224, (k) => List.generate(
  //         3, (l) => 0.5,
  //       ),
  //     ),
  //   ),
  // );
}
