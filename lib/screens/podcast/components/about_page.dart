import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';

class AboutPage extends StatelessWidget {
  String cover;
  String title;
  String description;
  int numberOfSeasons;
  int numberOfEpisodes;
  String hostName;
  String hostId;

  AboutPage({
    Key? key,
    required this.title,
    required this.description,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.hostId,
    required this.hostName,
    required this.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 360,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(cover),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            // Spacer
            SizedBox(
              height: 16,
            ),

            // podcast name
            Padding(
              padding: EdgeInsets.fromLTRB(6, 0, 48.0, 0),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Description
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 8, 48, 0),
              child: Text(
                description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
            ),

            // Spacer
            const SizedBox(
              height: 24,
            ),

            // Count display
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(
                6,
                0,
                64,
                0,
              ),
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Episode Count
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //

                      const Icon(
                        Icons.live_tv_rounded,
                        color: kGrey,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Center(
                        child: Text(
                          numberOfEpisodes.toString() + " Episodes",
                          style: const TextStyle(
                            color: kGrey,
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    width: 64,
                  ),
                  // Season Count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //

                      // Icon(Icons.),
                      const Icon(
                        Icons.live_tv_rounded,
                        color: kGrey,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        numberOfSeasons.toString() + " Seasons",
                        style: const TextStyle(
                          color: kGrey,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
