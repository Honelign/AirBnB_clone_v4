import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/custom_bottom_app_bar.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/screens/auth/components/acc_alt_option.dart';
import 'package:kin_music_player_app/screens/auth/components/custom_elevated_button.dart';
import 'package:kin_music_player_app/components/kin_form.dart';
import 'package:kin_music_player_app/screens/auth/reset_password_page.dart';
import 'package:kin_music_player_app/screens/auth/register_page.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:kin_music_player_app/screens/auth/components/reusable_divider.dart';
import 'package:kin_music_player_app/screens/auth/components/social_login.dart';
import 'package:kin_music_player_app/size_config.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({Key? key}) : super(key: key);

  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

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

              // Email Form
              KinForm(
                hint: 'Enter your email',
                headerTitle: 'Email',
                controller: email,
              ),

              // Password Form
              KinForm(
                hint: 'Enter your password',
                headerTitle: 'Password',
                controller: password,
                obscureText: true,
                hasIcon: true,
              ),

              // Spacer
              SizedBox(
                height: getProportionateScreenHeight(4),
              ),

              // Reset Password Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ResetPasswordPage(),
                          ),
                        );
                      },
                      child: const Text("Forgot Password"),
                    ),
                  ],
                ),
              ),

              // Spacer
              SizedBox(
                height: getProportionateScreenHeight(35),
              ),

              // Login Button
              isLoading == true
                  ? const KinProgressIndicator()
                  : CustomElevatedButton(
                      onTap: () async {
                        if (isLoading == false) {
                          // set loading animation
                          setState(() {
                            isLoading = true;
                          });

                          // get login provider
                          LoginProvider provider = Provider.of<LoginProvider>(
                              context,
                              listen: false);

                          // if email & password are valid
                          if (email.text.isNotEmpty &&
                              password.text.isNotEmpty) {
                            // make api call

                            var result =
                                await provider.login(email.text, password.text);

                            // redirect to home
                            if (result == 'Successfully Logged In') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CustomBottomAppBar(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(result),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please Fill all Field'),
                              ),
                            );
                          }
                        }

                        // end loading animation
                        setState(() {
                          isLoading = false;
                        });
                      },
                      text: 'Login',
                    ),

              // Spacer
              SizedBox(
                height: getProportionateScreenHeight(10),
              ),

              // OR DIVIDER
              const ReusableDivider(),

              // Spacer
              SizedBox(
                height: getProportionateScreenHeight(10),
              ),

              // Social Login Section
              const SocialLogin(),

              // Alternate Register Page
              AccAltOption(
                buttonText: 'Register',
                leadingText: 'Don\'t have an account ?',
                onTap: () {
                  Navigator.pushNamed(context, RegisterPage.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
