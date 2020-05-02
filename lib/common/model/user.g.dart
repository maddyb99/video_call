// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    name: json['name'] as String,
    mobile: json['mobile'] as int,
    uid: json['uid'] as String,
    profilePic: json['profilePic'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'uid': instance.uid,
      'mobile': instance.mobile,
      'profilePic': instance.profilePic,
    };
