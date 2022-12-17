import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  }

  void sendAlert() async {}

  void sendAlertResponse(String responseName) async {}

  Stream<String> get receivedAlerts => _receivedAlertsController.stream;
  Stream<String> get receivedAlertResponses =>
      _receivedAlertResponsesController.stream;
}
