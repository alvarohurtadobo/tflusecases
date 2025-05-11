import 'package:flutter/material.dart';
import 'package:tflusecases/app/app.dart';
import 'package:tflusecases/bootstrap.dart';
import 'package:tflusecases/service.dart';
import 'package:tflusecases/voide/services/speech_service.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final tfService = TFService();
  await tfService.loadModel();
  final speechService = SpeechService();
  await bootstrap(
    () => App(
      service: tfService,
      speechService: speechService,
    ),
  );
}
