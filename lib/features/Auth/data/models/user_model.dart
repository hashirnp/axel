import 'package:axel/features/Auth/domain/entities/user.dart';

class UserModel {
  final String? username;
  final String? fullName;
  final String? password;
  final String? imagePath;
  final String? dob;

  UserModel({
    this.username,
    this.fullName,
    this.password,
    this.imagePath,
    this.dob,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      fullName: json['fullName'],
      password: json['password'],
      imagePath: json['imagePath'],
      dob: json['dob'],
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'fullName': fullName,
    'password': password,
    'imagePath': imagePath,
    'dob': dob,
  };

  User toEntity() => User(
    username: username!,
    fullName: fullName!,
    password: password!,
    imagePath: imagePath!,
    dob: DateTime.parse(dob!),
  );
}
