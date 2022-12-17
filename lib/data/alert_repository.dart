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

  //TODO: this is determined by settings
  final name = 'myname';

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
    final lastAlert = preferences.getString('alert') ?? '';
    if (lastAlert != '' && lastAlert != name) {
      await preferences.setString('alert', '');
      _receivedAlertsController.add(lastAlert);
    }
  }

  Future<void> messagingForegroundHandler(RemoteMessage message) async {
    if (message.data['type'] == 'alert' && message.data['name'] != name) {
      _receivedAlertsController.add(message.data['name']);
    }
    if (message.data['type'] == 'alertResponse' &&
        message.data['name'] == name) {
      _receivedAlertResponsesController.add("");
    }
  }

  void sendAlert() => AlertDataSource().sendPushToFCM({
        'name': name,
        'type': 'alert',
      });

  void sendAlertResponse(String responseName) =>
      AlertDataSource().sendPushToFCM({
        'name': responseName,
        'type': 'alertResponse',
      });

  Stream<String> get receivedAlerts => _receivedAlertsController.stream;
  Stream<String> get receivedAlertResponses =>
      _receivedAlertResponsesController.stream;
}
