import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflusecases/product/views/native_comunicator.dart';
import 'package:tflusecases/service.dart';
import 'package:tflusecases/voide/services/speech_service.dart';

class ModelScreen extends StatefulWidget {
  const ModelScreen({
    required this.tfService,
    required this.speechService,
    super.key,
  });
  final TFService tfService;
  final SpeechService speechService;

  @override
  State<ModelScreen> createState() => _ModelScreenState();
}

class _ModelScreenState extends State<ModelScreen> {
  String _output = 'Press to excecute model';

  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _runModel() async {
    if (_image == null) {
      setState(() {
        _output = 'Please select an image';
      });
    }

    try {
      // final input = List.generate(
      //   1,
      //   (i) => List.generate(
      //     224,
      //     (j) => List.generate(224, (k) => List.generate(3, (l) => 0.5)),
      //   ),
      // );
      // debugPrint('Input of type ${input.runtimeType}');
      final results = await widget.tfService.runModel(_image!);
      setState(() {
        _output = 'The result is $results';
      });
    } catch (e) {
      debugPrint('Catch error is: $e');
      setState(() {
        _output = 'Error is: $e';
      });
    }
  }

  Future<void> _takePicture() async {
    try {
      final String? imagePath =
          await NativeComunicator.invokeNativeMethod('takePicture');
      if (imagePath != null) {
        setState(() {
          _image = File(imagePath);
        });
      }
    } on PlatformException catch (e) {
      _output = 'Error taking picture: ${e.message}';
    }
  }

  void _toogleListening() {
    if (widget.speechService.isListening) {
      widget.speechService.stopListening();
    } else {
      widget.speechService.startListening();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Model'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image == null)
              const Text('No image chosen')
            else
              Image.file(
                _image!,
                height: 200,
              ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Take picture'),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(_output),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _runModel,
              child: const Text('Run Model'),
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Recognized text: ${widget.speechService.recognizedText}'),
            ElevatedButton(
              onPressed: _toogleListening,
              child: widget.speechService.isListening
                  ? const Text('Stop listening')
                  : const Text('Start listening'),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await NativeComunicator.invokeNativeMethod(
                  'getBatteryLevel',
                );
                debugPrint('Battery level is $result');
              },
              child: const Text('Get battery level'),
            ),
            ElevatedButton(
              onPressed: _takePicture,
              child: const Text('Get Picture'),
            ),
          ],
        ),
      ),
    );
  }
}
