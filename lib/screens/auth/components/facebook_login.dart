import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/custom_bottom_app_bar.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class FacebookLogin extends StatelessWidget {
  const FacebookLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final provider = Provider.of<LoginProvider>(context, listen: false);

        var result = await provider.googleLogin();
        if (result == "Successfully Logged In") {
          Navigator.pushReplacementNamed(context, CustomBottomAppBar.routeName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result),
            ),
          );
        }
      },
      child: Image.asset(
        'assets/icons/Facebook.png',
        fit: BoxFit.contain,
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenWidth(50),
      ),
    );
  }
}
