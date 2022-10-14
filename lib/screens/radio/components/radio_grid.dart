import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kin_music_player_app/services/network/model/radio.dart';

class RadioCardGrid extends StatelessWidget {
  final RadioStation station;
  const RadioCardGrid({Key? key, required this.station}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      width: 108,
      height: 106,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            station.coverImage,
          ),
        ),
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [BoxShadow()],
      ),
    );
  }
}
