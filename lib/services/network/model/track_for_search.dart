// To parse this JSON data, do
//
//     final trackSearch = trackSearchFromJson(jsonString);

import 'dart:convert';

TrackSearch trackSearchFromJson(String str) => TrackSearch.fromJson(json.decode(str));

String trackSearchToJson(TrackSearch data) => json.encode(data.toJson());

class TrackSearch {
    TrackSearch({
        required this.id,
        required this.trackName,
        required this.trackDescription,
        required this.trackFile,
        required this.trackStatus,
        required this.trackReleaseDate,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,
        required this.albumId,
        required this.artistId,
        required this.genreId,
    });

    int id;
    String trackName;
    String trackDescription;
    String trackFile;
    bool trackStatus;
    DateTime trackReleaseDate;
    String userId;
    DateTime createdAt;
    DateTime updatedAt;
    AlbumId albumId;
    ArtistId artistId;
    GenreId genreId;

    factory TrackSearch.fromJson(Map<String, dynamic> json) => TrackSearch(
        id: json["id"],
        trackName: json["track_name"],
        trackDescription: json["track_description"],
        trackFile: json["track_file"],
        trackStatus: json["track_status"],
        trackReleaseDate: DateTime.parse(json["track_release_date"]),
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        albumId: AlbumId.fromJson(json["album_id"]),
        artistId: ArtistId.fromJson(json["artist_id"]),
        genreId: GenreId.fromJson(json["genre_id"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "track_name": trackName,
        "track_description": trackDescription,
        "track_file": trackFile,
        "track_status": trackStatus,
        "track_release_date": trackReleaseDate.toIso8601String(),
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "album_id": albumId.toJson(),
        "artist_id": artistId.toJson(),
        "genre_id": genreId.toJson(),
    };
}

class AlbumId {
    AlbumId({
        required this.id,
        required this.albumTitle,
        required this.albumCover,
        required this.albumDescription,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,
    });

    int id;
    String albumTitle;
    String albumCover;
    String albumDescription;
    String userId;
    DateTime createdAt;
    DateTime updatedAt;

    factory AlbumId.fromJson(Map<String, dynamic> json) => AlbumId(
        id: json["id"],
        albumTitle: json["album_title"],
        albumCover: json["album_cover"],
        albumDescription: json["album_description"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "album_title": albumTitle,
        "album_cover": albumCover,
        "album_description": albumDescription,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class ArtistId {
    ArtistId({
        required this.id,
        required this.artistName,
        required this.artistTitle,
        required this.artistCover,
        required this.artistDescription,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,
    });

    int id;
    String artistName;
    String artistTitle;
    String artistCover;
    String artistDescription;
    String userId;
    DateTime createdAt;
    DateTime updatedAt;

    factory ArtistId.fromJson(Map<String, dynamic> json) => ArtistId(
        id: json["id"],
        artistName: json["artist_name"],
        artistTitle: json["artist_title"],
        artistCover: json["artist_cover"],
        artistDescription: json["artist_description"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "artist_name": artistName,
        "artist_title": artistTitle,
        "artist_cover": artistCover,
        "artist_description": artistDescription,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class GenreId {
    GenreId({
        required this.genreTitle,
        required this.genreCover,
        required this.genreDescription,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,
    });

    String genreTitle;
    String genreCover;
    String genreDescription;
    String userId;
    DateTime createdAt;
    DateTime updatedAt;

    factory GenreId.fromJson(Map<String, dynamic> json) => GenreId(
        genreTitle: json["genre_title"],
        genreCover: json["genre_cover"],
        genreDescription: json["genre_description"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "genre_title": genreTitle,
        "genre_cover": genreCover,
        "genre_description": genreDescription,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
