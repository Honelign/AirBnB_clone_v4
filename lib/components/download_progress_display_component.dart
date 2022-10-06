import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:kin_music_player_app/services/provider/offline_play_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

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

        await dio
            .download("$kinAssetBaseUrl/${widget.music.audio}", trackLocalPath,
                onReceiveProgress: (rec, total) {
          setState(() {
            currentDownloadProgressValue =
                ((rec / total) * 100).toStringAsFixed(0) + "%";
          });
        });
      } catch (e) {
        print(e);
      }

      setState(() {
        isLoading = false;
        currentDownloadProgressValue = "Completed";
      });

      Map<String, dynamic> _jsonMusic = widget.music.toJson();
      _jsonMusic['track_audioFile'] = trackLocalPath;

      print(_jsonMusic);
      //
      bool result =
          await Provider.of<OfflineMusicProvider>(context, listen: false)
              .saveOfflineMusicInfoToCache(
        music: Music.fromJson(_jsonMusic),
      );

      if (result == true) {
        Navigator.pop(context);
      }

      await Provider.of<OfflineMusicProvider>(context, listen: false)
          .getOfflineMusic();
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
    return AlertDialog(
      backgroundColor: kSecondaryColor.withOpacity(0.2),
      insetPadding: EdgeInsets.symmetric(horizontal: 100),
      title: Text(
        'Downloading ${widget.music.title} by ${widget.music.artist}',
        style: TextStyle(
          color: Colors.white60,
          fontSize: 15,
        ),
      ),
      content: SizedBox(
        height: 60,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                currentDownloadProgressValue,
                style: const TextStyle(
                  color: Colors.green,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
