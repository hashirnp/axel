class Profile {
  final String? username;
  final String? fullName;
  final String? imagePath;
  final DateTime? dob;

  Profile({
    required this.username,
    required this.fullName,
    required this.imagePath,
    required this.dob,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'fullName': fullName,
    'imagePath': imagePath,
    'dob': dob,
  };
}
