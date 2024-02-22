
import 'dart:io';

import 'package:car_crash_list/utils/custom_dialog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/app_constants.dart';

class AdsServices{

  Future<void> showInterAds() async{
    try{
      await InterstitialAd.load(
          adUnitId: Platform.isIOS?AppConstants.adMobInterstitialIdIos:AppConstants.adMobInterstitialId,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) async{
              await ad.show();
            },
            onAdFailedToLoad: (LoadAdError error) {

            },
          )
      );
    }
    catch(e){
      null;
    }
  }

  Future<void> showRewardAds({required Function() onUserEarnReward}) async{
    try{
      await RewardedAd.load(
          adUnitId: AppConstants.adMobRewardId,
          request: const AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) {
              ad.show(onUserEarnedReward: (ad, reward) {
                onUserEarnReward();
              },);
            },
            onAdFailedToLoad: (error) {

            },
          )
      );
    }
    catch(e){
      onUserEarnReward();
    }

  }

}