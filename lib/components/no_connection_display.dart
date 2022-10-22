import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';

class NoConnectionDisplay extends StatelessWidget {
  const NoConnectionDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Offline Icon
                const Icon(
                  Icons.wifi_off_outlined,
                  size: 80,
                  color: kSecondaryColor,
                ),

                // Spacer
                const SizedBox(
                  height: 4,
                ),

                // No Connection Message
                Text(
                  kConnectionErrorMessage,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),

                // Spacer
                const SizedBox(
                  height: 4,
                ),

                // No Connection Message
                Text(
                  kReconnectErrorMessage,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.15,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
