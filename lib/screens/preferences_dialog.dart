import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showPreferencesDialog(BuildContext context) {
  return showDialog(
      context: context, builder: (context) => PreferencesDialog());
}

class PreferencesDialog extends StatefulWidget {
  const PreferencesDialog({Key? key}) : super(key: key);

  @override
  State<PreferencesDialog> createState() => _PreferencesDialogState();
}

class _PreferencesDialogState extends State<PreferencesDialog> {
  String currentName = '';
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final preferences = await SharedPreferences.getInstance();
      final name = preferences.getString('user_name') ?? '';

      setState(() {
        _controller.text = name;
        currentName = name;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Escolha seu nome'),
      content: TextField(
        onChanged: (newText) {
          setState(() {
            currentName = newText;
          });
        },
        controller: _controller,
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final preferences = await SharedPreferences.getInstance();
            await preferences.setString('user_name', currentName);
            Navigator.pop(context);
          },
          child: Text('OK'),
        )
      ],
    );
  }
}
