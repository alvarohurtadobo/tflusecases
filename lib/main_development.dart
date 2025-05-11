import 'package:flutter/material.dart';
import 'package:tflusecases/app/app.dart';
import 'package:tflusecases/bootstrap.dart';
import 'package:tflusecases/service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final tfService = TFService();
  await tfService.loadModel();
  await bootstrap(
    () => App(
      service: tfService,
    ),
  );
}
