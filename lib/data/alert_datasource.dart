import 'dart:convert';

import 'package:alert_app/env/keys.dart';
import 'package:http/http.dart' as http;

class AlertDataSource {
  void sendPushToFCM(Object data) => http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Authorization': 'key=$fcmKey',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          "to": "/topics/all",
          "data": data,
        }),
      );
}
