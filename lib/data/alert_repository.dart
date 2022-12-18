import 'dart:async';

import 'package:alert_app/data/alert_datasource.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'background_handler.dart';

class AlertRepository {
  final StreamController<String> _receivedAlertsController = StreamController();
  final StreamController<String> _receivedAlertResponsesController =
      StreamController();

  Future<void> initialize() async {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.subscribeToTopic("all");

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(
      messagingForegroundHandler,
    );
  }

  void checkBackgroundAlert() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    final lastAlert = preferences.getString('alert_key') ?? '';
    final userName = preferences.getString('user_name');
    if (lastAlert != '' && lastAlert != userName) {
      await preferences.setString('alert_key', '');
      _receivedAlertsController.add(lastAlert);
    }
  }

  Future<void> messagingForegroundHandler(RemoteMessage message) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    final userName = preferences.getString('user_name');
    if (message.data['type'] == 'alert' && message.data['name'] != userName) {
      _receivedAlertsController.add(message.data['name']);
    }
    if (message.data['type'] == 'alertResponse' &&
        message.data['name'] == userName) {
      _receivedAlertResponsesController.add("");
    }
  }

  void sendAlert() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    final userName = preferences.getString('user_name');
    AlertDataSource().sendPushToFCM({
      'name': userName,
      'type': 'alert',
    });
  }

  void sendAlertResponse(String responseName) =>
      AlertDataSource().sendPushToFCM({
        'name': responseName,
        'type': 'alertResponse',
      });

  Stream<String> get receivedAlerts => _receivedAlertsController.stream;
  Stream<String> get receivedAlertResponses =>
      _receivedAlertResponsesController.stream;
}
