//
//  AdmobManager.swift
//  WhtasWeb
//
//  Created by CATALINA on 11/09/20.
//  Copyright © 2020 MehulKathiriya. All rights reserved.
//

import Foundation
import UnityAds
import GoogleMobileAds




class AdmobManager : NSObject, UnityAdsInitializationDelegate, UnityAdsLoadDelegate, UnityAdsShowDelegate, GADFullScreenContentDelegate {
   
    static let shared = AdmobManager()
    
    var vc : UIViewController?
    
    private var interstitial: GADInterstitialAd?
    private var rewardedAd: GADRewardedAd?
    var testmode:Bool = false
    var GoogleOn:Bool = true
    
    
    
    var RewardAd = ""
    var Interstitial_ID = ""
    

    
    func requestAds() {
        UnityAds.load("Interstitial_iOS", loadDelegate: self)
    }
    

    func showAds(vw : UIViewController) {
        vc = vw
        UnityAds.show(vw, placementId:"Interstitial_iOS", showDelegate: self)
    }


    
    
    func requestRewardAds() {
        UnityAds.load("Rewarded_iOS", loadDelegate: self)
    }

    
    func showRewardAds(vw : UIViewController)  {
        vc = vw
        UnityAds.show(vw, placementId:"Rewarded_iOS", showDelegate: self)
    }
    
    
    
    
    
    
    
    func initializationComplete() {
        
    }
    
    func initializationFailed(_ error: UnityAdsInitializationError, withMessage message: String) {
        
    }
    
    func unityAdsAdLoaded(_ placementId: String) {
        
    }
    
    
    func unityAdsAdFailed(toLoad placementId: String, withError error: UnityAdsLoadError, withMessage message: String) {
//        App_Protocol.UnituAdCallDelegate?.NoAdClosed()
//        if RewardAd == "Scratch" {
//            QuizProtocol.CardDelegate?.AdNotAvailable()
//        }
    }
    
    func unityAdsShowComplete(_ placementId: String, withFinish state: UnityAdsShowCompletionState) {
        
        if RewardAd == "WatchAd" {
            App_Protocol.UnituAdCallDelegate?.AdDidClosed()
        } else if RewardAd == "ImageWatermark" {
            ImageAppProtocol.ImageTxtEditDelegate?.CollectCoin()
        }
        
        
        self.requestRewardAds()
        
    }
    
    
    func unityAdsShowFailed(_ placementId: String, withError error: UnityAdsShowError, withMessage message: String) {
        
        if RewardAd == "WatchAd" {
           App_Protocol.UnituAdCallDelegate?.NoAdClosed()
        } else if RewardAd == "ImageWatermark" {
            ImageAppProtocol.ImageTxtEditDelegate?.AdNotAvailable()
        }
        
        self.requestRewardAds()
    }
    
    
    func unityAdsShowStart(_ placementId: String) {
        
    }
    
    func unityAdsShowClick(_ placementId: String) {
        
    }
    
    
    
    
    
    
    
    
    
    
   
    
    
}
    



extension AdmobManager  {
  
    
    
    
    
    func TimeCalculate() -> Bool {
        if UserDefaults.standard.string(forKey: "GoogleAdTime") ?? "" == "" {
            return true
        }
        else {
            var adtime = UserDefaults.standard.string(forKey: "GoogleAdTime")
            let f = DateFormatter()
            f.dateFormat = "HH:mm"

            if  f.date(from: Date().string(format: "HH:mm"))! >=  f.date(from: adtime!)! {
                return true
            } else {
                return false
            }
        }
    }
    
    
    

    
    
    
    
    
    func Interstitial_AdLoad() {
         
        let request = GADRequest()
          GADInterstitialAd.load(withAdUnitID:GOOGLE_ADS_INTERSTITIAL_ID,
                                      request: request,
                            completionHandler: { [self] ad, error in
                              if let error = error {
                                  print("error :",error.localizedDescription)
                                return
                              }
                              interstitial = ad
                              interstitial!.fullScreenContentDelegate = self
                            }
          )
    }
    
    
    
    
  
    func interstitialAddShowApframe(vm:UIViewController) {
        
       if interstitial != nil {
           interstitial!.present(fromRootViewController: vm)
         }
    }
    

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("Ad did Fail To Receive Ad.")
    }
        
    
    
    
    //////////////////////////////////////////////////////////////////////////////////////////    Reward    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    func loadRewardedAd() {
        
        
      let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: GOOGLE_ADS_REWARDED, request: request, completionHandler: { [self] ad, error in
        if let error = error {
            print("error :",error.localizedDescription)
          return
        }
        rewardedAd = ad
        rewardedAd?.fullScreenContentDelegate = self
      }
      )
        
    }
    
    
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        self.showRewardAds(vw: (UIApplication.shared.keyWindow?.rootViewController)!)
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad will present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
             if self.RewardAd == "WatchAd" {
                App_Protocol.UnituAdCallDelegate?.AdDidClosed()
             } else if self.RewardAd == "ImageWatermark" {
                ImageAppProtocol.ImageTxtEditDelegate?.CollectCoin()
             }
        }
                  
        
        var dispatchAfter = DispatchTimeInterval.seconds(ADS_DURATION)
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+dispatchAfter) {
            if self.RewardAd == "" {
                self.Interstitial_AdLoad()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+dispatchAfter) {
            self.loadRewardedAd()
        }
    }
    
    
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        
       
    }
    
    
      
    func show(vm:UIViewController, RewardAd:String) {
        self.RewardAd = RewardAd
          
        if let ad = rewardedAd {
          ad.present(fromRootViewController: vm) {
            let reward = ad.adReward
          }
        } else {
            self.showRewardAds(vw : (UIApplication.shared.keyWindow?.rootViewController)!)
        }
      }
          
    
    
    
    

}
