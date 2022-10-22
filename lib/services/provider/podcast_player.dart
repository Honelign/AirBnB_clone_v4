import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/mixins/BaseMixins.dart';
import 'package:kin_music_player_app/services/network/api/error_logging_service.dart';

import 'package:flutter/foundation.dart';
import 'package:kin_music_player_app/services/network/model/podcast/podcast_episode.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';

class PodcastPlayer extends ChangeNotifier with BaseMixins {
  AssetsAudioPlayer player = AssetsAudioPlayer.withId("0");

  ErrorLoggingApiService errorLoggingApiService = ErrorLoggingApiService();
  String fileName = "podcast_player.dart";
  String className = "PodcastPlayer";

  final List<PodcastEpisode> _popularEpisodesList = [];
  final List<PodcastEpisode> _recentEpisodesList = [];

  List<PodcastEpisode> get getPopularEpisodesList => _popularEpisodesList;

  List<PodcastEpisode> get getRecentPodcastsList => _recentEpisodesList;

  bool _miniPlayerVisibility = false;
  bool _isEpisodeStopped = true;
  bool isPlayingLocal = false;
  bool isProcessingPlay = false;

  bool get isEpisodeStopped => _isEpisodeStopped;

  void setEpisodeStopped(bool value) {
    _isEpisodeStopped = value;
    notifyListeners();
  }

  void listenPodcastStreaming() {
    player.playlistAudioFinished.listen((Playing playing) {
      if (!_isEpisodeStopped) {
        next(action: false);
      }
    });
  }

  bool get miniPlayerVisibility => _miniPlayerVisibility;

  void setMiniPlayerVisibility(bool visibility) {
    _miniPlayerVisibility = visibility;
    notifyListeners();
  }

  void setPopularEpisodesList(List<PodcastEpisode> episodes) {
    for (PodcastEpisode episode in episodes) {
      _popularEpisodesList.add(episode);
    }
    notifyListeners();
  }

  void setRecentEpisodesList(List<PodcastEpisode> episodes) {
    for (PodcastEpisode episode in episodes) {
      _recentEpisodesList.add(episode);
    }
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

  void listenMusicStreaming() {
    player.playlistAudioFinished.listen((Playing playing) {
      if (!_isEpisodeStopped) {
        next(action: false);
      }
    });
  }

  void setPlayer(AssetsAudioPlayer musicPlayer, musicPlayerr,
      RadioProvider radioProvider) {
    player = musicPlayer;

    setMiniPlayerVisibility(true);
    musicPlayerr.setMiniPlayerVisibility(false);
    radioProvider.setMiniPlayerVisibility(false);
  }

  List<PodcastEpisode> _currentSeason = [];

  List<PodcastEpisode> get currentSeason => _currentSeason;

  // late Album _playlist;

  // Album get playlist => _playlist;

  PodcastEpisode? _currentEpisode;

  PodcastEpisode? get currentEpisode => _currentEpisode;

  // bool _loopMode = false;

  // bool get loopMode => _loopMode;
  // bool _loopPlaylist = false;

  // bool get loopPlaylist => _loopPlaylist;
  bool _isEpisodeLoaded = true;

  bool get isEpisodeLoaded => _isEpisodeLoaded;

  // PodcastEpisode? _currentEpisode;
  int? _currentIndex;

  int? get currentIndex => _currentIndex;

  set currentSeason(season) {
    _currentSeason = season;
    notifyListeners();
  }

  List<PodcastEpisode> _seasonEpisodes = [];
  List<PodcastEpisode> get seasonEpisodes => _seasonEpisodes;
  set seasonEpisodes(episodes) {
    _seasonEpisodes = episodes;
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
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "playOrPause",
        errorInfo: e.toString(),
        className: className,
      );
    }
  }

  isFirstMusic() {
    return _currentIndex == 0;
  }

  isLastEpisode(next) {
    return next == _seasonEpisodes.length;
  }

  next({action = true, episodes}) {
    if (isProcessingPlay == false) {
      int next = _currentIndex! + 1;
      if (!action && isLastEpisode(next)) {
        setPlaying(episodes: _currentSeason, index: 0);

        play(
          0,
        );
      } else if (!action) {
        setPlaying(episodes: _currentSeason, index: _currentIndex!);

        play(_currentIndex);
      } else {
        play(next);
      }
    }
  }

  prev() async {
    if (isProcessingPlay == false) {
      int pre = _currentIndex! - 1;

      if (pre >= 0 && pre < _currentSeason.length) {
        play(pre);
      }
    }
  }

  int c = 0;

  // handleLoop() {
  //   c++;
  //   if (c == 1) {
  //     _loopMode = true;
  //     _loopPlaylist = true;
  //   } else if (c == 2) {
  //     _loopMode = true;
  //     _loopPlaylist = false;
  //   } else if (c > 2) {
  //     _loopMode = _loopPlaylist = false;
  //     c = 0;
  //   }
  // }

  // late Album _beforeShuffling;
  // bool _shuffled = false;

  // bool get shuffled => _shuffled;

  // handleShuffle() {
  //   _shuffled = !_shuffled;
  //   List<Music> musics = _albumMusics;
  //   _beforeShuffling = _currentAlbum;
  //   List<Music> shuffledMusics = shuffle(musics);
  //   if (_shuffled) {
  //     Album album = Album(
  //       id: currentAlbum.id,
  //       title: currentAlbum.title,
  //       artist: currentAlbum.artist,
  //       description: currentAlbum.description,
  //       cover: '$kinAssetBaseUrl/${currentAlbum.cover}',
  //       count: currentAlbum.count,
  //       artist_id: 1,
  //       isPurchasedByUser: false,
  //       price: 60,
  //     );
  //     _currentAlbum = album;
  //     _albumMusics = shuffledMusics;
  //   } else {
  //     _currentAlbum = _beforeShuffling;
  //   }
  // }

  play(
    index,
  ) async {
    try {
      _currentEpisode = _currentSeason[index];
      player.stop();
      notifyListeners();

      if (isPlayingLocal == false) {
        await _open(_currentSeason[index]);
      } else {
        await _openLocal(_currentSeason[index]);
      }

      _currentIndex = index;
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "play",
        errorInfo: e.toString(),
        className: className,
      );
    }
  }

  // isSameAlbum() {
  //   return _playlist.id == _currentAlbum.id;
  // }

  isEpisodeInProgress(PodcastEpisode episode) {
    return player.isPlaying.value &&
        player.current.value != null &&
        player.getCurrentAudioTitle == episode.hostName;
  }

  isLocalMusicInProgress(filePath) {
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

  _open(PodcastEpisode podcastEpisode) async {
    isProcessingPlay = true;
    // give meta info
    var metas = Metas(
      title: podcastEpisode.episodeTitle,
      artist: podcastEpisode.hostName,
      image: MetasImage.network('$kinAssetBaseUrl-dev/${podcastEpisode.cover}'),
      id: podcastEpisode.id.toString(),
    );
    try {
      // kill any existing player
      player.pause();
      player.stop();

      // open new player
      await player.open(
        Audio.network(
          '$kinAssetBaseUrl-dev/${podcastEpisode.audio}',
          // music.audio,
          metas: metas,
        ),
        showNotification: true,
        playInBackground: PlayInBackground.enabled,
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
      player.isPlaying.listen((event) {
        if (event) {
          isProcessingPlay = false;
        }
      });

      notifyListeners();
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "_open",
        errorInfo: e.toString(),
        className: className,
      );
    }
  }

  _openLocal(PodcastEpisode podcastEpisode) async {
    // give meta info
    var metas = Metas(
      title: podcastEpisode.episodeTitle,
      artist: podcastEpisode.hostName,
      image: MetasImage.network('$kinAssetBaseUrl/${podcastEpisode.cover}'),
      id: podcastEpisode.id.toString(),
    );
    try {
      // kill any existing player
      // player.pause();
      player.stop();

      // open new player
      await player.open(
        Audio.file(
          podcastEpisode.audio,
          // music.audio,
          metas: metas,
        ),
        showNotification: true,
        playInBackground: PlayInBackground.enabled,
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
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "_openLocal",
        errorInfo: e.toString(),
        className: className,
      );
    }
  }

  handlePlayButton(
      {required PodcastEpisode episode,
      index,
      required List<PodcastEpisode> episodes}) async {
    // _shuffled = false;

    setBuffering(index);

    try {
      if (isEpisodeInProgress(episode)) {
        player.stop();
      } else {
        _isEpisodeLoaded = false;
        notifyListeners();
        _currentIndex = index;
        if (isProcessingPlay == false) {
          isProcessingPlay = true;
          await _open(episode);
          _isEpisodeLoaded = true;
          notifyListeners();
          setPlaying(index: index, episodes: episodes);
        }
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "handlePlayButton",
        errorInfo: e.toString(),
        className: className,
      );
    }
  }

  handlePlayButtonLocal(
      {season,
      required PodcastEpisode episode,
      index,
      required List<PodcastEpisode> episodes}) async {
    // _shuffled = false;

    setBuffering(index);

    try {
      if (isEpisodeInProgress(episode)) {
        player.stop();
      } else {
        _isEpisodeLoaded = false;
        notifyListeners();
        _currentIndex = index;
        await _openLocal(episode);
        _isEpisodeLoaded = true;
        notifyListeners();

        setPlaying(index: index, episodes: episodes);
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "handlePlayButtonLocal",
        errorInfo: e.toString(),
        className: className,
      );
    }
  }

  setPlaying({required int index, required List<PodcastEpisode> episodes}) {
    _currentSeason = episodes;
    _currentIndex = index;
    _currentEpisode = episodes[index];
  }

  String getEpisodeThumbnail() {
    return currentEpisode!.cover.isNotEmpty ? currentEpisode!.cover : '';
  }

  String getEpisodeCover() {
    return '$kinAssetBaseUrl-dev/${currentEpisode!.cover}';
  }
}
