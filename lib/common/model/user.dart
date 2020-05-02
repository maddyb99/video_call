import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    this.name,
    this.mobile,
    this.uid,
    this.profilePic,
  });
  final String name;
  final String uid;
  @JsonKey(nullable: true)
  final int mobile;
  @JsonKey(nullable: true)
  final String profilePic;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
