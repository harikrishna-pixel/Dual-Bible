//
//  AppDelegate.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 08/12/22.
//

import UIKit
import CoreData
import CoreSpotlight
import UserNotifications
import Flurry_iOS_SDK
import IQKeyboardManager
import AppTrackingTransparency
import UnityAds
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GADFullScreenContentDelegate {

    var navController : UINavigationController?
    var window: UIWindow?
    var DeviceNotificationToken: String = ""
    let notificationCenter = UNUserNotificationCenter.current()
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
         
        
        GetAppInfo.shared.CallParams()
        
        
        UNITY_KEY = UserDefaults.standard.string(forKey: "ads_network_1_field_2_ios") ?? ""
        UnityAds.initialize(UNITY_KEY, testMode: UNITY_TEST_MODE)
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        AppOpenAdManager.shared.loadAd()
        
        
//        self.registerForPushNotifications(application: application)
        
        
        IQKeyboardManager.shared().isEnabled = true
           window?.overrideUserInterfaceStyle = .light
        
        
        
        if UserDefaults.standard.integer(forKey: "Verses")+6 >= UserDefaults.standard.integer(forKey: "NotifiVerses") {
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "Verses"), forKey: "NotifiVerses")
            AppDelegate().onRegisterPushNotification()
        }
        
        
//        if #available(iOS 10.0, *) {
//          // For iOS 10 display notification (sent via APNS)
//          UNUserNotificationCenter.current().delegate = self
//
//          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//          UNUserNotificationCenter.current().requestAuthorization(
//            options: authOptions,
//            completionHandler: {_, _ in })
//        } else {
//          let settings: UIUserNotificationSettings =
//          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//          application.registerUserNotificationSettings(settings)
//        }
        
        
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                print("error : \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                    if UserDefaults.standard.string(forKey: "AppOpenFirst") ?? "0" == "0" {
                        UserDefaults.standard.set("1", forKey: "NotifiStatue")
                        UserDefaults.standard.set("1", forKey: "AppOpenFirst")
                        
                        DispatchQueue.main.async {
                            AppDelegate().onRegisterPushNotification()
                            if UserDefaults.standard.bool(forKey: "LoadData") == false {
                                App_Protocol.DelegateSplash?.LoadData()
                                UserDefaults.standard.setValue(true, forKey: "LoadData")
                            }
                        }
                        self.app_INfo()
                    }
                }
            }
        }
        
        if UserDefaults.standard.string(forKey: "AppOpenFirst") ?? "0" == "1" {
            self.app_INfo()
        }

        
        
        
        
//        Messaging.messaging().delegate = self
//
//        Messaging.messaging().token { token, error in
//          if let error = error {
//            print("Error fetching FCM registration token: \(error)")
//          } else if let token = token {
//
//          }
//        }
        notificationCenter.delegate = self // Local notification config
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                
            }
        }
        
        
        
        
        
        
        // MARK: - Flurry
        
//        Flurry.startSession(apiKey: flurryKey, sessionBuilder: FlurrySessionBuilder.init()
//                .build(crashReportingEnabled: true)
//                .build(logLevel: .all))
        
        
        
            
        return true
        
    }
    
    
    
    func registerForPushNotifications(application: UIApplication) {

      if #available(iOS 10.0, *){
          UNUserNotificationCenter.current().delegate = self
          UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
              if (granted)
              {
                  DispatchQueue.main.async {
                      UIApplication.shared.registerForRemoteNotifications()
                  }
              }
              else{
                  
              }
          })
      }
      else { //If user is not on iOS 10 use the old methods we've been using
          let notificationSettings = UIUserNotificationSettings(
              types: [.badge, .sound, .alert], categories: nil)
          application.registerUserNotificationSettings(notificationSettings)

      }

  }
    
    
    
//    func applicationDidBecomeActive(_ application: UIApplication) {
//
//        let rootViewController = application.windows.first(
//          where: { $0.isKeyWindow })?.rootViewController
//        if let rootViewController = rootViewController {
//          if UserDefaults.standard.string(forKey: "AppOpenFirst") ?? "0" == "1" {
//              AppOpenAdManager.shared.showAdIfAvailable(viewController: rootViewController)
//          }
//        }
//    }
//
//
    
    
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {

        let rootViewController = application.windows.first(
            where: { $0.isKeyWindow })?.rootViewController
        if let rootViewController = rootViewController {
            AppOpenAdManager.shared.showAdIfAvailable(viewController: rootViewController)
        }

    }

    
    
    //  MARK: Notification
    
         func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
             self.DeviceNotificationToken = self.extractTokenFromData(deviceToken: deviceToken)
             
             print("self.DeviceNotificationToken :",self.DeviceNotificationToken)
             
             
//             self.UpdateNotifications()
        }
    
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            print("Failed to register for notifications: \(error.localizedDescription)")
        }
    

        func extractTokenFromData(deviceToken:Data) -> String {
            let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
            return token.uppercased();
        }
    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//
//      let dataDict:[String: String] = ["token": fcmToken ?? ""]
//
//        print("dataDict :",dataDict)
//
//    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      
      if let messageID = userInfo[gcmMessageIDKey] {
        
      }
      completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    

    
    func VersCall() -> String {
        if let path = Bundle.main.path(forResource: "dailyVerse", ofType: "json") {
            do {
                
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                  let jsonOutput = jsonResult as! Array<AnyObject>
                
                
                if UserDefaults.standard.integer(forKey: "NotifiVerses") >= 563 {
                    UserDefaults.standard.setValue(1, forKey: "NotifiVerses")
                }
                
                
                var VersePosition = (UserDefaults.standard.integer(forKey: "Verses") == 0 ? UserDefaults.standard.integer(forKey: "Verses") :UserDefaults.standard.integer(forKey: "NotifiVerses"))
                
                  let VerseInfo = jsonOutput[UserDefaults.standard.integer(forKey: "NotifiVerses")]
                  var MessageTitleAndMsg = ""
                  var VerseDate = ""
                
  
                
                  let chapterList =  BibleContent.sharedInstance.AudioBibleListJson(selecterBookName: VerseInfo["Book"] as! String, selectedId: VerseInfo["Chapter"] as! Int-1, bookNameID: VerseInfo["Book_Id"] as! Int)
                
                  var verse = VerseInfo["Verse"] as! String
                  let BookId = VerseInfo["Book_Id"] as! Int
                  let BookName = BibleContent.sharedInstance.BookToPosition()[BookId-1].components(separatedBy: "-")
                  let bookChapterId = "\(BookName[0]) \(VerseInfo["Chapter"] as! Int):\(verse)"
                 
                if VerseDate == "" {
                    VerseDate = Date().string(format: "MMM d, yyyy")
                }
                
                if verse.contains("--") {
                    var verseArray = verse.components(separatedBy: "--")
                    
                    if Int(verseArray[0])! > chapterList.count {
                        verseArray[0] = String(chapterList.count-1)
                    }
                    if Int(verseArray[1])! > chapterList.count {
                        verseArray[1] = String(chapterList.count-1)
                    }
                    let verseText = String(format: "%@\n%@",chapterList[Int(verseArray[0])!-1],chapterList[Int(verseArray[1])!-1])
                    MessageTitleAndMsg = "\(verseText)_\(bookChapterId)"

                } else {
                    
                    if Int(verse)! > chapterList.count {
                        verse = String(chapterList.count-1)
                    }
                    
                    MessageTitleAndMsg =  "\(chapterList[Int(verse)!-1])_\(bookChapterId)"
                }
                
                if UserDefaults.standard.integer(forKey: "NotifiVerses") >= 563 {
                    VersePosition = 0
                }
                
                UserDefaults.standard.set(VersePosition+1, forKey: "NotifiVerses")
                UserDefaults.standard.set("1", forKey: "NotifiCellStatus")
                NotificationCenter.default.post(name: Notification.Name("ReloadTable"), object: nil)
                
                return MessageTitleAndMsg
                
              } catch {
                   // handle error
            }
        } else {
            return ""
        }
        return ""
    }
    
    
    
    func createNotifications(userInfo: AnyObject) {
//        let navVC = self.window?.rootViewController as! UINavigationController
        if #available(iOS 13.4, *) {

            var readdata = userInfo as! String

            if readdata.contains("_") {
                readdata = userInfo.components(separatedBy: "_")[1]
            }

            UserDefaults.standard.set(readdata, forKey: "readdata")
            App_Protocol.delegateReaderSource?.navigateToSelectedVerse()
            
//        let addUserVC = kStoryboardMainIphone.instantiateViewController(withIdentifier: "BiblePageSwipeViewController") as! BiblePageSwipeViewController
//        navVC.pushViewController(addUserVC, animated: true)

        }
    }
    
    
    
    
    
    // MARK: API
    
    
    
    
    
    func UpdateNotifications() {
        
          let dic:Dictionary<String, AnyObject> = ["dev_app_id": push_appid as AnyObject,
                                                  "dev_id_type":"2" as AnyObject,
                                                  "appDeviceToken": self.DeviceNotificationToken  as AnyObject,
                                                  "appDeviceId":Udid as AnyObject,
                                                  "userid":Udid as AnyObject,
                                                  "country_code": Country_code as AnyObject,
                                                  "language": language as AnyObject,
                                                  "appDevice": platform as AnyObject,
                                                  "deviceVersion": deviceVersion as AnyObject,
                                                  "appVersion":appVersion  as AnyObject,
                                                  "appName":APPNAME as AnyObject,
                                                  "appmode": APPMODE as AnyObject,
                                                  "devicename": devicename as AnyObject,
                                                  "package_name" : bundleID as AnyObject]
                
                        
        
        
        if NetworkManager.sharedInstance.isConnectedToInternet() {
            NetworkManager.sharedInstance.requestPOSTTestData(urlString: "https://bibleoffice.com/BibleReplications/dev/v1/API/UpdateDeviceToIOS.php",params:dic) { (resultDictionary, error) -> () in
                    if resultDictionary != nil {
                                                        

                    }
                }
           }
    }
    
    
//    func app_INfo() {
//
//     let dic:Dictionary<String, AnyObject> = ["ios_bundle_id": bundleID as AnyObject,
//                                              "ios_apple_id": APPLE_ID as AnyObject,
//                                              "response_type": RESPONSE_TYPE as AnyObject]
//
//    if NetworkManager.sharedInstance.isConnectedToInternet() {
//        NetworkManager.sharedInstance.requestPOSTGETData(urlString: GET_APP_INFO,params:dic,  completion:
//            { (resultDictionary, error) -> () in
//                if resultDictionary != nil {
//
//
//                    if API_Switch == "1" {
//                        GetAppInfo.shared.SaveAppinfo(resultDictionary: resultDictionary!)
//                        GetAppInfo.shared.CallParams()
//                        self.UpdateNotifications()
//                    }
//
//                }
//            })
//    } else {
//        if API_Switch == "1" {
//            GetAppInfo.shared.CallParams()
//        }
//    }
//}
    
    func app_INfo() {
        
     let dic:Dictionary<String, AnyObject> = ["ios_bundle_id": bundleID as AnyObject,
                                              "ios_apple_id": APPLE_ID as AnyObject,
                                              "response_type": RESPONSE_TYPE as AnyObject]
        
    if NetworkManager.sharedInstance.isConnectedToInternet() {
        NetworkManager.sharedInstance.requestPOSTGETData(urlString: GET_APP_INFO,params:dic,  completion:
            { (resultDictionary, error) -> () in
                if resultDictionary != nil {
                    
                    
                    if API_Switch == "1" {
                        if NetworkManager.sharedInstance.isConnectedToInternet() {
                            GetAppInfo.shared.SaveAppinfo(resultDictionary: resultDictionary!)
                            GetAppInfo.shared.CallParams()
                            self.UpdateNotifications()
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3.5) {
                            UnityAds.initialize(UNITY_KEY, testMode: UNITY_TEST_MODE)
                                    AdmobManager.shared.requestAds()
                                    AdmobManager.shared.Interstitial_AdLoad()
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2.5) {
                                    AdmobManager.shared.requestRewardAds()
                                    AdmobManager.shared.loadRewardedAd()
                                }
                        }
                    }
                    
                }
            })
    } else {
        if API_Switch == "1" {
            GetAppInfo.shared.CallParams()
        }
    }
}
    
    
    
    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "NKJV_Bible")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}





@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
      
      DispatchQueue.global(qos: .background).async {
          DispatchQueue.main.async {
              
              
              
              switch UIApplication.shared.applicationState {
              case .active:
                  CoreDataModel.sharedInstance.coreDataInsertNotification(CDDailyVerses, book: notification.request.content.title, verseDate: Date().string(format: "MMM d, yyyy"), verse: notification.request.content.body)
                  break
              case .inactive:
                  DispatchQueue.background(delay: 0.2, completion:{
                      CoreDataModel.sharedInstance.coreDataInsertNotification(CDDailyVerses, book: notification.request.content.title, verseDate: Date().string(format: "MMM d, yyyy"), verse: notification.request.content.body)
                  })
                  break
              case .background:
                  DispatchQueue.background(delay: 0.2, completion:{
                      CoreDataModel.sharedInstance.coreDataInsertNotification(CDDailyVerses, book: notification.request.content.title, verseDate: Date().string(format: "MMM d, yyyy"), verse: notification.request.content.body)
                  })
                  break
              default:
                  break
              }

              
              let bookNdVerse = "\(notification.request.content.body)_\(notification.request.content.title)"
              
              UserDefaults(suiteName: "group.com.axe.nkjv.audiobible")!.set(bookNdVerse, forKey: "VerseOfTheDay")
              UserDefaults(suiteName: "group.com.axe.nkjv.audiobible")!.synchronize()
              
              let VersePosition = UserDefaults.standard.integer(forKey: "Verses")
//              UserDefaults.standard.set(VersePosition+1, forKey: "Verses")
              
              App_Protocol.delegateDailyVerse?.reloadDailyVerse()
          }
      }
    
    completionHandler([[.alert, .sound]])
  }

    
   
    
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    
    var Versetitle = response.notification.request.content.title
    
        if Versetitle.contains("--") {
            let verseArray = Versetitle.components(separatedBy: "--")
            Versetitle = verseArray[0]
        }
        
    createNotifications(userInfo: Versetitle as AnyObject)
    
    
    completionHandler()
  }
}


extension AppDelegate {
    
    
    func onRegisterPushNotification()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                
                //----------------- Testing Purpose ---------------------------------
                UserDefaults.standard.set(0.0, forKey: "LastNotificationTime")

                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                //-------------------------------------------------------
                self.onSetLocalNotification()
           
                print(success)
              
                
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func onSetLocalNotification()
    {
        
        let center = UNUserNotificationCenter.current()
            center.getPendingNotificationRequests(completionHandler: { requests in
                
      
                
                if(requests.count == 0)
                {
                    self.onLoadNotificationContent()
                        
                }
                else if (requests.count >= 3)
                {
                    return;
                }
                else
                {
                    self.onLoadNotificationContent()
                }
            })
    }
    
    func onLoadNotificationContent(){
        
        var dateStr = UserDefaults.standard.string(forKey: "NotifiTime") ?? "08:00"
        
        
            
        if dateStr.count != 5 {
            dateStr = DateConfig.shared.dateTimeChangeFormat(str: dateStr, inDateFormat:  "hh:mm a", outDateFormat: "HH:mm")
        }
        
        
        let hour : Int? = Int(dateStr.components(separatedBy: ":")[0])
        let min : Int? = Int(dateStr.components(separatedBy: ":")[1])
        
        var lastNotificationTime = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "LastNotificationTime"))

        if (UserDefaults.standard.double(forKey: "LastNotificationTime") == 0) {
            
            let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let now = NSDate()
            var components = gregorian.components([.year, .month, .day, .hour, .minute, .second], from: now as Date)
            components.hour = hour
            components.minute = min
            components.second = 0
            let date = gregorian.date(from: components)!
            lastNotificationTime = date
        }
        else
        {
            let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let now = lastNotificationTime
            var components = gregorian.components([.year, .month, .day, .hour, .minute, .second], from: now as Date)

            // Change the time to 9:30:00 in your locale
            components.hour = hour
            components.minute = min
            components.second = 0

            let date = gregorian.date(from: components)!
            lastNotificationTime = date
        }
        
        DispatchQueue.main.async {
            
            let Verse = self.VersCall().components(separatedBy: "_")
            let content = UNMutableNotificationContent()
            
            content.title = "Verse Of The Day" // Verse[1]
            content.body = "\(Verse[1]) \(Verse[0])"
            content.sound = UNNotificationSound.default
            content.sound = UNNotificationSound(named:UNNotificationSoundName(rawValue: "Halulayyo.mp3"))
            
            let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: lastNotificationTime)!
            let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let components = gregorian.components([.year, .month, .day, .hour, .minute, .second], from: nextDate as Date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: "DailyNotification\(lastNotificationTime)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if error != nil {
                    print("SOMETHING WENT WRONG")
                }
                else
                {
                    print("\n=====================================")
                    UserDefaults.standard.set(nextDate.timeIntervalSince1970, forKey: "LastNotificationTime")
                    self.onSetLocalNotification()
                            }
            })
        }
    }
    
    
    
}

extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }

}
