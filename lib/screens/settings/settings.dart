import 'package:flutter/material.dart';
import '../../constants.dart';
import 'components/settings_body.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(child: SettingsBody()),
    );
  }
}
