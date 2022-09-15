import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/podcast/components/detail.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';
import 'package:kin_music_player_app/size_config.dart';


import '../../../constants.dart';

class PodCastListCard extends StatelessWidget {
  const PodCastListCard({
    Key? key,
    this.height = 70,
    this.aspectRatio = 1.02,
    required this.podCasts,
    required this.podCast,
  }) : super(key: key);

  final double height, aspectRatio;
  final PodCast podCast;
  final List<PodCast> podCasts;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Detail(podCast:podCast,)));

      },
      child: Container(
          height: getProportionateScreenHeight(height),
          width: getProportionateScreenWidth(75),
          margin: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: getProportionateScreenHeight(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 1.02,
                    child: Container(
                        color: kSecondaryColor.withOpacity(0.1),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl:
                          '$apiUrl/${podCast.cover}',
                        )),
                  )),
              SizedBox(
                width: getProportionateScreenWidth(10),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      podCast.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: getProportionateScreenHeight(18)),
                    ),
                    Text(
                      podCast.narrator,
                      style: const TextStyle(color: kGrey),
                    ),
                  ],
                ),
              ),

            ],
          )),
    );
  }
}
