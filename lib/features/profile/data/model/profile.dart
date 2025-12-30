import 'package:axel/features/profile/domain/entity/profile.dart';

class ProfileModel {
  final String? username;
  final String? fullName;
  final String? imagePath;
  final String? dob;

  ProfileModel({
     this.username,
     this.fullName,
     this.imagePath,
     this.dob,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      username: json['username'],
      fullName: json['fullName'],
      imagePath: json['imagePath'],
      dob: json['dob'],
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'fullName': fullName,
        'imagePath': imagePath,
        'dob': dob,
      };

  Profile toEntity() => Profile(
        username: username,
        fullName: fullName,
        imagePath: imagePath,
        dob: DateTime.parse(dob!),
      );
}
