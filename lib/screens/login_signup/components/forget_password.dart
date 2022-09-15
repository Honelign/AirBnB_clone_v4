import 'package:flutter/material.dart';
import 'package:kin_music_player_app/size_config.dart';

import '../../../constants.dart';
import 'custom_elevated_button.dart';
import 'header.dart';
import '../../../components/kin_form.dart';

class ForgetPassword extends StatelessWidget {
  static String routeName = 'forgetPassword';

  ForgetPassword({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryColor,
        key: _scaffoldKey,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const Header(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20),),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: getProportionateScreenHeight(50),),
                        KinForm(
                          hint: 'Enter your email',
                          controller: email,
                          headerTitle: 'Forget password ?',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(35)),
                  CustomElevatedButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      text: 'Submit'),
                ],
              ),
            ),
            Positioned(
              top: getProportionateScreenHeight(25),
              left: getProportionateScreenWidth(10),
              right: 0,
              child: Align(
                alignment: Alignment.topLeft,
                child: BackButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            )
          ],
        ));
  }
}
