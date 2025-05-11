import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
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

  Future<List<double>> runModel(File image) async {
    if (_interpreter == null) {
      debugPrint('Model not loaded');
      return [];
    }

    final imageInput = img.decodeImage(image.readAsBytesSync())!;

    final resizedImage = img.copyResize(imageInput, width: 224, height: 224);

    final input = List<List<List<List<double>>>>.generate(
      // List<List<List<List<double>>>>
      1,
      (i) => List.generate(
        224,
        (j) => List.generate(
          224,
          (k) => List.generate(
            3,
            (l) => 0,
          ),
        ),
      ),
    );

    for (var y = 0; y < resizedImage.height; y++) {
      for (var x = 0; x < resizedImage.width; x++) {
        final pixel = resizedImage.getPixel(x, y);
        // debugPrint('Pixel at $x, $y is $pixel');

        input[0][y][x][0] = pixel.r / 255.0;
        input[0][y][x][1] = pixel.g / 255.0;
        input[0][y][x][2] = pixel.b / 255.0;
      }
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

  void close() {
    _interpreter?.close();
  }
}
