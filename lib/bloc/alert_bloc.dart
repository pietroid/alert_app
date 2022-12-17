import 'package:alert_app/repository/alert_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final AlertRepository _alertRepository;
  final responseWaitTime = 10;

  AlertBloc({required AlertRepository alertRepository})
      : _alertRepository = alertRepository,
        super(AlertConnectingState()) {
    on<Connect>((event, emit) async {
      try {
        await _alertRepository.connect();
        _alertRepository.receivedAlerts.listen((String name) {
          add(ReceiveAlert(name));
        });
        _alertRepository.receivedAlertResponses.listen((data) {
          add(ReceiveAlertResponse());
        });
        emit(AlertIdleState());
      } catch (error) {
        emit(AlertFailureState());
      }
    });

    on<SendAlert>((event, emit) async {
      emit(AlertSendingState());
      try {
        _alertRepository.sendAlert();
        await Future.delayed(Duration(seconds: responseWaitTime), () {
          if (state is AlertSendingState) {
            emit(AlertFailureState());
          }
        });
      } catch (error) {
        emit(AlertFailureState());
      }
    });

    on<ReceiveAlert>((event, emit) async {
      emit(AlertReceivingState(event.senderName));
      await Future.delayed(Duration(seconds: responseWaitTime), () {
        if (state is AlertReceivingState) {
          emit(AlertIdleState());
        }
      });
    });

    on<SendAlertResponse>((event, emit) {
      if (state is AlertReceivingState) {
        _alertRepository
            .sendAlertResponse((state as AlertReceivingState).senderName);
        emit(AlertIdleState());
      }
    });

    on<ReceiveAlertResponse>((event, emit) async {
      if (state is AlertSendingState) {
        emit(AlertSeenState());
      }
    });
  }
}

abstract class AlertEvent {}

class Connect extends AlertEvent {}

class SendAlert extends AlertEvent {}

class SendAlertResponse extends AlertEvent {}

class ReceiveAlert extends AlertEvent {
  final String senderName;

  ReceiveAlert(this.senderName);
}

class ReceiveAlertResponse extends AlertEvent {}

abstract class AlertState {}

class AlertConnectingState extends AlertState {}

class AlertSendingState extends AlertState {}

class AlertIdleState extends AlertState {}

class AlertReceivingState extends AlertState {
  final String senderName;

  AlertReceivingState(this.senderName);
}

class AlertSeenState extends AlertState {}

class AlertFailureState extends AlertState {}
