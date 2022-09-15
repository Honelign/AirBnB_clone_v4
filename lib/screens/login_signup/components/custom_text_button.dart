import 'package:flutter/material.dart';


class CustomTextButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final String text;
  const CustomTextButton({Key? key,required this.text,required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return                 InkWell(
      onTap:onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.centerRight,
        child:  Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
