// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String?,
      name: json['name'] as String?,
      phonenumber: (json['phonenumber'] as num?)?.toInt(),
      password: json['password'] as String?,
      profilePicture: json['profile_picture'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phonenumber': instance.phonenumber,
      'password': instance.password,
      'profile_picture': instance.profilePicture,
    };
