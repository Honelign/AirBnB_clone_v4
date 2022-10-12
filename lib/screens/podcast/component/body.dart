import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/ad_banner.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';

import 'package:kin_music_player_app/screens/podcast/component/new_podcasts.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'category_list.dart';
import 'custom_tab_bar.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      backgroundColor: refreshIndicatorBackgroundColor,
      color: refreshIndicatorForegroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            /*  SizedBox(
              height: getProportionateScreenHeight(15),
            ), */
            const AdBanner(),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            const NewPodcasts(),
            SizedBox(
              height: getProportionateScreenHeight(25),
            ),
            // const CategoryList(),
            SizedBox(
              height: getProportionateScreenHeight(18),
            ),
            PopularPodcasts()
          ],
        ),
      ),
    );
  }

  Widget _buildNewReleasedPodcastCard(BuildContext context) {
    return Container(
      height: 90,
      width: double.infinity,
      margin: EdgeInsets.all(getProportionateScreenWidth(20)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FutureBuilder(
                future: getCompanyProfile('/company/profile'),
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (!(snapshot.connectionState == ConnectionState.waiting)) {
                    if (snapshot.hasData) {
                      return CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: double.infinity,
                          imageUrl: "$apiUrl/${snapshot.data!.companyBanner}");
                    } else {
                      return Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    }
                  }
                  return Center(
                    child: KinProgressIndicator(),
                  );
                },
              )),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF343434).withOpacity(0.25),
                  const Color(0xFF343434).withOpacity(0.45),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
