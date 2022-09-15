import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CustomElevatedButton extends StatelessWidget {
  final String? text;
  final GestureTapCallback? onTap;
  const CustomElevatedButton({Key? key,required this.onTap,required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return                   InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20)),
        padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(15)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius:
          const BorderRadius.all(Radius.circular(50)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: kSecondaryColor.withOpacity(0.35),
                offset: const Offset(2, 4),
                blurRadius: 3,
                spreadRadius: 0.5),
          ],
          gradient:  const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [kSecondaryColor, kLightSecondaryColor]),
        ),
        child: Text(
          text!,
          style: const TextStyle(
              fontSize: 18,
              color: Colors.white),
        ),
      ),
    );
  }
}
