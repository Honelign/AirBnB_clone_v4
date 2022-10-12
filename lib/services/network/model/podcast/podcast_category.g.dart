part of "podcast_category.dart";

PodcastCategory _$PodcastCategoryFromJson(Map<String, dynamic> json) =>
    PodcastCategory(
      id: json['id'] as int,
      name: json['podcast_name'],
      podcasts: (json['podcasts'] as List<dynamic>)
          .map((e) => PodcastInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PodcastCategoryToJson(PodcastCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'podcasts': instance.podcasts.map((e) => e.toJson()).toList(),
    };
