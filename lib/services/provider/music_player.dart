import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/mixins/BaseMixins.dart';
import 'package:kin_music_player_app/services/network/api/error_logging_service.dart';

import 'package:flutter/foundation.dart';
import 'package:kin_music_player_app/services/network/model/music/album.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';

import 'package:kin_music_player_app/services/provider/radio_provider.dart';

class MusicPlayer extends ChangeNotifier with BaseMixins {
  AssetsAudioPlayer player = AssetsAudioPlayer.withId("0");

  ErrorLoggingApiService errorLoggingApiService = ErrorLoggingApiService();
  String fileName = "music_player.dart";
  String className = "MusicPlayer";

  final List<Music> _popularMusicsList = [];
  final List<Music> _recentMusicsList = [];

  List<Music> get getPopularMusicsList => _popularMusicsList;

  List<Music> get getRecentMusicsList => _recentMusicsList;

  bool _miniPlayerVisibility = false;
  bool _isMusicStopped = true;
  bool isPlayingLocal = false;
  bool isProcessingPlay = false;
  bool isReleased = false;

  bool get isMusicStopped => _isMusicStopped;

  void setMusicStopped(bool value) {
    _isMusicStopped = value;
    notifyListeners();
  }

  bool get miniPlayerVisibility => _miniPlayerVisibility;

  void setMiniPlayerVisibility(bool visibility) {
    _miniPlayerVisibility = visibility;
    notifyListeners();
  }

  void setPopularMusicList(List<Music> musics) {
    for (Music music in musics) {
      _popularMusicsList.add(music);
    }
    notifyListeners();
  }

  void setRecentMusicList(List<Music> musics) {
    for (Music music in musics) {
      _recentMusicsList.add(music);
    }
    notifyListeners();
  }

  MusicPlayer() {
    player.playlistAudioFinished.listen((Playing playing) {
      if (!_isMusicStopped) {
        next(action: false);
      }
    });

    AssetsAudioPlayer.addNotificationOpenAction((notification) {
      return false;
    });
  }

  void listenMusicStreaming() {
    player.playlistAudioFinished.listen((Playing playing) {
      if (!_isMusicStopped) {
        next(action: false);
      }
    });
  }

  void setPlayer(AssetsAudioPlayer musicPlayer, PodcastPlayer podcastProvider,
      RadioProvider radioProvider) {
    player = musicPlayer;

    setMiniPlayerVisibility(true);
    podcastProvider.setMiniPlayerVisibility(false);
    radioProvider.setMiniPlayerVisibility(false);
  }

  Album _currentAlbum = Album(
    id: -1,
    title: "Kin",
    artist: "Kin",
    description: "",
    cover: "",
    artist_id: -1,
    price: 0,
    isPurchasedByUser: false,
  );

  Album get currentAlbum => _currentAlbum;

  late Album _playlist;

  Album get playlist => _playlist;

  Music? _currentMusic;

  Music? get currentMusic => _currentMusic;

  bool _loopMode = false;

  bool get loopMode => _loopMode;
  bool _loopPlaylist = false;

  bool get loopPlaylist => _loopPlaylist;
  bool _isMusicLoaded = true;

  bool get isMusicLoaded => _isMusicLoaded;
  int? _currentIndex;

  int? get currentIndex => _currentIndex;

  set currentAlbum(album) {
    _currentAlbum = album;
    notifyListeners();
  }

  List<Music> _albumMusics = [];
  List<Music> get albumMusics => _albumMusics;
  set albumMusicss(musics) {
    _albumMusics = musics;
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

  isLastMusic(next) {
    return next == _albumMusics.length;
  }

  next({action = true, musics}) {
    if (isProcessingPlay == false) {
      int next = _currentIndex! + 1;

      if (!action && _loopMode && isLastMusic(next) && _loopPlaylist) {
        setPlaying(_currentAlbum, 0, musics);

        play(
          0,
        );
      } else if (!action && _loopMode && !_loopPlaylist) {
        setPlaying(_currentAlbum, _currentIndex!, musics);
        play(_currentIndex);
      } else {
        play(next);
      }
    }
  }

  prev() async {
    if (isProcessingPlay == false) {
      int pre = _currentIndex! - 1;

      if (pre >= 0 && pre < _albumMusics.length) {
        play(pre);
      }
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

  late Album _beforeShuffling;
  bool _shuffled = false;

  bool get shuffled => _shuffled;

  handleShuffle() {
    _shuffled = !_shuffled;
    List<Music> musics = _albumMusics;
    _beforeShuffling = _currentAlbum;
    List<Music> shuffledMusics = shuffle(musics);
    if (_shuffled) {
      Album album = Album(
        id: currentAlbum.id,
        title: currentAlbum.title,
        artist: currentAlbum.artist,
        description: currentAlbum.description,
        cover: '$kinAssetBaseUrl/${currentAlbum.cover}',
        count: currentAlbum.count,
        artist_id: 1,
        isPurchasedByUser: false,
        price: 60,
      );
      _currentAlbum = album;
      _albumMusics = shuffledMusics;
    } else {
      _currentAlbum = _beforeShuffling;
    }
  }

  play(
    index,
  ) async {
    try {
      _currentMusic = _albumMusics[index];
      _currentIndex = index;

      if (isReleased == false) {
        player.stop();
      }

      if (isProcessingPlay == false) {
        if (isPlayingLocal == false) {
          await _open(_albumMusics[index]);
        } else {
          await _openLocal(_albumMusics[index]);
        }
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "play",
        errorInfo: e.toString(),
        className: className,
      );
    }
    notifyListeners();
  }

  isSameAlbum() {
    return _playlist.id == _currentAlbum.id;
  }

  isMusicInProgress(Music music) {
    return player.isPlaying.value &&
        player.current.value != null &&
        player.getCurrentAudioTitle == music.title;
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

  _open(Music music) async {
    isProcessingPlay = true;
    // give meta info
    var metas = Metas(
      title: music.title,
      artist: music.artist,
      image: MetasImage.network('$kinAssetBaseUrl/${music.cover}'),
      id: music.id.toString(),
    );
    try {
      // kill any existing player
      if (isReleased == false) {
        player.pause();
        player.stop();
      }
      // open new player
      await player.open(
        Audio.network(
          '$kinAssetBaseUrl/${music.audio}',
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
            setMusicStopped(true);
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
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "_open",
        errorInfo: e.toString(),
        className: className,
      );
    }
    notifyListeners();
  }

  _openLocal(Music music) async {
    // give meta info
    var metas = Metas(
      title: music.title,
      artist: music.artist,
      image: MetasImage.network('$kinAssetBaseUrl/${music.cover}'),
      id: music.id.toString(),
    );
    try {
      // kill any existing player
      if (isReleased == false) {
        player.pause();
        player.stop();
      }
      // open new player
      await player.open(
        Audio.file(
          music.audio,
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
            setMusicStopped(true);
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
    // // notifyListeners();
  }

  handlePlayButton(
      {album, required Music music, index, required List<Music> musics}) async {
    _shuffled = false;

    setBuffering(index);

    try {
      if (isMusicInProgress(music)) {
        player.stop();
      } else {
        _isMusicLoaded = false;
        notifyListeners();
        _currentIndex = index;
        if (isProcessingPlay == false) {
          isProcessingPlay = true;

          await _open(music);
          _isMusicLoaded = true;
          notifyListeners();

          setPlaying(album, index, musics);
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
      {album, required Music music, index, required List<Music> musics}) async {
    _shuffled = false;

    setBuffering(index);

    try {
      if (isMusicInProgress(music)) {
        player.stop();
      } else {
        _isMusicLoaded = false;
        notifyListeners();
        _currentIndex = index;
        await _openLocal(music);
        _isMusicLoaded = true;
        notifyListeners();

        setPlaying(album, index, musics);
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

  setPlaying(Album album, int index, musics) {
    _currentAlbum = album;
    _currentIndex = index;
    _currentMusic = musics[index];
  }

  String getMusicThumbnail() {
    return currentMusic!.cover.isNotEmpty ? currentMusic!.cover : '';
  }

  String getMusicCover() {
    return '$kinAssetBaseUrl/${currentMusic!.cover}';
  }
}
