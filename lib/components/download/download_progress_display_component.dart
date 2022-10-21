import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/api/error_logging_service.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:kin_music_player_app/services/provider/offline_play_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DownloadProgressDisplayComponent extends StatefulWidget {
  Music music;
  DownloadProgressDisplayComponent({Key? key, required this.music})
      : super(key: key);

  @override
  State<DownloadProgressDisplayComponent> createState() =>
      _DownloadProgressDisplayComponentState();
}

class _DownloadProgressDisplayComponentState
    extends State<DownloadProgressDisplayComponent> {
  bool isLoading = false;
  String currentDownloadProgressValue = "Preparing";

  Future<String?> _getPath() async {
    Directory path;

    path = await getApplicationDocumentsDirectory();

    return path.path;
  }

  Future _downloadFile() async {
    ErrorLoggingApiService _errorLoggingService = ErrorLoggingApiService();
    OfflineMusicProvider _offlineMusicProvider =
        Provider.of<OfflineMusicProvider>(context, listen: false);
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      //add more permission to request here.
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      setState(() {
        isLoading = true;
      });
      var dir = await _getPath();
      String trackLocalPath = "$dir/${widget.music.title}.mp3}";
      try {
        Dio dio = Dio();

        await dio.download(
          "$kinAssetBaseUrl/${widget.music.audio}",
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

      setState(() {
        isLoading = false;
        currentDownloadProgressValue = "Completed";
      });

      Map<String, dynamic> _jsonMusic = widget.music.toJson();
      _jsonMusic['track_audioFile'] = trackLocalPath;

      //
      bool result =
          await Provider.of<OfflineMusicProvider>(context, listen: false)
              .saveOfflineMusicInfoToCache(
        music: Music.fromJson(_jsonMusic),
      );

      await Provider.of<OfflineMusicProvider>(context, listen: false)
          .getOfflineMusic();

      if (result == true) {
        Navigator.pop(context);
        _offlineMusicProvider.getOfflineMusic();
      }
    } else {
      kShowToast(message: "Storage Permission Denied");
    }
  }

  @override
  void initState() {
    super.initState();

    _downloadFile();
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
            'Downloading ${widget.music.title}',
            style: textStyle,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(
            height: 4,
          ),

          // Artist
          Text(
            "By ${widget.music.artist}",
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
                                color: Colors.green,
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
                        style: textStyle.copyWith(
                          fontSize: 13,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
