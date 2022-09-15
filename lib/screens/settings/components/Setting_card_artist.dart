import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/dashboard/artist/artist_dashboard.dart';
import 'package:kin_music_player_app/screens/dashboard/company/company_dashboard.dart';
import 'package:kin_music_player_app/screens/dashboard/producer/producer_dashboard.dart';

import '../../../size_config.dart';

class DashboardOptionCard extends StatelessWidget {
  final String optionName;
  final String dashboardType;
  const DashboardOptionCard(
      {Key? key, required this.optionName, required this.dashboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (dashboardType == "company") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CompanyDashboard(),
            ),
          );
        }
        //
        else if (dashboardType == "producer") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProducerDashboard(),
            ),
          );
        }
        //
        else if (dashboardType == "artist") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ArtistDashboard(),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(15),
          horizontal: getProportionateScreenWidth(20),
        ),
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(
            Icons.music_note,
            color: Colors.white.withOpacity(0.75),
          ),
          title: Text(
            optionName,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
            ),
          ),
        ),
      ),
    );
  }
}
