import 'package:alert_app/bloc/alert_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertObserver extends StatefulWidget {
  final Widget child;
  const AlertObserver({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<AlertObserver> createState() => _AlertObserverState();
}

class _AlertObserverState extends State<AlertObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final alert = context.read<AlertBloc>();
      alert.add(CheckBackgroundAlert());
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
