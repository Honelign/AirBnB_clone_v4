import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/auth/components/header.dart';
import 'package:kin_music_player_app/screens/auth/components/login_signup_tab_bar.dart';
import 'package:kin_music_player_app/size_config.dart';

class LoginSignUpBody extends StatelessWidget {
  const LoginSignUpBody({Key? key}) : super(key: key);
  static String routeName = '/loginSignUp';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        decoration: linearGradientDecoration,
        child: Column(
          children: [
            const Header(),
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            const Expanded(child: LoginSignUpTabBar()),
          ],
        ),
      ),
    );
  }
}
