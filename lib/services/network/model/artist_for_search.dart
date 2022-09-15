// To parse this JSON data, do
//
//     final artitstSearch = artitstSearchFromJson(jsonString);

import 'dart:convert';

ArtitstSearch artitstSearchFromJson(String str) => ArtitstSearch.fromJson(json.decode(str));

String artitstSearchToJson(ArtitstSearch data) => json.encode(data.toJson());

class ArtitstSearch {
    ArtitstSearch({
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

    factory ArtitstSearch.fromJson(Map<String, dynamic> json) => ArtitstSearch(
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
