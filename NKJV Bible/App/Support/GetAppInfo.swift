//
//  GetAppInfo.swift
//  Audio Bible
//
//  Created by Axeraan Technologies on 09/06/21.
//

import UIKit
import UnityAds


class GetAppInfo: NSObject {
    
    public static let shared = GetAppInfo()
    
    var identifier:[String] = []
    var item_1:[Int] = []
    var value:[Int] = []
    
    
    func SaveAppinfo(resultDictionary: Dictionary<String, AnyObject>) {
                
        
        
        let bibleApdata = resultDictionary["data"] as! Dictionary<String, AnyObject>
        let bible_audio_info = bibleApdata["bible_audio_info"]! as! Dictionary<String,AnyObject>

        
        let coins_data = bibleApdata["coins_data"]! as! Dictionary<String,AnyObject>
        let sub_fields = bibleApdata["sub_fields"]! as! Array<Dictionary<String,AnyObject>>
        
        
        UserDefaults.standard.set(identifier, forKey: "identifier")
        UserDefaults.standard.set(item_1, forKey: "item_1")
        UserDefaults.standard.set(value, forKey: "value")
        
        
        UserDefaults.standard.set(Int(coins_data.stringValueForKey("50_50")), forKey: "50_50")
        UserDefaults.standard.set(Int(coins_data.stringValueForKey("hint")), forKey: "hint")
        UserDefaults.standard.set(Int(coins_data.stringValueForKey("share")), forKey: "share")
        UserDefaults.standard.set(Int(coins_data.stringValueForKey("time_wait")), forKey: "time_wait")
        UserDefaults.standard.set(Int(coins_data.stringValueForKey("try_again")), forKey: "try_again")
        UserDefaults.standard.set(Int(coins_data.stringValueForKey("view_answer")), forKey: "view_answer")
        
        
        
        UserDefaults.standard.set(bible_audio_info.stringValueForKey("audio_basepath"), forKey: "audio_basepath")
        UserDefaults.standard.set(bible_audio_info.stringValueForKey("audio_basepath_type"), forKey: "audio_basepath_type")
        UserDefaults.standard.set(bible_audio_info.stringValueForKey("is_show_mp3_audio"), forKey: "is_show_mp3_audio")
        UserDefaults.standard.set(bible_audio_info.stringValueForKey("text_to_speech_identifier_ios"), forKey: "text_to_speech_identifier_ios")
        UserDefaults.standard.set(bible_audio_info.stringValueForKey("text_to_speech_language_code_ios"), forKey: "text_to_speech_language_code_ios")
        UserDefaults.standard.set(bible_audio_info.stringValueForKey("is_text_to_speech_available_ios"), forKey: "is_text_to_speech_available_ios")
        
    
         
         UserDefaults.standard.set(bibleApdata.stringValueForKey("ads_Type"), forKey: "ads_Type")
        
         UserDefaults.standard.set(bibleApdata.stringValueForKey("ads_facebook_banner_id_ios"), forKey: "ads_facebook_banner_id_ios")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("ads_facebook_interstitial_id_ios"), forKey: "ads_facebook_interstitial_id_ios")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("ads_google_banner_id_ios"), forKey: "ads_google_banner_id_ios")
        
         UserDefaults.standard.set(bibleApdata.stringValueForKey("ads_google_banner_id_ios"), forKey: "ads_google_banner_id_ios")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("ads_google_banner_id_2_ios"), forKey: "ads_google_banner_id_2_ios")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("ads_google_banner_id_3_ios"), forKey: "ads_google_banner_id_3_ios")
        
         UserDefaults.standard.set(bibleApdata.stringValueForKey("ads_google_interstitial_id_ios"), forKey: "ads_google_interstitial_id_ios")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("ads_google_native_id_ios"), forKey: "ads_google_native_id_ios")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("ads_google_openApp_id_ios"), forKey: "ads_google_openApp_id_ios")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("ads_google_reward_id_ios"), forKey: "ads_google_reward_id_ios")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("ads_duration"), forKey: "ads_duration")
        
        
         UserDefaults.standard.set(bibleApdata.stringValueForKey("ads_network_1_field_1_ios"), forKey: "ads_network_1_field_1_ios")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("ads_network_1_field_2_ios"), forKey: "ads_network_1_field_2_ios")
        
        
        
         UserDefaults.standard.set(bibleApdata.stringValueForKey("offer_enabled"), forKey: "offer_enabled")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("offer_days"), forKey: "offer_days")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("offer_count"), forKey: "offer_count")
        
        
        
         UserDefaults.standard.set(bibleApdata.stringValueForKey("app_name"), forKey: "app_name")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("app_shareapp_link"), forKey: "app_shareapp_link")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("app_theme_color"), forKey: "app_theme_color")
         
         UserDefaults.standard.set(bibleApdata.stringValueForKey("book_ads_status"), forKey: "book_ads_status")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("book_ads_app_id"), forKey: "book_ads_app_id")
        
        
         UserDefaults.standard.set(bibleApdata.stringValueForKey("feedback_email"), forKey: "feedback_email")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("image_app_id"), forKey: "image_app_id")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("is_image_available"), forKey: "is_image_available")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("is_multicategory_available"), forKey: "is_multicategory_available")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("is_notification_available"), forKey: "is_notification_available")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("is_quote_available"), forKey: "is_quote_available")
         
         UserDefaults.standard.set(bibleApdata.stringValueForKey("is_subscription_enabled"), forKey: "is_subscription_enabled")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("is_video_available"), forKey: "is_video_available")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("language_code"), forKey: "language_code")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("language_name"), forKey: "language_name")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("push_appid"), forKey: "push_appid")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("quiz_cat_id"), forKey: "quiz_cat_id")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("quote_app_id"), forKey: "quote_app_id")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("short_lang_code"), forKey: "short_lang_code")
        
        
         UserDefaults.standard.set(bibleApdata.stringValueForKey("show_interstitial_row"), forKey: "show_interstitial_row")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("show_native_ads_row"), forKey: "show_native_ads_row")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("sub_identifier_lifetime"), forKey: "sub_identifier_lifetime")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("sub_identifier_oneyear"), forKey: "sub_identifier_oneyear")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("sub_identifier_six_month"), forKey: "sub_identifier_six_month")
        
         UserDefaults.standard.set(bibleApdata.stringValueForKey("sub_identifier_oneyear_value"), forKey: "sub_identifier_oneyear_value")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("sub_identifier_lifetime_value"), forKey: "sub_identifier_lifetime_value")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("sub_identifier_six_month_value"), forKey: "sub_identifier_six_month_value")
        
         UserDefaults.standard.set(bibleApdata.stringValueForKey("sub_sharedsecret"), forKey: "sub_sharedsecret")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("verse_editor_app_id"), forKey: "verse_editor_app_id")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("video_app_id"), forKey: "video_app_id")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("wallpaper_cat_id"), forKey: "wallpaper_cat_id")
         UserDefaults.standard.set(bibleApdata.stringValueForKey("app_type_version"), forKey: "app_type_version")
        
        
        let copyright_info = bibleApdata["copyright_info"]! as! Dictionary<String,AnyObject>
        COPIRIGHTS_URL = copyright_info.stringValueForKey("copyright_url")
        UserDefaults.standard.set(COPIRIGHTS_URL, forKey: "copyright_url")
        
        
        
    }
    
    
    
    
    func CallParams() {
        ADS_TYPE = UserDefaults.standard.integer(forKey: "ads_Type")

        
        ADS_DURATION = UserDefaults.standard.integer(forKey: "ads_duration")


        // Google Ads
             GOOGLE_BANNER_ADS = UserDefaults.standard.string(forKey: "ads_google_banner_id_ios") ?? ""
             GOOGLE_ADS_INTERSTITIAL_ID = UserDefaults.standard.string(forKey: "ads_google_interstitial_id_ios") ?? ""
             GOOGLE_ADS_APP_OPEN = UserDefaults.standard.string(forKey: "ads_google_openApp_id_ios") ?? ""
             GOOGLE_ADS_REWARDED = UserDefaults.standard.string(forKey: "ads_google_reward_id_ios") ?? ""
             GOOGLE_BANNER_ADS_ID2 = UserDefaults.standard.string(forKey: "ads_google_banner_id_2_ios") ?? ""
             GOOGLE_BANNER_ADS_ID3 = UserDefaults.standard.string(forKey: "ads_google_banner_id_3_ios") ?? ""

        
        

        // FaceBook
        ads_facebook_interstitial_id_ios = UserDefaults.standard.string(forKey: "ads_facebook_interstitial_id_ios") ?? ""
        ads_facebook_banner_id_ios = UserDefaults.standard.string(forKey: "ads_facebook_banner_id_ios") ?? ""
        ads_facebook_app_id_ios = UserDefaults.standard.string(forKey: "ads_facebook_app_id_ios") ?? ""


        IRONSOURCE_KEY = UserDefaults.standard.string(forKey: "ads_network_1_field_1_ios") ?? ""
        UNITY_KEY = UserDefaults.standard.string(forKey: "ads_network_1_field_2_ios") ?? ""
        
        
        ads_network_1_field_2_ios = UserDefaults.standard.string(forKey: "ads_network_1_field_2_ios") ?? ""
        ads_network_1_field_3_ios = UserDefaults.standard.string(forKey: "ads_network_1_field_3_ios") ?? ""
        ads_network_1_field_4_ios = UserDefaults.standard.string(forKey: "ads_network_1_field_4_ios") ?? ""
        ads_network_1_field_5_ios = UserDefaults.standard.string(forKey: "ads_network_1_field_5_ios") ?? ""
        ads_network_1_field_6_ios = UserDefaults.standard.string(forKey: "ads_network_1_field_6_ios") ?? ""
        ads_network_2_field_1_ios = UserDefaults.standard.string(forKey: "ads_network_2_field_1_ios") ?? ""
        ads_network_2_field_2_ios = UserDefaults.standard.string(forKey: "ads_network_2_field_2_ios") ?? ""
        ads_network_2_field_3_ios = UserDefaults.standard.string(forKey: "ads_network_2_field_3_ios") ?? ""
        ads_network_2_field_4_ios = UserDefaults.standard.string(forKey: "ads_network_2_field_4_ios") ?? ""
        ads_network_2_field_5_ios = UserDefaults.standard.string(forKey: "ads_network_2_field_5_ios") ?? ""
        ads_network_2_field_6_ios = UserDefaults.standard.string(forKey: "ads_network_2_field_6_ios") ?? ""

        
        book_ads_status = UserDefaults.standard.integer(forKey: "book_ads_status")
        book_ads_app_id = UserDefaults.standard.integer(forKey: "book_ads_app_id")
                

        // MARK: APP CONFIGS

        
        app_shareapp_link = UserDefaults.standard.string(forKey: "app_shareapp_link") ?? ""
        app_theme_color = UserDefaults.standard.string(forKey: "app_theme_color") ?? ""
        app_type_version = UserDefaults.standard.string(forKey: "app_type_version") ?? ""
        FEEDBACKMAIL = UserDefaults.standard.string(forKey: "feedback_email") ?? ""
        image_app_id = UserDefaults.standard.string(forKey: "image_app_id") ?? ""
        is_image_available = UserDefaults.standard.string(forKey: "is_image_available") ?? ""
        is_multicategory_available = UserDefaults.standard.string(forKey: "is_multicategory_available") ?? ""
        is_notification_available = UserDefaults.standard.string(forKey: "is_notification_available") ?? ""
        is_quote_available = UserDefaults.standard.string(forKey: "is_quote_available") ?? ""
        is_subscription_enabled = UserDefaults.standard.string(forKey: "is_subscription_enabled") ?? ""
        is_video_available = UserDefaults.standard.string(forKey: "is_video_available") ?? ""
        language_code = UserDefaults.standard.string(forKey: "language_code") ?? ""
        language_name = UserDefaults.standard.string(forKey: "language_name") ?? ""
        push_appid = UserDefaults.standard.string(forKey: "push_appid") ?? ""
        quiz_cat_id = UserDefaults.standard.string(forKey: "quiz_cat_id") ?? ""
        quote_app_id = UserDefaults.standard.string(forKey: "quote_app_id") ?? ""
        short_lang_code = UserDefaults.standard.string(forKey: "short_lang_code") ?? ""
        show_interstitial_row = UserDefaults.standard.string(forKey: "show_interstitial_row") ?? ""
        show_native_ads_row = UserDefaults.standard.string(forKey: "show_native_ads_row") ?? ""
        sub_identifier_lifetime = UserDefaults.standard.string(forKey: "sub_identifier_lifetime") ?? ""
        sub_identifier_oneyear = UserDefaults.standard.string(forKey: "sub_identifier_oneyear") ?? ""
        sub_sharedsecret = UserDefaults.standard.string(forKey: "sub_sharedsecret") ?? ""
        verse_editor_app_id = UserDefaults.standard.string(forKey: "verse_editor_app_id") ?? ""
        video_app_id = UserDefaults.standard.string(forKey: "video_app_id") ?? ""
        wallpaper_cat_id = UserDefaults.standard.string(forKey: "wallpaper_cat_id") ?? ""
        
              
        APPNAME = UserDefaults.standard.string(forKey: "app_name") ?? APPNAME
        
        SUBSCRIPTIONID_LifeTime = UserDefaults.standard.string(forKey: "sub_identifier_lifetime") ?? ""
        SUBSCRIPTIONID_OneYear = UserDefaults.standard.string(forKey: "sub_identifier_oneyear") ?? ""
        SUBSCRIPTIONID_Six_month = UserDefaults.standard.string(forKey: "sub_identifier_six_month") ?? ""
        SHARED_SECRET = UserDefaults.standard.string(forKey: "sub_sharedsecret") ?? ""
        
        if SUBSCRIPTIONID_LifeTime == "" && SUBSCRIPTIONID_OneYear == "" && SUBSCRIPTIONID_Six_month == "" {
            IS_SUBSCRIPTION_ENABLE = 1
            ADS_TYPE = 1
        } else {
            IS_SUBSCRIPTION_ENABLE = UserDefaults.standard.integer(forKey: "is_subscription_enabled")
            ADS_TYPE = UserDefaults.standard.integer(forKey: "ads_Type")
        }
        
        
        
        API_MAIN = UserDefaults.standard.string(forKey: "audio_basepath") ?? ""
        IRONSOURCE_KEY = UserDefaults.standard.string(forKey: "ads_network_1_field_1_ios") ?? ""
        UNITY_KEY = UserDefaults.standard.string(forKey: "ads_network_1_field_2_ios") ?? ""
        
        primaryLanguage  = UserDefaults.standard.string(forKey: "text_to_speech_language_code_ios") ?? ""
        SPEECH_ENABLE = UserDefaults.standard.string(forKey: "is_text_to_speech_available_ios") ?? ""
        AUDIO_ENABLE = UserDefaults.standard.string(forKey: "is_show_mp3_audio") ?? ""
        
        TSDefaultlanguage = UserDefaults.standard.string(forKey: "text_to_speech_identifier_ios") ?? ""
        app_Audio_path = UserDefaults.standard.string(forKey: "audio_basepath") ?? ""
        Audio_path_Type = UserDefaults.standard.string(forKey: "audio_basepath_type") ?? ""
        COPIRIGHTS_URL = UserDefaults.standard.string(forKey: "copyright_url") ?? ""
        
        
        
        sub_identifier_oneyear_value = UserDefaults.standard.string(forKey: "sub_identifier_oneyear_value") ?? "50"
        sub_identifier_lifetime_value = UserDefaults.standard.string(forKey: "sub_identifier_lifetime_value") ?? "80"
        sub_identifier_six_month_value = UserDefaults.standard.string(forKey: "sub_identifier_six_month_value") ?? "30"
        
        

        UnityAds.initialize(UNITY_KEY, testMode: UNITY_TEST_MODE)
        
    }

    
    
    
    
    
//    func SaveMoreinfo(resultDictionary: Dictionary<String, AnyObject>) {
//
//        let dataArray = resultDictionary["data"]! as! Array<Dictionary<String,AnyObject>>
//
//        print("dataArray :",dataArray)
//
//        MORE_LINKS.removeAll()
//        MORE_IMAGE.removeAll()
//        MORE_IMAGES.removeAll()
//
//        for i in 0..<dataArray.count {
//            if dataArray[i].stringValueForKey("apptype") == "ios" {
//                MORE_LINKS.append(dataArray[i].stringValueForKey("appurl"))
//                MORE_IMAGE.append(dataArray[i].stringValueForKey("thumburl_2"))
//            }
//        }
//
//        self.callDOwnload(IMAGEPOsition: 0)
//
//
//
//    }
    
    
//    func callDOwnload(IMAGEPOsition:Int) {
//        if IMAGEPOsition < MORE_IMAGE.count {
//            DispatchQueue.main.async {
//                self.downloadIMg(IMAGEPOsition: IMAGEPOsition)
//            }
//        }
//    }
//
//
//    func downloadIMg(IMAGEPOsition:Int) {
//        URLSession.shared.dataTask(with: URL(string: MORE_IMAGE[IMAGEPOsition])!) { (data, response, error) in
//            MORE_IMAGES.append(UIImage(data: data!)!)
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
//                self.callDOwnload(IMAGEPOsition:IMAGEPOsition+1)
//            }
//        }.resume()
//    }
//
    
    
    
}

