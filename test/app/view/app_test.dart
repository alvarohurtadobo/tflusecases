import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tflusecases/app/app.dart';
import 'package:tflusecases/counter/counter.dart';
import 'package:tflusecases/service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final tfService = TFService();
  await tfService.loadModel();
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(
        App(
          service: tfService,
        ),
      );
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
