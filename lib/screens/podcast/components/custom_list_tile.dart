import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CustomListTile extends StatelessWidget {
  final String? title;
  final IconData? iconData;
  final Color? color;
  final String? data;
  const CustomListTile(
      {Key? key,
      required this.title,
      required this.data,
      required this.iconData,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              iconData!,
              color: color!,
            ),
            SizedBox(
              width: getProportionateScreenWidth(5),
            ),
            Text(
              title!,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        SizedBox(
          height: getProportionateScreenHeight(5),
        ),
        Text(
          data!,
          style: TextStyle(color: Colors.white.withOpacity(0.75)),
        )
      ],
    );
  }
}
