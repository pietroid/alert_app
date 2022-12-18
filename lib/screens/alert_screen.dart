import 'package:alert_app/bloc/alert_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  @override
  void initState() {
    context.read<AlertBloc>().add(Connect());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final alert = context.watch<AlertBloc>();
    return alert.state is AlertConnectingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Center(
            child: AlertButton(),
          );
  }
}

class AlertButton extends StatefulWidget {
  const AlertButton({Key? key}) : super(key: key);

  @override
  State<AlertButton> createState() => _AlertButtonState();
}

class _AlertButtonState extends State<AlertButton> {
  @override
  Widget build(BuildContext context) {
    final alert = context.watch<AlertBloc>();

    String status = '';
    String? label;
    Function()? onPressed;
    if (alert.state is AlertIdleState ||
        alert.state is AlertSeenState ||
        alert.state is AlertFailureState) {
      label = 'chamar';
      onPressed = () => alert.add(SendAlert());
      if (alert.state is AlertFailureState) {
        status = 'Não respondido. Tente novamente';
      }
      if (alert.state is AlertSeenState) {
        status = 'Respondido! Aguarde um pouco';
      }
    } else if (alert.state is AlertSendingState) {
      label = 'Chamando...';
    } else if (alert.state is AlertReceivingState) {
      label = 'Responder';
      status = '${(alert.state as AlertReceivingState).senderName} chamando!!!';
      onPressed = () => alert.add(SendAlertResponse());
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Text(
            status,
            style: TextStyle(fontSize: 16),
          ),
        ),
        ElevatedButton(
          child: Text(
            label ?? '',
            style: TextStyle(fontSize: 20),
          ),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(80),
          ),
        ),
      ],
    );
  }
}
