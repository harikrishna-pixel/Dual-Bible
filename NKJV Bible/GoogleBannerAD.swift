//
//  GoogleBannerAD.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 31/05/23.
//

import UIKit
import GoogleMobileAds


class GoogleBannerAD: NSObject, GADFullScreenContentDelegate,  GADBannerViewDelegate {

    
    static let shared = GoogleBannerAD()
    var SourceVC:UIViewController?
    var adBannerView: GADBannerView!
    
    func loadAd () {
        self.adBannerView.load(GADRequest())
    }
    
    func InitBanner(width:CGFloat ,height:CGFloat, BannerId:String ) -> GADBannerView {
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "df9ca762d90df7db9dccbff70d1d3a0d" ]
        self.adBannerView = GADBannerView(adSize: GADAdSizeFromCGSize(CGSize(width: width, height: height)))
        self.adBannerView.adUnitID = BannerId
        self.adBannerView.delegate = self
        self.adBannerView.backgroundColor = .clear
        self.adBannerView.rootViewController = SourceVC
        return self.adBannerView
    }
    
}
