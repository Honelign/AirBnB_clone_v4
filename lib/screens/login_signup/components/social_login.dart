import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:kin_music_player_app/components/custom_bottom_app_bar.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/login_signup/components/facebook_login.dart';
import 'package:kin_music_player_app/screens/login_signup/components/google_login.dart';
import 'package:kin_music_player_app/screens/login_signup/components/twitter_login.dart';
import 'package:kin_music_player_app/screens/login_signup/login_signup_body.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(56)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [GoogleLogin()],
      ),
    );
  }
}
