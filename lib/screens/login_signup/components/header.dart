import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'bezierContainer.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(250),
      child: Stack(
        children: [
          Positioned(
            bottom: getProportionateScreenHeight(50),
            left: getProportionateScreenWidth(175),
            child: const BezierContainer(),
          ),
          Positioned(
            top: getProportionateScreenHeight(100),
            child: Image.asset(
              'assets/images/logo.png',
              height: 100,
              width: 100,
            ),
            right: getProportionateScreenWidth(50),
            left: getProportionateScreenWidth(50),
          ),
        ],
      ),
    );
  }
}
