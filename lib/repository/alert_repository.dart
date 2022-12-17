import 'dart:async';
import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class AlertRepository {
  late IO.Socket _socket;
  final StreamController<String> _receivedAlertsController = StreamController();
  final StreamController<String> _receivedAlertResponsesController =
      StreamController();
  Completer connectionFuture = Completer<void>();

  //TODO: this is determined by settings
  final name = 'myname';

  Future<void> connect() {
    _socket = IO.io('https://alert-server-production.up.railway.app/',
        OptionBuilder().setTransports(['websocket']).build());
    connectionFuture = Completer<void>();
    log('started connection');
    _socket.onConnect((_) {
      connectionFuture.complete();
    });
    _socket.on('alert', (data) {
      if (data.toString() != name) {
        _receivedAlertsController.add(data.toString());
      }
    });
    _socket.on('alertResponse', (data) {
      if (data.toString() == name) {
        _receivedAlertResponsesController.add("");
      }
    });

    return connectionFuture.future;
  }

  void sendAlert() async {
    _socket.emit('alert', name);
  }

  void sendAlertResponse(String responseName) async {
    _socket.emit('alertResponse', responseName);
  }

  Stream<String> get receivedAlerts => _receivedAlertsController.stream;
  Stream<String> get receivedAlertResponses =>
      _receivedAlertResponsesController.stream;
}
