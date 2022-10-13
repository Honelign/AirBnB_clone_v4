import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/size_config.dart';

class ArtistInfoCard extends StatelessWidget {
  final String infoLabel;
  final String infoValue;
  final String cardType;
  const ArtistInfoCard({
    Key? key,
    required this.infoLabel,
    required this.infoValue,
    required this.cardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.fromLTRB(
        getProportionateScreenWidth(20),
        getProportionateScreenHeight(16),
        getProportionateScreenWidth(50),
        getProportionateScreenHeight(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 25,
                height: 25,
                child: cardType == "Views"
                    ? cardType == "Tip"
                        ? Image.asset(
                            "./assets/icons/Tip Icon.png",
                          )
                        : Image.asset(
                            "./assets/icons/Views.png",
                          )
                    : Image.asset(
                        "./assets/icons/Revenue.png",
                      ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(8),
              ),
              Text(
                infoLabel,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Text(
            infoValue,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(24),
              color: kSecondaryColor.withOpacity(0.85),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
