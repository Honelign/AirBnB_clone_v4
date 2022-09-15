// To parse this JSON data, do
//
//     final albumSearch = albumSearchFromJson(jsonString);

import 'dart:convert';

AlbumSearch albumSearchFromJson(String str) => AlbumSearch.fromJson(json.decode(str));

String albumSearchToJson(AlbumSearch data) => json.encode(data.toJson());

class AlbumSearch {
    AlbumSearch({
        required this.id,
        required this.albumTitle,
        required this.albumCover,
        required this.albumDescription,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,
        required this.artistId,
    });

    int id;
    String albumTitle;
    String albumCover;
    String albumDescription;
    String userId;
    DateTime createdAt;
    DateTime updatedAt;
    ArtistId artistId;

    factory AlbumSearch.fromJson(Map<String, dynamic> json) => AlbumSearch(
        id: json["id"],
        albumTitle: json["album_title"],
        albumCover: json["album_cover"],
        albumDescription: json["album_description"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        artistId: ArtistId.fromJson(json["artist_id"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "album_title": albumTitle,
        "album_cover": albumCover,
        "album_description": albumDescription,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "artist_id": artistId.toJson(),
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
