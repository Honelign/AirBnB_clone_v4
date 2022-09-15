import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:kin_music_player_app/components/custom_bottom_app_bar.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/login_signup/login_signup_body.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';

class GoogleLogin extends StatelessWidget {
  const GoogleLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final provider = Provider.of<LoginProvider>(context, listen: false);
        // await FacebookAuth.i.logOut();
        var result = await provider.googleLogin();
        if (result == "Successfully Logged In") {
          Navigator.pushReplacementNamed(context, CustomBottomAppBar.routeName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(result),
          ));
        }
      },
      child: Image.asset(
        'assets/icons/Google.png',
        fit: BoxFit.contain,
        // color: Colors.blueAccent,
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenWidth(50),
      ),
    );
  }
}
