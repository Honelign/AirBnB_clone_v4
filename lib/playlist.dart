

class Playlist {
  final String? playlist;
  final int? numOfSongs;

  Playlist({required this.playlist, required this.numOfSongs});
}

List<Playlist> demoPlayList = [
  Playlist(playlist: 'Oldies', numOfSongs: 18),
  Playlist(playlist: 'Love', numOfSongs: 6),
  Playlist(playlist: 'Spiritual', numOfSongs: 36),
];
List<String> playListName = [
  'Oldies',
  'Love',
  'Spiritual',
];
