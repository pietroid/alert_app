import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //Obtain name from storage
  final preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final userName = preferences.getString('user_name');

  if (message.data['type'] == 'alert' && message.data['name'] != userName) {
    await preferences.setString('alert_key', message.data['name']);
    FlutterForegroundTask.wakeUpScreen();
    FlutterForegroundTask.launchApp();
  }
  if (message.data['type'] == 'alertResponse' &&
      message.data['name'] == userName) {
    //_receivedAlertResponsesController.add("");
  }
}
