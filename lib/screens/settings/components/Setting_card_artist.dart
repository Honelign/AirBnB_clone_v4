import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/dashboard/artist/artist_dashboard.dart';
import 'package:kin_music_player_app/screens/dashboard/company/company_dashboard.dart';
import 'package:kin_music_player_app/screens/dashboard/producer/producer_dashboard.dart';
import 'package:kin_music_player_app/size_config.dart';

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
        height: 112,
        width: 112,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            // Icon
            SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: Icon(
                  Icons.speed_rounded,
                  size: 46,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Dashboard",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
