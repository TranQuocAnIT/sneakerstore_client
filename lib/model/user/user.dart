
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';
@JsonSerializable()
class User {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "phonenumber")
  int? phonenumber;

  @JsonKey(name: "password")
  String? password;

  @JsonKey(name: "profile_picture")
  String? profilePicture; // New field for profile picture

  User({
    this.id,
    this.name,
    this.phonenumber,
    this.password,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
