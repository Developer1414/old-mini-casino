import 'package:appodeal_flutter/appodeal_flutter.dart';

class AdsService {
  Future showRewardAd(Function func) async {
    Appodeal.show(AdType.reward);

    Appodeal.setRewardCallback((event) {
      if (event == 'onRewardedVideoFinished') {
        func.call();
      }
    });
  }
}
