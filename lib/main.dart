import 'package:alert_app/bloc/alert_bloc.dart';
import 'package:alert_app/data/alert_repository.dart';
import 'package:alert_app/screens/alert_screen.dart';
import 'package:alert_app/screens/preferences_dialog.dart';
import 'package:alert_app/widgets/alert_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BlocProvider(
    create: (_) => AlertBloc(alertRepository: AlertRepository()),
    child: MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: AlertApp(),
    ),
  ));
}

class AlertApp extends StatelessWidget {
  const AlertApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerta amor'),
        actions: [
          IconButton(
              onPressed: () => showPreferencesDialog(context),
              icon: Icon(
                Icons.settings,
              ))
        ],
      ),
      body: AlertObserver(
        child: AlertScreen(),
      ),
    );
  }
}
