import 'package:flutter/material.dart';
import 'package:tflusecases/l10n/arb/app_localizations.dart';
import 'package:tflusecases/product/views/model_screen.dart';
import 'package:tflusecases/service.dart';
import 'package:tflusecases/voide/services/speech_service.dart';

class App extends StatelessWidget {
  const App({required this.service, required this.speechService, super.key});

  final TFService service;
  final SpeechService speechService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ModelScreen(
        tfService: service,
        speechService: speechService,
      ),
    );
  }
}
