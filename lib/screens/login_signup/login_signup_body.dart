import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/login_signup/components/social_login.dart';

import '../../constants.dart';
import '../../size_config.dart';
import 'components/header.dart';
import 'components/login_signup_tab_bar.dart';

class LoginSignUpBody extends StatelessWidget {
  const LoginSignUpBody({Key? key}) : super(key: key);
  static String routeName = '/loginSignUp';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column(
        children: [
          const Header(),
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          const Expanded(child: LoginSignUpTabBar()),
        ],
      ),
    );
  }
}
