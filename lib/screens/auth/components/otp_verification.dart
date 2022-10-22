import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/auth/components/custom_elevated_button.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../services/provider/login_provider.dart';
import '../../../size_config.dart';
import 'acc_alt_option.dart';
import 'header.dart';

class OTPVerification extends StatefulWidget {
  static String routeName = 'otpVerification';

  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  @override
  void initState() {
    super.initState();
    initializeTheme();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController code = TextEditingController();
  final _codeFormKey = GlobalKey<FormState>();
  late PinTheme submittedPinTheme;

  late PinTheme defaultPinTheme;
  late PinTheme focusedPinTheme;
  String error = '';

  void initializeTheme() {
    defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
  }

  void validator(context) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    await loginProvider.verifyOTP(code.text, context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final provider = Provider.of<LoginProvider>(context, listen: false);

    return Scaffold(
        backgroundColor: kPrimaryColor,
        key: _scaffoldKey,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const Header(),
                  SizedBox(
                    height: getProportionateScreenHeight(25),
                  ),
                  Text(
                    'Verification',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: getProportionateScreenHeight(25)),
                  ),
                  const SizedBox(height: 25),
                  Consumer<LoginProvider>(
                    builder: (context, loginProvider, _) {
                      return Pinput(
                        defaultPinTheme: const PinTheme(
                          width: 25,
                          height: 56,
                          textStyle: TextStyle(
                              fontSize: 20,
                              color: kSecondaryColor,
                              fontWeight: FontWeight.w600),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: kGrey,
                              ),
                            ),
                          ),
                        ),
                        focusedPinTheme: const PinTheme(
                          width: 25,
                          height: 56,
                          textStyle: TextStyle(
                              fontSize: 20,
                              color: kSecondaryColor,
                              fontWeight: FontWeight.w600),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: kSecondaryColor,
                              ),
                            ),
                          ),
                        ),
                        submittedPinTheme: const PinTheme(
                          width: 25,
                          height: 56,
                          textStyle: TextStyle(
                              fontSize: 20,
                              color: kSecondaryColor,
                              fontWeight: FontWeight.w600),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: kSecondaryColor,
                              ),
                            ),
                          ),
                        ),
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        showCursor: true,
                        length: 6,
                        onCompleted: (pin) async {
                          await loginProvider.verifyOTP(pin, context);
                        },
                      );
                    },
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Consumer<LoginProvider>(
                    builder: (context, loginProvider, _) {
                      return AccAltOption(
                          buttonText: 'Resend',
                          leadingText: 'Didn\'t receive code ?',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                    },
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20)),
                    child: Text(
                      "We've sent an SMS with an activation code to your phone",
                      style: TextStyle(
                        color: kGrey,
                        fontSize: getProportionateScreenHeight(18),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
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
            ),
          ],
        ));
  }
}
