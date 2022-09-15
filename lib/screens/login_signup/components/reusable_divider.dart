import 'package:flutter/material.dart';

import '../../../constants.dart';


class ReusableDivider extends StatelessWidget {
  const ReusableDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return                 Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: const <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 0.5,
                color: kGrey,
              ),
            ),
          ),
          Text('or', style: TextStyle(color: Colors.white),),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 0.5,
                color: kGrey,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
