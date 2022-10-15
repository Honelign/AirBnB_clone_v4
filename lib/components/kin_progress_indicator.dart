import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kin_music_player_app/constants.dart';

class KinProgressIndicator extends StatelessWidget {
  const KinProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SpinKitFadingCube(
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven
                  ? kSecondaryColor
                  : Color.fromARGB(255, 15, 57, 92),
            ),
          );
        },
        size: 22,
      ),
    );
  }
}
