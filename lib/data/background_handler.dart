import 'package:app_to_foreground/app_to_foreground.dart';
import 'package:bg_launcher/bg_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //Obtain name from storage
  final name = 'myname';

  if (message.data['type'] == 'alert' && message.data['name'] != name) {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('alert', message.data['name']);

    AppToForeground.appToForeground();
  }
  if (message.data['type'] == 'alertResponse' && message.data['name'] == name) {
    //_receivedAlertResponsesController.add("");
  }
}
