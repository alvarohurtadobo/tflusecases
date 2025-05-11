import 'package:flutter/material.dart';
import 'package:tflusecases/service.dart';

class ModelScreen extends StatefulWidget {
  const ModelScreen({required this.tfService, super.key});
  final TFService tfService;

  @override
  State<ModelScreen> createState() => _ModelScreenState();
}

class _ModelScreenState extends State<ModelScreen> {
  String output = 'Press to excecute model';

  void runModel() async {
    try {
      final input = List.generate(
        1,
        (i) => List.generate(
          224,
          (j) => List.generate(224, (k) => List.generate(3, (l) => 0.5)),
        ),
      );
      debugPrint('Input of type ${input.runtimeType}');
      final results = await widget.tfService.runModel(input);
      setState(() {
        output = 'The result is $results';
      });
    } catch (e) {
      debugPrint('Catch error is: $e');
      setState(() {
        output = 'Error is: $e';
      });
    }
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
            Text(output),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: runModel, child: const Text('Run Model'))
          ],
        ),
      ),
    );
  }
}
