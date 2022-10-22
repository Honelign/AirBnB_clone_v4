import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/auth/components/acc_alt_option.dart';
import 'package:kin_music_player_app/screens/auth/components/custom_elevated_button.dart';
import 'package:kin_music_player_app/screens/auth/components/enter_full_name.dart';
import 'package:kin_music_player_app/screens/auth/components/reusable_divider.dart';
import 'package:kin_music_player_app/screens/auth/components/social_login.dart';
import 'package:kin_music_player_app/screens/auth/register_page.dart';
import 'package:kin_music_player_app/size_config.dart';

class PhoneNumberLogin extends StatefulWidget {
  PhoneNumberLogin({Key? key}) : super(key: key);

  @override
  State<PhoneNumberLogin> createState() => _PhoneNumberLoginState();
}

class _PhoneNumberLoginState extends State<PhoneNumberLogin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _phoneNumberFormKey = GlobalKey<FormState>();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController prefix = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer
              SizedBox(
                height: getProportionateScreenHeight(35),
              ),

              // OTP FORM
              Form(
                key: _phoneNumberFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: _buildKinForm(
                  context,
                  // hint: "",
                  controller: phoneNumber,
                  headerTitle: 'Phone Number',
                ),
              ),

              // Spacer
              SizedBox(height: getProportionateScreenHeight(35)),

              // BUTTON
              CustomElevatedButton(
                onTap: () async {
                  if (_phoneNumberFormKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EnterFullName(phoneNumber: phoneNumber.text),
                      ),
                    );
                  } else if (_phoneNumberFormKey.currentState!.validate()) {}
                },
                text: 'Proceed to OTP',
              ),

              // Spacer
              SizedBox(
                height: getProportionateScreenHeight(25),
              ),

              // TODO: Uncomment or Remove

              // const ReusableDivider(),
              // SizedBox(
              //   height: getProportionateScreenHeight(10),
              // ),
              // const SocialLogin(),
              // AccAltOption(
              //   buttonText: 'Register',
              //   leadingText: 'Don\'t have an account ?',
              //   onTap: () {
              //     Navigator.pushNamed(context, RegisterPage.routeName);
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  _buildKinForm(
    context, {
    headerTitle,
    hint,
    controller,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(10),
        horizontal: getProportionateScreenWidth(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            headerTitle!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              decoration: TextDecoration.none,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This Field is required';
                    }

                    if (headerTitle == 'Phone Number' &&
                        !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
                            .hasMatch(phoneNumber.text)) {
                      return "Phone number must be a number";
                    }
                    if (headerTitle == 'Phone Number' &&
                        !phoneNumber.text.startsWith('+', 0)) {
                      return "Start with +";
                    }
                    if (headerTitle == 'Phone Number' &&
                        phoneNumber.text.length < 13) {
                      return "Phone Number  digit should be 13";
                    }
                  },
                  onFieldSubmitted: (va) {},
                  controller: controller,
                  style: const TextStyle(
                    color: kSecondaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLength: 14,
                  maxLines: 1,
                  cursorColor: kLightTextColor,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(fontSize: 14, color: kGrey),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: kGrey,
                      ),
                    ),
                    disabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: kGrey,
                      ),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: kGrey,
                      ),
                    ),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: kGrey,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
