import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/section_title.dart';

import 'package:kin_music_player_app/screens/podcast/component/all_category.dart';
import 'package:kin_music_player_app/screens/podcast/component/category_list_card.dart';
import 'package:kin_music_player_app/services/network/model/podcast_old/podcast_category.dart';

import 'package:kin_music_player_app/services/provider/podcast_provider_old.dart';
import 'package:provider/src/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PodCastProvider>(context, listen: false);
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
            title: 'Category',
            press: () {
              Navigator.pushNamed(context, AllCategory.routeName);
            },
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        FutureBuilder(
          future: provider.getPodCastCategory(),
          builder: (context, AsyncSnapshot<List<PodCastCategory>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                var length =
                    snapshot.data!.length > 6 ? 6 : snapshot.data!.length;
                return Wrap(
                  spacing: 1,
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  children: [
                    for (var item = 0; item < length; item++)
                      CategoryListCard(category: snapshot.data![item])
                  ],
                );
              } else {
                return Center(
                  child: Text(
                    "No Data Available",
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                );
              }
            }
            return Center(
              child: KinProgressIndicator(),
            );
          },
        ),
      ],
    );
  }
}
