import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/settings/components/Setting_card_artist.dart';
import 'package:kin_music_player_app/screens/settings/components/settings_tip_buy_card.dart';
import 'package:kin_music_player_app/screens/settings/components/user_accout_header.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_card.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({Key? key}) : super(key: key);

  // get user ID
  Future<String> getUserID() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String privilege = pref.getString("prev") ?? "";

      print("@@@ settings_body getUserId $privilege");
      return privilege;
    } catch (e) {
      return "-1";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserID(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const KinProgressIndicator();
        }

        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // account info
              const UserAccountHeader(),

              // spacer
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),

              // company dashboard
              snapshot.hasData && snapshot.data == "0"
                  ? const DashboardOptionCard(
                      optionName: "Company Dashboard",
                      dashboardType: "company",
                    )
                  : Container(),

              // producer dashboard
              snapshot.hasData && snapshot.data == "1"
                  ? const DashboardOptionCard(
                      optionName: "Producer Dashboard",
                      dashboardType: "producer",
                    )
                  : Container(),

              // artist dashboard
              snapshot.hasData && snapshot.data == "2"
                  ? const DashboardOptionCard(
                      optionName: "Artist Dashboard",
                      dashboardType: "artist",
                    )
                  : Container(),

              // buy token to tip artists
              const BuyTipCurrency(),

              //
              const SettingsCard(
                title: 'Privacy Policy',
                iconData: Icons.verified_user,
                data: kPrivacyPolicy,
              ),

              //
              const SettingsCard(
                title: 'Terms of Service',
                iconData: Icons.gavel,
                data: kTermsOfService,
              ),

              //
              const SettingsCard(
                title: 'Help and Support',
                iconData: Icons.help,
                data: kHelpAndSupport,
              ),

              //
              const SettingsCard(
                title: 'Logout',
                iconData: Icons.logout,
              ),

              //
              const SizedBox(
                height: 8,
              ),

              //
              const Align(
                alignment: FractionalOffset.bottomCenter,
                child: Text(
                  'Powered By KinIdeas',
                  style: TextStyle(
                    color: kSecondaryColor,
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
