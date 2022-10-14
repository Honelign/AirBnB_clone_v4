import 'package:flutter/material.dart';
import 'components/settings_body.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: const SettingsBody(),
        ),
      ),
    );
  }
}
