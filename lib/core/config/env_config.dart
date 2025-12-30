import 'package:flutter/services.dart';

class EnvConfig {
  static String get baseUrl {
    switch (appFlavor) {
      case 'production':
        return 'https://fakestoreapi.com';
      case 'staging':
        return 'https://fakestoreapi.com';
      default:
        return "";
    }
  }

  static Future<dynamic> getToken() async {}
}
