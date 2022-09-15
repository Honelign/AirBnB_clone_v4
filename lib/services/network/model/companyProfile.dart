import 'package:json_annotation/json_annotation.dart';

part 'companyProfile.g.dart';

@JsonSerializable()
class CompanyProfile {
  final int id;
  final String companyName;
  final String address;
  final String companyLogo;
  final String companyPrivacy;
  final String companyTerms;
  final String companyHelp;
  final String companyBanner;

  CompanyProfile(
      {required this.id,
      required this.companyName,
      required this.address,
      required this.companyBanner,
      required this.companyHelp,
      required this.companyLogo,
      required this.companyPrivacy,
      required this.companyTerms});

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return _$CompanyProfileFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CompanyProfileToJson(this);
}
