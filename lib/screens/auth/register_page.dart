import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kin_music_player_app/components/custom_bottom_app_bar.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/auth/components/acc_alt_option.dart';
import 'package:kin_music_player_app/screens/auth/components/custom_elevated_button.dart';
import 'package:kin_music_player_app/screens/auth/components/reusable_divider.dart';
import 'package:kin_music_player_app/screens/auth/components/social_login.dart';
import 'package:kin_music_player_app/screens/auth/verify_email.dart';
import 'package:kin_music_player_app/services/network/model/user.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:provider/provider.dart';

import '../../size_config.dart';
import 'components/header.dart';

class RegisterPage extends StatefulWidget {
  static String routeName = '/register';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phoneName = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool obscureText = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          decoration: linearGradientDecoration,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const Header(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20)),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: getProportionateScreenHeight(35)),
                            _buildKinForm(
                              context,
                              hint: 'Enter your  name',
                              controller: fullName,
                              headerTitle: 'Name',
                            ),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            _buildKinForm(
                              context,
                              hint: 'Enter your email',
                              controller: email,
                              headerTitle: 'Email',
                            ),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            _buildKinForm(
                              context,
                              hint: 'Enter your phone number (0911..)',
                              controller: phoneName,
                              headerTitle: 'Phone number',
                            ),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            _buildKinForm(context,
                                hint: 'Enter password',
                                controller: password,
                                headerTitle: 'Password',
                                hasIcon: true, onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            }),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            _buildKinForm(context,
                                hint: 'Confirm your password',
                                controller: confirmPassword,
                                headerTitle: 'Confirm password',
                                hasIcon: true, onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            })
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(35)),
                    Consumer<LoginProvider>(
                      builder: (context, provider, _) {
                        if (provider.isLoading) {
                          return Center(child: KinProgressIndicator());
                        }
                        return CustomElevatedButton(
                          onTap: () async {
                            // var future = await FirebaseAuth
                            //     .instance.currentUser!.emailVerified
                            //     .toString();
                            if (_formKey.currentState!.validate()) {
                              final provider = Provider.of<LoginProvider>(
                                  context,
                                  listen: false);
                              var result = await provider.register(
                                CustomUser(
                                  name: fullName.text,
                                  id: 2,
                                  phoneNumber: phoneName.text,
                                  email: email.text,
                                  password: password.text,
                                  passwordConfirmation: confirmPassword.text,
                                ),
                              );
                              if (result == 'Successfully Registered') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CustomBottomAppBar(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(result),
                                ));
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Please Fill All Inputs."),
                              ));
                            }
                          },
                          text: 'Signup',
                        );
                      },
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(25),
                    ),
                    const ReusableDivider(),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    const SocialLogin(),
                    AccAltOption(
                        buttonText: 'Login',
                        leadingText: 'Do you have account ?',
                        onTap: () {
                          Navigator.pop(context);
                        }),
                    SizedBox(
                      height: getProportionateScreenHeight(15),
                    )
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
          ),
        ));
  }

  _buildKinForm(context,
      {hasIcon = false,
      headerTitle,
      hint,
      controller,
      GestureTapCallback? onPressed}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      margin: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(10),
          horizontal: getProportionateScreenWidth(15)),
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(color: kGrey, width: 1.75),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            headerTitle!,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                decoration: TextDecoration.none),
          ),
          TextFormField(
            maxLength: headerTitle == 'Phone number' ? 10 : null,
            keyboardType: headerTitle == 'Phone number'
                ? TextInputType.phone
                : TextInputType.name,
            // inputFormatters: [
            //   headerTitle == 'Phone number'
            //       ? FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            //       : FilteringTextInputFormatter.allow(RegExp(
            //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")),
            // ],
            autocorrect: false,
            enableSuggestions: false,
            validator: (value) {
              if (value!.isEmpty && !(headerTitle == 'Phone number')) {
                return 'Empty field is not valid';
              }
              if (headerTitle == 'Phone number' && value.isNotEmpty) {
                if (value.length < 10) {
                  return 'Enter valid phone number';
                }
              }
            },
            cursorColor: kGrey,
            style: const TextStyle(color: kGrey),
            controller: controller,
            obscureText: hasIcon ? obscureText : false,
            decoration: InputDecoration(
              errorStyle: const TextStyle(
                  fontSize: 12, height: 0.3, color: kSecondaryColor),
              suffixIcon: hasIcon
                  ? IconButton(
                      onPressed: onPressed,
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: kGrey,
                      ),
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
              hintStyle: const TextStyle(color: kGrey),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(10),
                  vertical: getProportionateScreenHeight(10)),
              hintText: hint,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              fillColor: Colors.transparent,
              filled: true,
            ),
          )
        ],
      ),
    );
  }
}
