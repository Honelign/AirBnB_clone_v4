import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/mixins/BaseMixins.dart';

import 'package:flutter/foundation.dart';
import 'package:kin_music_player_app/services/network/model/podcast_old/podcast.dart';
import 'package:kin_music_player_app/services/network/model/podcast_old/podcastEpisode.dart';

import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';

class PodcastPlayer extends ChangeNotifier with BaseMixins {
  AssetsAudioPlayer player = AssetsAudioPlayer();

  bool _isEpisodeStopped = true;

  bool get isEpisodeStopped => _isEpisodeStopped;

  void setEpisodeStopped(bool value) {
    _isEpisodeStopped = value;
    notifyListeners();
  }

  PodcastPlayer() {
    player.playlistAudioFinished.listen((Playing playing) {
      if (!_isEpisodeStopped) {
        next(action: false);
      }
    });

    AssetsAudioPlayer.addNotificationOpenAction((notification) {
      return false;
    });
  }

  void listenPodcastStreaming() {
    player.playlistAudioFinished.listen((Playing playing) {
      if (!_isEpisodeStopped) {
        next(action: false);
      }
    });
  }

  void setPlayer(AssetsAudioPlayer podcastPlayer, MusicPlayer musicProvider,
      RadioProvider radioProvider) {
    player = podcastPlayer;

    setMiniPlayerVisibility(true);
    musicProvider.setMiniPlayerVisibility(false);
    radioProvider.setMiniPlayerVisibility(false);
  }

  bool _miniPlayerVisibility = false;

  bool get miniPlayerVisibility => _miniPlayerVisibility;

  void setMiniPlayerVisibility(bool visibility) {
    _miniPlayerVisibility = visibility;
    notifyListeners();
  }

  late PodCast _currentPodcast;

  PodCast get currentPodcast => _currentPodcast;

  late PodCast _playlist;

  PodCast get playlist => _playlist;

  PodCastEpisode? _currentEpisode;

  PodCastEpisode? get currentEpisode => _currentEpisode;

  bool _loopMode = false;

  bool get loopMode => _loopMode;
  bool _loopPlaylist = false;

  bool get loopPlaylist => _loopPlaylist;
  bool _isEpisodeLoaded = true;

  bool get isEpisodeLoaded => _isEpisodeLoaded;
  int? _currentIndex;

  int? get currentIndex => _currentIndex;

  set currentPodcast(podcast) {
    _currentPodcast = podcast;
    notifyListeners();
  }

  late int _sessionId;

  int get sessionId => _sessionId;

  late int tIndex;

  setBuffering(index) {
    tIndex = index;
  }

  playOrPause() async {
    try {
      await player.playOrPause();
    } catch (_) {}
  }

  isFirstEpisode() {
    return _currentIndex == 0;
  }

  isLastEpisode(next) {
    return next == _currentPodcast.episodes.length;
  }

  next({action = true}) {
    int next = _currentIndex! + 1;
    if (!action && _loopMode && isLastEpisode(next) && _loopPlaylist) {
      setPlaying(_currentPodcast, 0);
      play(0);
    } else if (!action && _loopMode && !_loopPlaylist) {
      setPlaying(_currentPodcast, _currentIndex!);
      play(_currentIndex);
    } else {
      play(next);
    }
  }

  prev() {
    int pre = _currentIndex! - 1;
    if (pre <= _currentPodcast.episodes.length) {
      play(pre);
    }
  }

  int c = 0;

  handleLoop() {
    c++;
    if (c == 1) {
      _loopMode = true;
      _loopPlaylist = true;
    } else if (c == 2) {
      _loopMode = true;
      _loopPlaylist = false;
    } else if (c > 2) {
      _loopMode = _loopPlaylist = false;
      c = 0;
    }
  }

  late PodCast _beforeShuffling;
  bool _shuffled = false;

  bool get shuffled => _shuffled;

  handleShuffle() {
    _shuffled = !_shuffled;
    List<PodCastEpisode?> episodes = _currentPodcast.episodes;
    _beforeShuffling = _currentPodcast;
    List shuffledMusics = shufflePodcast(episodes);
    if (_shuffled) {
      PodCast podCast = PodCast(
          id: currentPodcast.id,
          title: currentPodcast.title,
          description: currentPodcast.description,
          cover: currentPodcast.cover,
          episodes: currentPodcast.episodes,
          duration: currentPodcast.duration,
          narrator: currentPodcast.narrator);
      _currentPodcast = podCast;
    } else {
      _currentPodcast = _beforeShuffling;
    }
  }

  play(index) async {
    try {
      _currentEpisode = _currentPodcast.episodes[index];
      notifyListeners();
      await _open(_currentPodcast.episodes[index], _currentPodcast);
      _currentIndex = index;
    } catch (_) {}
  }

  isSamePodcast() {
    return _playlist.id == _currentPodcast.id;
  }

  isEpisodeInProgress(PodCastEpisode episode) {
    return player.isPlaying.value &&
        player.current.value != null &&
        player.getCurrentAudioTitle == episode.title;
  }

  isLocalEpisodeInProgress(filePath) {
    return player.isPlaying.value &&
        player.current.value != null &&
        player.current.value?.audio.assetAudioPath == filePath;
  }

  bool isPlaying() {
    return player.isPlaying.value;
  }

  void audioSessionListener() {
    player.audioSessionId.listen((sessionId) {
      _sessionId = sessionId;
    });
  }

  _open(PodCastEpisode episode, PodCast podCast) async {
    var metas = Metas(
        title: episode.title,
        artist: podCast.narrator,
        image: MetasImage.network('$kinAssetBaseUrl/${podCast.cover}'),
        id: episode.id.toString()
        //can be MetasImage.network
        );
    try {
      await player.open(
        Audio.network('$kinAssetBaseUrl/${episode.audio}', metas: metas),
        showNotification: true,
        notificationSettings: NotificationSettings(
          customPrevAction: (player) {
            prev();
            setMiniPlayerVisibility(true);
          },
          customNextAction: (player) {
            next();
            setMiniPlayerVisibility(true);
          },
          customPlayPauseAction: (player) => playOrPause(),
          customStopAction: (player) {
            setEpisodeStopped(true);
            player.stop();
            setMiniPlayerVisibility(false);
          },
        ),
      );
    } catch (_) {}
  }

  handlePlayButton({podCast, required PodCastEpisode episode, index}) async {
    _shuffled = false;

    setBuffering(index);

    try {
      if (isEpisodeInProgress(episode)) {
        player.pause();
      } else {
        _isEpisodeLoaded = false;
        notifyListeners();
        _currentIndex = index;
        await _open(episode, podCast);
        _isEpisodeLoaded = true;
        notifyListeners();
        setPlaying(podCast, index);
      }
    } catch (_) {}
  }

  setPlaying(PodCast podCast, int index) {
    _currentPodcast = podCast;
    _currentIndex = index;
    _currentEpisode = _currentPodcast.episodes[index];
  }

  String getEpisodeThumbnail() {
    return currentPodcast.cover;
  }

  String getEpisodeCover() {
    return '$kinAssetBaseUrl/${currentPodcast.cover}';
  }
}
