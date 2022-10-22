import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'components/header.dart';
import 'components/login_signup_tab_bar.dart';

class LoginSignUpBody extends StatelessWidget {
  const LoginSignUpBody({Key? key}) : super(key: key);
  static String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        decoration: linearGradientDecoration,
        child: Column(
          children: [
            // Kin Logo and Space
            const Header(),

            // Spacer
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),

            // Login Main Section
            const Expanded(
              child: LoginSignUpTabBar(),
            ),
          ],
        ),
      ),
    );
  }
}
