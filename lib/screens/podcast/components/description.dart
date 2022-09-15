import 'package:flutter/material.dart';

import '../../../size_config.dart';

class Description extends StatelessWidget {
  const Description({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return         Container(
      margin: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20)),
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenHeight(15)),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Description',
            style: TextStyle(
                color: Colors.white,
                fontSize: getProportionateScreenHeight(20)),
          ),
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(10)),
            child: Text(
              description,
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }
}
const String description =
    'Listen to the latest news on economic growth, education, gender equality & climate change. Each episode covers a different topic in 20min. Subscribe today - never miss an episode. Worldwide News. World Bank Group Podcast. Subscribe Today.';
