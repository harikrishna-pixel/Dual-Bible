//
//  Google User Messaging.swift
//  Smart Bible
//
//  Created by ajayprasanth on 19/12/23.
//


import UIKit
import GoogleMobileAds
import UserMessagingPlatform

class Google_User_Messaging: NSObject {
    
    static var Shared = Google_User_Messaging()
    
//    @IBOutlet weak var privacySettingsButton: UIBarButtonItem!
    private var isMobileAdsStartCalled = false
     
    
    func Config(SourceVu:UIViewController) {
        
        let parameters = UMPRequestParameters()
        parameters.tagForUnderAgeOfConsent = false
        
//        let requestParameters = UMPRequestParameters()
//        let debugSettings = UMPDebugSettings()
//        
//        debugSettings.geography = .EEA
//        debugSettings.testDeviceIdentifiers = ["64272FFA-8513-4608-9F19-71475E045D17"]
//        requestParameters.debugSettings = debugSettings
        
        
        
//        UMPDebugSettings *debugSettings = [[UMPDebugSettings alloc] init];
//        debugSettings.testDeviceIdentifiers = @[ @"XXX-XXX-XXX"];
//        debugSettings.geography = UMPDebugGeographyEEA;
//        parameters.debugSettings = debugSettings;
        
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) {
            [weak self] requestConsentError in
            guard let self else { return }
            
            if let consentError = requestConsentError {
                return print("Error: \(consentError.localizedDescription)")
            }
            UMPConsentForm.loadAndPresentIfRequired(from: SourceVu) {
                [weak self] loadAndPresentError in
                guard let self else { return }
                
                if let consentError = loadAndPresentError {
                    // Consent gathering failed.
                    return print("Error: \(consentError.localizedDescription)")
                }
                
                // Consent has been gathered.
                     if UMPConsentInformation.sharedInstance.canRequestAds {
                       self.startGoogleMobileAdsSDK()
                     }
                   }
                 }
                 
                 // Check if you can initialize the Google Mobile Ads SDK in parallel
                 // while checking for new consent information. Consent obtained in
                 // the previous session can be used to request ads.
                 if UMPConsentInformation.sharedInstance.canRequestAds {
                   startGoogleMobileAdsSDK()
                 }
        
               }
               
               private func startGoogleMobileAdsSDK() {
                 DispatchQueue.main.async {
                   guard !self.isMobileAdsStartCalled else { return }

                   self.isMobileAdsStartCalled = true

                   GADMobileAds.sharedInstance().start()
                 }
               }
    
    
    
    
    
}
