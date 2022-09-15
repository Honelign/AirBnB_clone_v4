import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';
import '../../../playlist.dart';
import '../../../size_config.dart';

class PlayListAppBar extends StatelessWidget {
  const PlayListAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 175,
      pinned: true,
      backgroundColor: kPrimaryColor,
      elevation: 2,
      automaticallyImplyLeading: false,
      title: const Text('My PlayList'),
      bottom:  PreferredSize(
        preferredSize: const Size(double.infinity, 75),
        child: _buttonBar(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/kin.png',
              fit: BoxFit.cover,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF343434).withOpacity(0.4),
                    const Color(0xFF343434).withOpacity(0.7),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buttonBar(context) {
    String? value = demoPlayList[0].playlist;
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
                  value = val;
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
