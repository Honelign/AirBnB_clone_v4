// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicInfo _$MusicInfoFromJson(Map<String, dynamic> json) => MusicInfo(
      id: json['id'].toString(),
      name: json['track_name'],
      image: json['track_cover'],
    );

Map<String, dynamic> _$MusicInfoToJson(MusicInfo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };
