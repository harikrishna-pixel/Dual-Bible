//
//  AppConfig.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 08/12/22.
//

import UIKit

class AppConfig: NSObject {

}



// MARK: - API Enable / Disable
//let API_Switch = "0"  // API OFF
let API_Switch = "1"  // API ON






// MARK: - APP Config

var APPNAME_SPLASH = "AMP Bible"
let APPLE_ID = "6449416425"
var FEEDBACKMAIL = "support@bibleoffice.com"




// MARK: - Duel Language Config


var primaryLanguage  = UserDefaults.standard.string(forKey: "text_to_speech_language_code_ios") ?? "en-US"
let SecondaryLanguage  = "en-GB"





//let RESPONSE_TYPE = "1"
let RESPONSE_TYPE = "0"




// MARK: - TEXT TO SPEECH Config

var TSDefaultlanguage = UserDefaults.standard.string(forKey: "text_to_speech_identifier_ios") ?? "com.apple.ttsbundle.Samantha-compact/United States [Samantha]"




// MARK: - App type

//let APP_TYPE = "1"     // BIBLE WITH SINGLE BOOK
let APP_TYPE = "2"       // BIBLE WITH DUEL BOOK
//let APP_TYPE = "3"     // BIBLE WITH MULTI BOOK



