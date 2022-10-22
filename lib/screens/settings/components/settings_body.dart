import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/auth/login_signup_body.dart';
import 'package:kin_music_player_app/screens/settings/components/Setting_card_artist.dart';
import 'package:kin_music_player_app/screens/settings/components/settings_tip_buy_card.dart';
import 'package:kin_music_player_app/screens/settings/old/user_account_header.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';

import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_card.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({Key? key}) : super(key: key);

  // get cached info
  Future<Map<String, dynamic>> getCacheInfo() async {
    try {
      SharedPreferences cachedInfo = await SharedPreferences.getInstance();
      String uid = cachedInfo.getString('id') ?? "";
      String username = cachedInfo.getString('name$uid') ?? "";
      String email = cachedInfo.getString('email$uid') ?? "";
      String privilege = cachedInfo.getString("prev$uid") ?? "";

      return {
        "id": uid,
        "username": username,
        "email": email,
        "prev": privilege
      };
    } catch (e) {
      return {"id": "", "username": "", "email": "", "prev": "-1"};
    }

// return user info json
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getCacheInfo(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const KinProgressIndicator();
        }

        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF052C54),
                const Color(0xFFD9D9D9).withOpacity(0.7),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Main Info
              Column(
                children: [
                  // Spacer
                  const SizedBox(
                    height: 24,
                  ),

                  // Logout Button
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (context) {
                                var podcastProvider =
                                    Provider.of<PodcastPlayer>(
                                  context,
                                  listen: false,
                                );
                                var musicProvider = Provider.of<MusicPlayer>(
                                  context,
                                  listen: false,
                                );
                                var radioProvider = Provider.of<RadioProvider>(
                                  context,
                                  listen: false,
                                );

                                return AlertDialog(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.95),
                                  title: const Text(
                                    'Are you sure?',
                                    style: TextStyle(
                                      color: kSecondaryColor,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        final provider =
                                            Provider.of<LoginProvider>(
                                          context,
                                          listen: false,
                                        );

                                        musicProvider.player.stop();
                                        musicProvider.setMusicStopped(true);
                                        musicProvider
                                            .setMiniPlayerVisibility(false);
                                        musicProvider.listenMusicStreaming();

                                        podcastProvider.player.stop();
                                        podcastProvider.setEpisodeStopped(true);
                                        podcastProvider
                                            .setMiniPlayerVisibility(false);
                                        podcastProvider
                                            .listenPodcastStreaming();

                                        radioProvider.player.stop();
                                        radioProvider.setIsPlaying(false);
                                        radioProvider
                                            .setMiniPlayerVisibility(false);

                                        Navigator.of(context).pop();
                                        Navigator.pushReplacementNamed(
                                          context,
                                          LoginSignUpBody.routeName,
                                        );
                                        await provider.logOut();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Logged Out'),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Yes',
                                        style:
                                            TextStyle(color: kSecondaryColor),
                                      ),
                                    ),
                                    TextButton(
                                      child: const Text(
                                        'No',
                                        style:
                                            TextStyle(color: kSecondaryColor),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.logout,
                            color: Colors.white.withOpacity(0.75),
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Spacer
                  const SizedBox(
                    height: 8,
                  ),

                  // user Image
                  FirebaseAuth.instance.currentUser!.photoURL != null
                      ? SizedBox(
                          width: 125,
                          height: 125,
                          child: CachedNetworkImage(
                            imageUrl:
                                FirebaseAuth.instance.currentUser!.photoURL ??
                                    "",
                            imageBuilder: (context, imageProvider) => Container(
                              // height: 200,
                              //  width: double.infinity,
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(20),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 125,
                          height: 125,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kSecondaryColor.withOpacity(0.65),
                            // image: DecorationImage(
                            //   image: AssetImage(
                            //     "assets/images/logo.png",
                            //   ),
                            //   fit: BoxFit.fitWidth,
                            // ),
                          ),
                          child: Center(
                            child: Text(
                              formatDisplayName(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 64,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                        ),

                  // Spacer
                  const SizedBox(
                    height: 16,
                  ),

                  // User Name
                  Text(
                    FirebaseAuth.instance.currentUser?.displayName ??
                        "Kin Admin",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  // Spacer Sized
                  const SizedBox(
                    height: 2,
                  ),

                  // Email or Phone number
                  Text(
                    getEmailOrPhone(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  // spacer
                  SizedBox(
                    height: getProportionateScreenHeight(30),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Buy Tip
                        const BuyTipCurrency(),

                        // Dashboard
                        snapshot.hasData && snapshot.data!['prev'] == "1" ||
                                snapshot.hasData &&
                                    snapshot.data!['prev'] == "2"
                            ? const DashboardOptionCard(
                                optionName: "Dashboard",
                                dashboardType: 'producer',
                              )
                            : Container()
                      ],
                    ),
                  ),
                ],
              ),

              // Info Section
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 4),
                margin: EdgeInsets.only(bottom: 4),
                child: Column(
                  children: [
                    // info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Terms & Conditons",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.75),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Help & Support",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.75),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Privacy Policy",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.75),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),

                    // spacer
                    const SizedBox(
                      height: 16,
                    ),

                    // Version
                    Text(
                      "Version 1.0",
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.95),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    // Spacer
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

String formatDisplayName() {
  try {
    var currentUser = FirebaseAuth.instance.currentUser;
    String displayValue = "PD";
    if (currentUser != null) {
      String firstName = currentUser.displayName!.split(" ")[0];
      String lastName = currentUser.displayName!.split(" ")[1];

      if (firstName != null && lastName != null) {
        displayValue = firstName[0] + lastName[0];
      } else if (firstName != null) {
        displayValue = firstName[0] + firstName[1];
      } else if (lastName != null) {
        displayValue = lastName[0] + lastName[1];
      }
    }

    return displayValue;
  } catch (e) {
    return "KA";
  }
}

// get phone or email to display
String getEmailOrPhone() {
  try {
    String displayValue = "kinadmin@admin.com";
    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      if (currentUser.email != "") {
        displayValue = currentUser.email ?? "";
      } else if (currentUser.phoneNumber != "") {
        displayValue = currentUser.phoneNumber ?? "";
      } else {
        displayValue = "kinadmin@admin.com";
      }
    }

    return displayValue;
  } catch (e) {
    return "kinadmin@admin.com";
  }
}
