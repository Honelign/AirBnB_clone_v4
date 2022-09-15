// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'companyProfile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyProfile _$CompanyProfileFromJson(Map<String, dynamic> json) =>
    CompanyProfile(
      id: json['id'] as int,
      companyName: json['companyName'] as String,
      address: json['address'] as String,
      companyBanner: json['companyBanner'] as String,
      companyHelp: json['companyHelp'] as String,
      companyLogo: json['companyLogo'] as String,
      companyPrivacy: json['companyPrivacy'] as String,
      companyTerms: json['companyTerms'] as String,
    );

Map<String, dynamic> _$CompanyProfileToJson(CompanyProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyName': instance.companyName,
      'address': instance.address,
      'companyLogo': instance.companyLogo,
      'companyPrivacy': instance.companyPrivacy,
      'companyTerms': instance.companyTerms,
      'companyHelp': instance.companyHelp,
      'companyBanner': instance.companyBanner,
    };
