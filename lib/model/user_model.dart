import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  String? firstName;

  @HiveField(1)
  String? lastName;

  @HiveField(2)
  String? username;

  @HiveField(3)
  String? email;

  @HiveField(4)
  String? password;

  @HiveField(5)
  String? profilePic;

  @HiveField(6)
  String? location;

  User({
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.password,
    this.profilePic,
    this.location,
  });
}
