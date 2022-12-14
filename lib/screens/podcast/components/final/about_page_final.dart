import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';

class AboutPage extends StatelessWidget {
  final String cover;
  final String title;
  final String description;
  final int numberOfSeasons;
  final int numberOfEpisodes;
  final String hostName;
  final String hostId;

  const AboutPage({
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
      body: SingleChildScrollView(
        child: Container(
          decoration: linearGradientDecoration,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                  imageUrl: cover,
                  imageBuilder: (context, img) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 360,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: img,
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  }),

              // Spacer
              const SizedBox(
                height: 16,
              ),

              // podcast name
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 48.0, 0),
                child: Text(
                  title,
                  style: const TextStyle(
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

                    const SizedBox(
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
      ),
    );
  }
}
