import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

class UserAccountHeader extends StatelessWidget {
  const UserAccountHeader({Key? key}) : super(key: key);

  // get cached info
  Future<Map<String, dynamic>> getCacheInfo() async {
    try {
      SharedPreferences cachedInfo = await SharedPreferences.getInstance();
      String uid = cachedInfo.getString('id') ?? "";
      String username = cachedInfo.getString('name$uid') ?? "";
      String email = cachedInfo.getString('email$uid') ?? "";
      return {"id": uid, "username": username, "email": email};
    } catch (e) {
      return {"id": "", "username": "", "email": ""};
    }

// return user info json
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context, listen: false);
    return FutureBuilder(
      future: getCacheInfo(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        // if user info cache found
        if (snapshot.hasData) {
          if (snapshot.hasError) {
            return SizedBox(
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0x00343434).withOpacity(0.5),
                          const Color(0x00343434).withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(kProfileLoadingError),
                  )
                ],
              ),
            );
          }

          // cache found and no error
          return SizedBox(
            width: double.infinity,
            height: 200,
            child: Stack(
              children: [
                Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FutureBuilder(
                    future: provider.getUserInfo(),
                    builder: (ctx, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UserAccountsDrawerHeader(
                              accountEmail: Text(
                                snapshot.data['email'] ?? "",
                              ),
                              accountName: Text(
                                snapshot.data['userName'] ?? "Kin Music User",
                                style: const TextStyle(fontSize: 20),
                              ),
                              decoration: const BoxDecoration(
                                  color: Colors.transparent),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                              child: Text(
                                'ID  (${FirebaseAuth.instance.currentUser!.uid})',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.65),
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        );
                      }
                      return const Text(
                        '',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return SizedBox(
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0x00343434).withOpacity(0.5),
                        const Color(0x00343434).withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: KinProgressIndicator(),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
