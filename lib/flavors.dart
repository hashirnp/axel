enum Flavor {
  production,
  staging,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.production:
        return 'Production App';
      case Flavor.staging:
        return 'Staging App';
    }
  }

}
