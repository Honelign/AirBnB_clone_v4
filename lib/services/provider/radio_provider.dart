import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/model/radio.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';

import '../network/api_service.dart';

class RadioProvider extends ChangeNotifier {
  AssetsAudioPlayer player = AssetsAudioPlayer();

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  bool _isPlaying = false;

  RadioStation? _currentStation;

  RadioStation? get currentStation => _currentStation;

  bool get isPlaying => _isPlaying;
  int currentIndex = 0;

  List<RadioStation> stations = [];

  final _audios = <Audio>[];

  List<Audio> get audios => _audios;

  bool _miniPlayerVisibility = false;

  bool get miniPlayerVisibility => _miniPlayerVisibility;

  RadioProvider() {
    AssetsAudioPlayer.addNotificationOpenAction((notification) {
      return true;
    });
  }

  Future<List<RadioStation>> getStations() async {
    var loading = true;
    const String apiEndPoint = 'stations';

    stations = await getRadioStations(apiEndPoint);

    loading = false;
    return stations;
  }

  void setMiniPlayerVisibility(bool visibility) {
    _miniPlayerVisibility = visibility;
    notifyListeners();
  }

  void setIsPlaying(bool value) {
    _isPlaying = value;
    notifyListeners();
  }

  void setPlayer(AssetsAudioPlayer radioPlayer, MusicPlayer musicProvider,
      PodcastPlayer podcastPlayer) {
    player = radioPlayer;
    notifyListeners();
    setMiniPlayerVisibility(true);
    musicProvider.setMiniPlayerVisibility(false);
    podcastPlayer.setMiniPlayerVisibility(false);
  }

  setPlaying(RadioStation radioStation, int index) {
    _currentStation = radioStation;
    currentIndex = index;
  }

  next({action = true}) {
    int next = currentIndex + 1;
    play(next);
    _isPlaying = true;
    notifyListeners();
  }

  prev() {
    int pre = currentIndex - 1;
    if (pre <= stations.length) {
      play(pre);
      _isPlaying = true;
      notifyListeners();
    }
  }

  isStationInProgress(RadioStation station) {
    return player.isPlaying.value &&
        player.current.value != null &&
        //  player!.current.value?.audio.assetAudioPath == music.audio;
        player.getCurrentAudioTitle == station.stationName;
  }

  late int tIndex;

  setBuffering(index) {
    tIndex = index;
  }

  bool _isStationLoaded = true;

  bool get isStationLoaded => _isStationLoaded;

  handlePlayButton(index) async {
    setBuffering(index);
    try {
      _isStationLoaded = false;
      notifyListeners();
      currentIndex = index;
      await _open(stations[index]);
      _isStationLoaded = true;
      notifyListeners();
      setPlaying(stations[index], index);
    } catch (_) {}
  }

  play(index) async {
    try {
      _currentStation = stations[index];
      notifyListeners();
      await _open(stations[index]);
      currentIndex = index;
    } catch (_) {}
  }

  _open(RadioStation station) async {
    var metas = Metas(
      title: station.stationName,
      artist: station.mhz.toString(),
      image: MetasImage.network(station.coverImage),
    );
    try {
      await player.open(
        Audio.liveStream(station.url, metas: metas),
        showNotification: true,
        notificationSettings: NotificationSettings(
          playPauseEnabled: false,
          customPrevAction: (player) {
            prev();
            setMiniPlayerVisibility(true);
          },
          customNextAction: (player) {
            next();
            setMiniPlayerVisibility(true);
          },
          customStopAction: (player) {
            player.stop();
            setMiniPlayerVisibility(false);
            setIsPlaying(false);
          },
        ),
      );
    } catch (_) {}
  }

  playOrPause() async {
    try {
      await player.playOrPause();
    } catch (_) {}
  }

  isFirstStation() {
    return currentIndex == 0;
  }

  isLastStation(next) {
    return next == stations.length;
  }
}
