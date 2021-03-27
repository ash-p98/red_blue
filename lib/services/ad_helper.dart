import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isIOS) {
      return "ca-app-pub-7785242093995268/1029694182";
    } else if(Platform.isAndroid){
      return "ca-app-pub-7785242093995268/6084378618";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get blueAdUnitId {
    if (Platform.isIOS) {
      return "ca-app-pub-7785242093995268/6378331581";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-7785242093995268/4710026699";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get redAdUnitId {
    if (Platform.isIOS) {
      return "ca-app-pub-7785242093995268/3754562890";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-7785242093995268/3863848882";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
