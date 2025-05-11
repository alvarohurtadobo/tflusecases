import 'package:flutter/material.dart';
import 'package:tflusecases/l10n/l10n.dart';
import 'package:tflusecases/product/views/modelScreen.dart';
import 'package:tflusecases/service.dart';

class App extends StatelessWidget {
  const App({required this.service, super.key});

  final TFService service;

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
      ),
    );
  }
}
