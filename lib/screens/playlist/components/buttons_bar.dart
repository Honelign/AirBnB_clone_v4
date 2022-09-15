import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';
import '../../../playlist.dart';
import '../../../size_config.dart';

class ButtonsBar extends StatefulWidget {
  const ButtonsBar({Key? key}) : super(key: key);

  @override
  State<ButtonsBar> createState() => _ButtonsBarState();
}

class _ButtonsBarState extends State<ButtonsBar> {
  String? value = demoPlayList[0].playlist;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: kGrey.withOpacity(0.3),
      height: getProportionateScreenHeight(75),
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: getProportionateScreenWidth(100),
            child: DropdownButton<String>(
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                value: value,
                style: const TextStyle(
                  color: kPrimaryColor,
                ),
                onChanged: (val) {
                  setState(() {
                    value = val;
                  });
                },
                hint: Text(
                  demoPlayList[0].playlist!,

                ),
                underline: Container(),
                items: demoPlayList.map((Playlist playlist) {
                  return DropdownMenuItem<String>(
                    value: playlist.playlist,
                    child: Text(playlist.playlist!),
                  );
                }).toList()),
          ),
          Row(
            children: [
              SizedBox(
                width: getProportionateScreenWidth(25),
                child: SvgPicture.asset('assets/icons/shuffle.svg',
                    height: getProportionateScreenHeight(25),
                    color: Colors.white),
              ),
              SizedBox(
                width: getProportionateScreenWidth(10),
              ),
              SizedBox(
                width: getProportionateScreenWidth(25),
                child: SvgPicture.asset('assets/icons/repeat.svg',
                    height: getProportionateScreenHeight(20),
                    color: Colors.white),
              )
            ],
          )
        ],
      ),
    );
  }
}
