import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/podcast/components/podcast_list_card.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';
import 'package:kin_music_player_app/services/provider/podcast_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class PodcastSearchScreen extends StatefulWidget {
  static String routeName = 'podcastSearchScreen';

  const PodcastSearchScreen({Key? key}) : super(key: key);

  @override
  State<PodcastSearchScreen> createState() => _PodcastSearchScreenState();
}

class _PodcastSearchScreenState extends State<PodcastSearchScreen> {
  TextEditingController podcastSearchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    podcastSearchController.addListener(() {
      final provider = Provider.of<PodCastProvider>(context, listen: false);
      if (podcastSearchController.text.isNotEmpty) {
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 100), () {
          provider.searchedPodCast(podcastSearchController.text);
        });
      } else {
        provider.searchedPodCasts.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PodCastProvider>(context);
    List<PodCast> searchedPodcastsList = [];
    if (provider.searchedPodCasts.isNotEmpty) {
      for (int i = 0; i < provider.searchedPodCasts.length; i++) {
        searchedPodcastsList.add(provider.searchedPodCasts[i]);
      }
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kPrimaryColor,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.contain)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.35),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  SafeArea(
                    child: Row(
                      children: [
                        BackButton(
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Expanded(
                            child: _buildSearchBar(
                                context, 'Search for podcast title')),
                        SizedBox(
                          width: getProportionateScreenWidth(10),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: provider.searchedPodCasts.isEmpty
                        ? const Center(
                            child: Text(
                            'No data',
                            style: TextStyle(color: kGrey),
                          ))
                        : ListView.builder(
                            itemCount: provider.searchedPodCasts.length,
                            itemBuilder: (context, index) {
                              return PodCastListCard(
                                podCast: provider.searchedPodCasts[index],
                                podCasts: searchedPodcastsList,
                              );
                            }),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, hint) {
    return Container(
      // width: SizeConfig.screenWidth * 0.85,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: podcastSearchController,
        style: const TextStyle(color: kGrey),
        cursorColor: kGrey,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenWidth(9)),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(color: kGrey),
            prefixIcon: const Icon(
              Icons.search,
              color: kGrey,
            )),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
