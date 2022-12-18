import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //Obtain name from storage
  final name = 'myname';

  if (message.data['type'] == 'alert' && message.data['name'] != name) {
    final preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    await preferences.setString('alert_key', message.data['name']);
    FlutterForegroundTask.wakeUpScreen();
    FlutterForegroundTask.launchApp();
  }
  if (message.data['type'] == 'alertResponse' && message.data['name'] == name) {
    //_receivedAlertResponsesController.add("");
  }
}
