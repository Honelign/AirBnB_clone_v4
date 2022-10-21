import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api/error_logging_service.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:kin_music_player_app/services/provider/offline_play_provider.dart';

// ignore: must_be_immutable
class MultipleDownloadProgressDisplayComponent extends StatefulWidget {
  List<Music> musics;
  MultipleDownloadProgressDisplayComponent({Key? key, required this.musics})
      : super(key: key);

  @override
  State<MultipleDownloadProgressDisplayComponent> createState() =>
      _MultipleDownloadProgressDisplayComponentState();
}

class _MultipleDownloadProgressDisplayComponentState
    extends State<MultipleDownloadProgressDisplayComponent> {
  final ErrorLoggingApiService _errorLoggingService = ErrorLoggingApiService();
  bool isLoading = false;
  String currentDownloadProgressValue = "Preparing";
  String currentDownloadTrackTitle = "";
  String currentDownloadArtistName = "";

  Future<String?> _getPath() async {
    Directory path;

    path = await getApplicationDocumentsDirectory();

    return path.path;
  }

  Future _downloadFile({required Music music, required bool isLastItem}) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      //add more permission to request here.
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      setState(() {
        isLoading = true;
        currentDownloadArtistName = music.artist;
        currentDownloadTrackTitle = music.title;
      });

      var dir = await _getPath();
      String trackLocalPath = "$dir/${music.title}.mp3}";
      try {
        Dio dio = Dio();

        await dio.download(
          "$kinAssetBaseUrl/${music.audio}",
          trackLocalPath,
          onReceiveProgress: (rec, total) {
            setState(
              () {
                currentDownloadProgressValue =
                    ((rec / total) * 100).toStringAsFixed(0);
              },
            );
          },
        );
      } catch (e) {
        _errorLoggingService.logErrorToServer(
          fileName: "download_progress_display_component.dart",
          functionName: "_downloadFile",
          errorInfo: e.toString(),
        );
      }

      if (isLastItem == true) {
        setState(() {
          isLoading = false;
          currentDownloadProgressValue = "Completed";
        });

        await Future.delayed(const Duration(seconds: 1));

        Navigator.pop(context);
      }

      Map<String, dynamic> _jsonMusic = music.toJson();
      _jsonMusic['track_audioFile'] = trackLocalPath;

      //
      bool result =
          await Provider.of<OfflineMusicProvider>(context, listen: false)
              .saveOfflineMusicInfoToCache(
        music: Music.fromJson(_jsonMusic),
      );

      await Provider.of<OfflineMusicProvider>(context, listen: false)
          .getOfflineMusic();
    } else {
      kShowToast(message: "Storage Permission Denied");
    }
  }

  Future _downloadAllFiles({required List<Music> musics}) async {
    OfflineMusicProvider _offlineMusicProvider =
        Provider.of<OfflineMusicProvider>(context, listen: false);
    try {
      bool isLastItem = false;
      int unPurchasedTrackCount = 0;
      for (int i = 0; i < musics.length; i++) {
        if (musics[i].isPurchasedByUser == false) {
          unPurchasedTrackCount++;
        }
        if (i == musics.length - 1) {
          isLastItem = true;
        }

        if (await _offlineMusicProvider.checkTrackInOfflineCache(
                musicId: musics[i].id.toString()) ==
            false) {
          await _downloadFile(music: musics[i], isLastItem: isLastItem);
        } else if (await _offlineMusicProvider.checkTrackInOfflineCache(
                musicId: musics[i].id.toString()) ==
            true) {
          kShowToast(message: "${musics[i].title} already available offline");
        }

        // pop show info
        if (i == musics.length - 1) {
          Navigator.pop(context);
          _offlineMusicProvider.getOfflineMusic();
        }
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "_downloadAllFiles",
        errorInfo: e.toString(),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _downloadAllFiles(musics: widget.musics);
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: kSecondaryColor,
      fontSize: 15,
    );
    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.85),
      insetPadding: const EdgeInsets.symmetric(horizontal: 100),
      title: Column(
        children: [
          // Title
          Text(
            'Downloading $currentDownloadTrackTitle',
            style: textStyle,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(
            height: 4,
          ),

          // Artist
          Text(
            "By ${currentDownloadArtistName}",
            style: textStyle.copyWith(
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
      content: SizedBox(
        height: 60,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Spacer
              currentDownloadProgressValue == "Preparing" ||
                      currentDownloadProgressValue == "Completed"
                  ? const SizedBox(
                      height: 8,
                    )
                  : Container(),

              currentDownloadProgressValue == "Preparing" ||
                      currentDownloadProgressValue == "Completed"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        currentDownloadProgressValue == "Completed"
                            ? const Icon(
                                Icons.check_circle,
                                color: kSecondaryColor,
                              )
                            : Container(),

                        // spacer
                        const SizedBox(
                          width: 4,
                        ),

                        Text(
                          currentDownloadProgressValue,
                          style: TextStyle(
                            color: currentDownloadProgressValue == "Completed"
                                ? kSecondaryColor
                                : Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
                  :
                  // Progress Indicator
                  CircularPercentIndicator(
                      radius: 25.0,
                      lineWidth: 5.0,
                      animation: true,
                      percent: double.parse(currentDownloadProgressValue) / 100,
                      animateFromLastPercent: true,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: kSecondaryColor,
                      center: Text(
                        currentDownloadProgressValue + "%",
                        style: textStyle.copyWith(fontSize: 13),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
