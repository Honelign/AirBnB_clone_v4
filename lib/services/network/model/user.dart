import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class CustomUser {
  final int id;
  final String name;
  final String email;
  String? phoneNumber;
  final String password;
  final String passwordConfirmation;

  CustomUser(
      {required this.name,
      required this.id,
      required this.email,
      this.phoneNumber,
      required this.passwordConfirmation,
      required this.password});

  factory CustomUser.fromJson(Map<String, dynamic> json) {
    return _$CustomUserFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CustomUserToJson(this);
}
