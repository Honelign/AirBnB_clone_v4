import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_form.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/auth/components/custom_elevated_button.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
        backgroundColor: const Color(0xFF052c54),
        elevation: 0,
      ),
      body: Container(
        decoration: linearGradientDecoration,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            children: [
              // Spacer
              const SizedBox(
                height: 24,
              ),

              // Input Field
              KinForm(
                hint: 'Enter your email',
                headerTitle: 'Email',
                controller: email,
              ),

              // Spacer
              const SizedBox(
                height: 36,
              ),

              // Submit Button
              isLoading == true
                  ? const KinProgressIndicator()
                  : CustomElevatedButton(
                      onTap: () async {
                        if (email.text.isEmpty) {
                          kShowToast(message: "Invalid email");
                        } else {
                          if (isLoading == false) {
                            setState(() {
                              isLoading = true;
                            });
                            LoginProvider loginProvider = Provider.of(
                              context,
                              listen: false,
                            );

                            await loginProvider.resetPassword(
                              email: email.text.toString().trim(),
                            );

                            setState(() {
                              isLoading = false;
                            });

                            kShowToast(message: "Reset Link sent to email");
                          }
                        }
                      },
                      text: 'Reset Password',
                    )
            ],
          ),
        ),
      ),
    );
  }
}
