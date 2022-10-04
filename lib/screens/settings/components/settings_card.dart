import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/login_signup/login_signup_body.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class SettingsCard extends StatelessWidget {
  final String? title;
  final IconData? iconData;
  final String? data;
  const SettingsCard(
      {Key? key, required this.title, required this.iconData, this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(15),
          horizontal: getProportionateScreenWidth(20),
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () {
            if (title == "Logout") {
              showDialog(
                  context: context,
                  builder: (context) {
                    var podcastProvider =
                        Provider.of<PodcastPlayer>(context, listen: false);
                    var musicProvider =
                        Provider.of<MusicPlayer>(context, listen: false);
                    var radioProvider =
                        Provider.of<RadioProvider>(context, listen: false);

                    return AlertDialog(
                      backgroundColor: kPopupMenuBackgroundColor,
                      title: Text(
                        'Are you sure?',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            final provider = Provider.of<LoginProvider>(context,
                                listen: false);

                            musicProvider.player.stop();
                            musicProvider.setMusicStopped(true);
                            musicProvider.setMiniPlayerVisibility(false);
                            musicProvider.listenMusicStreaming();

                            podcastProvider.player.stop();
                            podcastProvider.setEpisodeStopped(true);
                            podcastProvider.setMiniPlayerVisibility(false);
                            podcastProvider.listenPodcastStreaming();

                            radioProvider.player.stop();
                            radioProvider.setIsPlaying(false);
                            radioProvider.setMiniPlayerVisibility(false);

                            await provider.logOut();
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Logged Out'),
                              ),
                            );
                            Navigator.pushReplacementNamed(
                                context, LoginSignUpBody.routeName);
                          },
                          child: const Text(
                            'Yes',
                            style: TextStyle(color: kSecondaryColor),
                          ),
                        ),
                        TextButton(
                          child: const Text(
                            'No',
                            style: TextStyle(color: kSecondaryColor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(title ?? ''),
                    backgroundColor: kPopupMenuBackgroundColor,
                    content: SingleChildScrollView(
                      child: Html(
                        data: data!,
                      ),
                    ),
                  );
                },
              );
            }
          },
          child: ListTile(
            title: Text(
              title!,
              style: TextStyle(color: Colors.white.withOpacity(0.75)),
            ),
            leading: Icon(
              iconData,
              color: Colors.white.withOpacity(0.75),
            ),
          ),
        ));
  }
}
