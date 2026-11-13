//
//  UnityBannerVC.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 28/04/23.
//

import UIKit
import UnityAds

class UnityBannerVC: NSObject,UADSBannerViewDelegate {
    
    var Banners:UADSBannerView!
    static let shared = UnityBannerVC()
     
    func InitBanner(width:CGFloat = UIScreen.main.bounds.width,height:CGFloat) -> UIView {
        
            self.Banners = UADSBannerView.init(placementId: "Banner_iOS", size: CGSizeMake(width, height))
            self.Banners.delegate = self
//            self.Banners.sizeToFit()
            self.Banners.load()
        
        return self.Banners
    }
    
    
    func bannerViewDidLoad(_ bannerView: UADSBannerView!) {
    }
    
    func bannerViewDidError(_ bannerView: UADSBannerView!, error: UADSBannerError!) {
        print("error :",error.localizedDescription)
    }
}
