import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  final String firstName;

  @HiveField(1)
  final String lastName;

  @HiveField(2)
  final String username;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String password;

  @HiveField(5)
  final String? profilePic; // ✅ Added field

  User({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
    this.profilePic, // optional para hindi mag-break yung lumang data
  });
}
