import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tflusecases/app/app.dart';
import 'package:tflusecases/counter/counter.dart';
import 'package:tflusecases/service.dart';
import 'package:tflusecases/voide/services/speech_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final tfService = TFService();
  await tfService.loadModel();
  final speechService = SpeechService();
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(
        App(
          service: tfService,
          speechService: speechService,
        ),
      );
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
