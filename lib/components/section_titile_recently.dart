// This section title is only for recently played

import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';

import '../screens/home/components/home_search_screen.dart';

class SectionTitleRecently extends StatelessWidget {
  const SectionTitleRecently({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: headerTextStyle
        ),
        // IconButton(icon: Icon(Icons.search,color: Colors.white,),onPressed: () {
        //   Navigator.pushNamed(context, HomeSearchScreen.routeName);
        // },)
      ],
    );
  }
}
