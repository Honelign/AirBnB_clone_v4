import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/size_config.dart';

class AccAltOption extends StatelessWidget {
  final String? buttonText;
  final String? leadingText;
  final GestureTapCallback? onTap;

  const AccAltOption({
    Key? key,
    required this.buttonText,
    required this.leadingText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              leadingText!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            // Spacer
            SizedBox(
              width: getProportionateScreenWidth(10),
            ),

            // Text
            Text(
              buttonText!,
              style: const TextStyle(
                color: kSecondaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
