/* import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../services/provider/playlist_provider.dart';
import '../size_config.dart';

abstract class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Future<Widget> (BuildContext context) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => SizedBox(
        height: getProportionateScreenHeight(340) +
            MediaQuery.of(context).viewInsets.bottom,
        width: double.infinity,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: kGrey.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  top: getProportionateScreenHeight(50),
                  left: getProportionateScreenWidth(50),
                  right: getProportionateScreenWidth(50),
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(60),
                    width: getProportionateScreenWidth(250),
                    child: TextField(
                        // controller: playlistTitle,
                        cursorColor: kGrey,
                        style: const TextStyle(color: kGrey),
                        decoration: InputDecoration(
                            hintStyle: const TextStyle(color: kGrey),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(10),
                              vertical: getProportionateScreenHeight(10),
                            ),
                            hintText: 'Playlist name',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: kGrey.withOpacity(0.25))),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: kGrey.withOpacity(0.25),
                              ),
                            ),
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            fillColor: kGrey.withOpacity(0.25),
                            filled: true)),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(25),
                  ),
                  InkWell(
                    onTap: () async {
                      final provider =
                          Provider.of<PlayListProvider>(context, listen: false);
                      /*   if (playlistTitle.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter valid text'),
                          ),
                        );
                      } else {
                        var result =
                            await provider.createPlayList(playlistTitle.text);

                        setState(
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result),
                              ),
                            );
                          },
                        );
                      } */
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(5),
                        horizontal: getProportionateScreenWidth(15),
                      ),
                      width: getProportionateScreenWidth(145),
                      height: getProportionateScreenHeight(50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: kSecondaryColor,
                      ),
                      child: const Text(
                        'Create playlist',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
 */