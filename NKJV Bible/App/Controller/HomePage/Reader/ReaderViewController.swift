//
//  ReaderViewController.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 08/12/22.
//

import UIKit
import CoreMedia
import AppTrackingTransparency


class ReaderViewController: UIViewController, ReaderDelegate, ProgressViewDelegate {
        

    weak var NoteVu: SaveNotes?
    weak var MenuView: VersesMenu?
    weak var WallpaperVU:WallpaperView?
    weak var SubscriptionVu: SubscriptionPopup?
    var PopupMenuView: PopupMenu?
    
    var myView:UIView?
    var VerseView:UIView?
    var MenuFrame:UIView?
    var MenuItems = ["Home", "Daily Verse", "My Library", "More"]
    lazy var BibleSavedVerses:Array<String> = []
    lazy var BookFilter:Array<String> = []
    var Themecolor:UIColor?
    
    
    
    @IBOutlet weak var BannerVu: UIView!
    @IBOutlet weak var TabVu: UIView!
    
    @IBOutlet weak var ContainerView: UIView!
    
    @IBOutlet weak var PlayerView: UIView!
    @IBOutlet weak var PlayerSubView: UIView!
    @IBOutlet weak var PlayerImage:UIImageView!
    
    @IBOutlet weak var HomeBtnView: UIView!
    @IBOutlet weak var DailyVerseBtnView: UIView!
    @IBOutlet weak var LibraryBtnView: UIView!
    @IBOutlet weak var MoreBtnView: UIView!
    
    
    @IBOutlet weak var HomeImg:UIImageView!
    @IBOutlet weak var DailyVerseImg:UIImageView!
    @IBOutlet weak var LibraryImg:UIImageView!
    @IBOutlet weak var MoreImg:UIImageView!
    
    @IBOutlet weak var PopupBottomimg:UIImageView!
    @IBOutlet weak var HomeSubImg:UIImageView!
    
    @IBOutlet weak var NightModeBtn:UIButton!
    @IBOutlet weak var AdInfo:UIButton!
    @IBOutlet weak var DailyVerseSubImg:UIImageView!
    @IBOutlet weak var LibrarySubImg:UIImageView!
    @IBOutlet weak var MoreSubImg:UIImageView!
    
    @IBOutlet weak var HomeTxt:UILabel!
    @IBOutlet weak var DailyVerseTxt:UILabel!
    @IBOutlet weak var LibraryTxt:UILabel!
    @IBOutlet weak var MoreTxt:UILabel!
    
    
    @IBOutlet weak var BannerConstrain: NSLayoutConstraint!
    @IBOutlet weak var BottomMenyConstrain: NSLayoutConstraint!
//    @IBOutlet weak var AdBottomFrame: NSLayoutConstraint!
    
    @IBOutlet weak var VeresViewBottom: NSLayoutConstraint!
    @IBOutlet weak var PlayerSubViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var Navigateframe: UIView!
    @IBOutlet weak var SwipeDisable: UIView!
    @IBOutlet weak var playerIcon: UIImageView!
    @IBOutlet weak var playerSubMenuFrame: UIView!
    
    
    @IBOutlet weak var ChapterTxt:UILabel!
    @IBOutlet weak var BookTxt:UILabel!
    
    var ChapterVc: ChapterView?
    var VerseListVc: VerseListView?
    
    weak var SpeechView :SpeechVu?
    weak var SlideCard :SlideCardView?
     
    
    @IBOutlet weak var PlayerButton: UIButton!
    
    
    @IBOutlet weak var AVMainView: UIView!
    @IBOutlet weak var AVPSlidervu: UIView!
    @IBOutlet weak var AVstartTime: UILabel!
    @IBOutlet weak var AVTimeRemain: UILabel!
    @IBOutlet weak var AVTitleText: UILabel!
    @IBOutlet weak var AVswitch: UISlider!
    
    
    @IBOutlet var progressView: ProgressView!
    weak var timer: Timer?
    @IBOutlet var LoaderImg: UIView!
    @IBOutlet weak var CloudImage: UIImageView!
    @IBOutlet weak var PLayerConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var PlayerSuvViewBottom: NSLayoutConstraint!
    @IBOutlet weak var PlayerSuvViewWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var RepeatView: UIView!
    @IBOutlet weak var PreviousView: UIView!
    @IBOutlet weak var BackwardView: UIView!
    @IBOutlet weak var Playview: UIView!
    @IBOutlet weak var ForwardView: UIView!
    @IBOutlet weak var NextView: UIView!
    @IBOutlet weak var StopView: UIView!
    
    
    
    @IBOutlet weak var AVplayIcon: UIImageView!
    @IBOutlet var AVRepeat: UIImageView!
    @IBOutlet var AVBackword: UIImageView!
    @IBOutlet var AVForwardImg: UIImageView!
    @IBOutlet var AVPrevious: UIImageView!
    @IBOutlet var AVNext: UIImageView!
    @IBOutlet var AVStop: UIImageView!
    
    
    @IBOutlet weak var topBannerConstant: NSLayoutConstraint!
    
    
    var imageView:UIImageView!
    lazy var DownloadesArray:Array<String> = []
    var currentTime:Int = 0
    lazy var currentTimeacu: Double = 0.0
    lazy var SwitchStatus:String = "Play"
    lazy var playStatus:Bool = false
    var Pageindex:Int = 0
    var BookName:String = ""
    var pagecount:Int = 0
    lazy var UrlFilter:String = ""
    lazy var SelectedTab:String = "0"
    lazy var Downloadfilename:String = "Mp3"
     
    var BOSXIB:BookOfferScreen?
    
    lazy var pageViewController: UIPageViewController = {
       return UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        App_Protocol.delegateReader = self
         
    
        self.PlayerSubViewHeight.constant = (isIpad ? 44:36)
        self.playerSubMenuFrame.layer.cornerRadius = (isIpad ? 22:18)
        self.playerSubMenuFrame.layer.masksToBounds = true
        
        PlayerView.ViewShadow((isIpad ? 30:25), color: UserDefaults.standard.color(forKey: "AppThemeColor")!)
        AVswitch.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
                
        self.PageConfig()
        self.BannerConstrain.constant = FrameConstrains //(StatusbarHeight > 30 ? 90:70)
        

        self.BottomMenyConstrain.constant = StatusbarHeight
        
        
        
        if AUDIO_ENABLE == "0" && SPEECH_ENABLE == "0" {
            PlayerView.isHidden = true
            PlayerSubView.isHidden = true
        } else {
            PlayerView.isHidden = false
            PlayerSubView.isHidden = false
        }
        
        self.mainContainer()
        
        if IS_SUBSCRIPTION_ENABLE == 0 {
            self.AdInfo.isHidden = true
        }
        
        
        self.SelectedTab = "0"
        Navigateframe.isHidden = true
        self.Buttonfram()
        self.HomeBtnView.isHidden = false
        HomePageCall(Status: false)
        
        
        
//        if IS_SUBSCRIPTION_ENABLE == 1  && (NetworkManager.sharedInstance.isConnectedToInternet() || UserDefaults.standard.string(forKey: "PriceTag3") ?? "" != "") {
//            if PaymentHistory.sharedInstance.paymentInfo() {
//                var Paydate = UserDefaults.standard.string(forKey: "PayCallDate") ?? ""
//                if Paydate == "" {
//                    Paydate = Date().string(format: "dd-MM-yyyy")
//                }
//                
//                let showDate1 = GetReceptKey.shared.convertData(date: Paydate)
//                let diff = showDate1.interval(ofComponent: .day, fromDate: Date())
//                
//                if diff < 0 {
//                    self.CallPaymentPopup()
//                }
//            }
//        }
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if  self.Themecolor!.toHexString() == BGNightMode.toHexString() {
            self.NightModeBtn.setImage(UIImage(named: "night-mode-on"), for: .normal)
        } else {
            self.NightModeBtn.setImage(UIImage(named: "night-mode-off"), for: .normal)
        }
        
//        DispatchQueue.main.async {
//            self.AdInfo.setImage(UIImage(named: PaymentHistory.sharedInstance.paymentInfo() ?  "ad-free" : "AdInfo"), for: .normal)
//        }
        
        self.paymentStatus()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        if UserDefaults.standard.string(forKey: "AppOpenFirst") ?? "0" == "1" {
            if PaymentHistory.sharedInstance.paymentInfo() && OpenAdLoaded {
                OpenAdLoaded = false
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
                    AppOpenAdManager.shared.showAdIfAvailable(viewController: (UIApplication.shared.keyWindow?.rootViewController)!)
                }
            }
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                if status == .authorized {
                    Google_User_Messaging.Shared.Config(SourceVu: self)
                }
            })
        })
       
        
        
//        if NetworkManager.sharedInstance.isConnectedToInternet() {
//            self.moreAppScreen()
//        }
        
        
        if AUDIO_ENABLE == "0" && SPEECH_ENABLE == "0" {
            PlayerView.isHidden = true
            PlayerSubView.isHidden = true
        }
        
        self.VeresViewBottom.constant = -72
        
        
        
        
        if PaymentHistory.sharedInstance.paymentInfo() && book_ads_status > 0 {
            
            if UserDefaults.standard.string(forKey: "PopupTodayDate") ?? "" != Date().string(format: "dd-MM-yyyy") {
                UserDefaults.standard.setValue(UserDefaults.standard.integer(forKey: "BookPopup")+1, forKey: "BookPopup")
                UserDefaults.standard.setValue(Date().string(format: "dd-MM-yyyy"), forKey: "PopupTodayDate")
            }
            
            let Book_offer_days:Int = (Int(offer_days) ?? 10)/2
                         
            if Book_offer_days > 0 {
                if UserDefaults.standard.integer(forKey: "BookPopup") == Book_offer_days {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2.0) {
                        let AllMoreLink = CoreDataModel.sharedInstance.GetMoreBookShare(entity: CDMoreBookApi)
                        if AllMoreLink.count > 0 {
                            self.BookOffer(AllMoreLink: AllMoreLink)
                            UserDefaults.standard.setValue(0, forKey: "BookPopup")
                        }
                    }
                 }
            }
        }
        
        
    }
    
    
    func BookOffer(AllMoreLink: [String]) {
        self.BOSXIB = BookOfferScreen.fromNib(named: "BookOfferScreen")
        self.BOSXIB!.frame = self.view.bounds
        self.BOSXIB!.AllMoreLink = AllMoreLink
        self.BOSXIB!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(self.BOSXIB!)
    }

    
    
    func paymentStatus() {
        DispatchQueue.main.async {
            if PaymentHistory.sharedInstance.paymentInfo() {
                self.AdInfo.setImage(UIImage(named: "ad-free"), for: .normal)
            } else {
                if PaymentHistory.sharedInstance.paymentInfoVerify() {
                    self.AdInfo.setImage(UIImage(named: "ad-free"), for: .normal)
                } else {
                    self.AdInfo.setImage(UIImage(named: "AdInfo"), for: .normal)
                }
            }
        }
    }
    
    
     
    
    func CallRate(RateContent:String) {
        let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "RateUsViewController") as! RateUsViewController
        vc.RateContent = RateContent
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func ImageEditor(Verse:String,Book:String,Image:UIImage) {
        FileManager.default.clearTmpDirectory()
        let vc = kStoryboardImageIphone.instantiateViewController(withIdentifier: "IMageEditingPageVc") as! IMageEditingPageVc
        vc.verseTxt = Verse
        vc.titceTxt = Book
        vc.GetImage = Image
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
//    func CallPaymentPopup() {
//        let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "NewPaymentViewController") as! NewPaymentViewController
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//        self.present(vc, animated: true, completion: nil)
//    }
    
    
    func mainContainer() {
        
        if AUDIO_ENABLE == "0" && SPEECH_ENABLE == "0" {
            PlayerView.isHidden = true
            PlayerSubView.isHidden = true
        }
        
        for view in self.ContainerView.subviews {
            view.removeFromSuperview()
        }
        
        self.topBannerConstant.constant = 0.0
        self.BottomMenyConstrain.constant = StatusbarHeight
        self.VeresViewBottom.constant = -72.0
        
        
        let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "PageSwipeVc") as! PageSwipeVc
        self.ContainerView.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: self.ContainerView.topAnchor).isActive = true
        vc.view.leftAnchor.constraint(equalTo: self.ContainerView.leftAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: self.ContainerView.bottomAnchor).isActive = true
        vc.view.rightAnchor.constraint(equalTo: self.ContainerView.rightAnchor).isActive = true
        
        UserDefaults.standard.set(BookURL.sharedInstance.bookURL(BookNo: String(self.Pageindex)), forKey: "Bookurl")
        
        let fileName = String(format: "%@_%@", UserDefaults.standard.string(forKey: "SelectedLanguage")!,UserDefaults.standard.string(forKey: "BookurlForAudio")!.replacingOccurrences(of: "/", with: ":"))
        
        self.ViewInit()
        self.StopAv()
        if DownloadedFile.shared.DownloadedArray().contains(fileName) {
            CloudImage.image = UIImage(named: "tick_white")
        } else {
            CloudImage.image = UIImage(named: "DownloadImg")
        }
        
    }
    
    
    
    func hideBottomMenu(Status:Bool)  {
        self.BottomMenyConstrain.constant =  Status ? -70:StatusbarHeight
    }
    
    func PageConfig() {
         
        BookTxt.text = UserDefaults.standard.string(forKey: "BookName")
        ChapterTxt.text = "Ch-\(UserDefaults.standard.string(forKey: "BookChapter")!)"
        
        self.Pageindex = Int(UserDefaults.standard.string(forKey: "BookChapter")!)!
        
        
        self.Themecolor = UserDefaults.standard.color(forKey: "AppThemeColor")!
        
        self.view.backgroundColor = (self.Themecolor == BGNightMode ? BGNightMode:UIColor.white)
        BannerVu.backgroundColor = (self.Themecolor == BGNightMode ? DarkModeColor:Themecolor)
        TabVu.backgroundColor = (self.Themecolor == BGNightMode ? DarkModeColor:Themecolor)
        AVMainView.backgroundColor = self.Themecolor
        self.playerIcon.backgroundColor = self.Themecolor
        self.pagecount = BibleContent.sharedInstance.AudioBibleListCount(selecterBookName: UserDefaults.standard.string(forKey: "BookName")!)
        
        
        self.HomeTxt.textColor = (self.Themecolor == BGNightMode ? .black:Themecolor)
        self.DailyVerseTxt.textColor = (self.Themecolor == BGNightMode ? .black:Themecolor)
        self.LibraryTxt.textColor = (self.Themecolor == BGNightMode ? .black:Themecolor)
        self.MoreTxt.textColor = (self.Themecolor == BGNightMode ? .black:Themecolor)
        
        
        self.playerSubMenuFrame.backgroundColor = self.Themecolor
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.HomeImg!, colorVu: .white)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.DailyVerseImg!, colorVu: .white)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.LibraryImg!, colorVu: .white)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.MoreImg!, colorVu: .white)
        
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.PlayerImage!, colorVu: self.Themecolor!)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.HomeSubImg!, colorVu: self.Themecolor!)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.DailyVerseSubImg!, colorVu: self.Themecolor!)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.LibrarySubImg!, colorVu: self.Themecolor!)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.MoreSubImg!, colorVu: self.Themecolor!)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.PopupBottomimg!, colorVu: self.Themecolor!)
                
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.AVRepeat!, colorVu: .white)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.AVBackword!, colorVu: .white)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.AVForwardImg!, colorVu: .white)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.AVPrevious!, colorVu: .white)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.AVNext!, colorVu: .white)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.AVStop!, colorVu: .white)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.AVplayIcon!, colorVu: .white)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.playerIcon!, colorVu: .white)
        PlayerView.ViewShadow((isIpad ? 30:25), color: UserDefaults.standard.color(forKey: "AppThemeColor")!)
        
        
//        self.view.backgroundColor = (self.Themecolor == BGNightMode ? BGNightMode:.white)
//        self.BannerView.backgroundColor = (self.Themecolor == BGNightMode ? BGNightMode:.white)
        
        
        if UserDefaults.standard.string(forKey: "Shuffle") == "true" {
            self.RepeatView.backgroundColor = .white
            ImageTint.sharedInstance.imageTintcolorMethod(img: self.AVRepeat! , colorVu: UserDefaults.standard.color(forKey: "AppThemeColor")!)
        } else {
            self.RepeatView.backgroundColor = UIColor.clear
            ImageTint.sharedInstance.imageTintcolorMethod(img: self.AVRepeat! , colorVu: .white)
        }
        
        
    }
     
    
    
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                SwitchStatus = "Play"
                break
            case .moved:
                SwitchStatus = "Moving"
                if playStatus == true {
                    let seconds : Int64 = Int64(AVswitch.value)
                    let minutes:Int = Int(seconds / 60) % 60
                    let second:Int = Int(seconds) % 60
                    self.AVstartTime.text = String(format: "%d:%02i",minutes,second)
                    AudioPlayerService.sharedInstance.setupNowPlaying()
                }
                break
            case .ended:
                SwitchStatus = "Play"
                let seconds : Int64 = Int64(AVswitch.value)
                let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
                AudioPlayerService.sharedInstance.player?.seek(to: targetTime)
                if Int(self.AVswitch.value) == Int(self.AVswitch.maximumValue) {
                    timer?.invalidate()
                    ViewInit()
                }
                break
            default:
                break
            }
        }
    }
    
    
    
    

 @IBAction func ChapterSelectionAction(_ sender: Any) {
     
        if self.myView?.superview == nil {
            self.myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
            self.view.addSubview(self.myView!)
            self.ChapterVc = ChapterView.fromNib(named: "ChapterView")
            self.ChapterVc!.SelectedBook = (UserDefaults.standard.string(forKey: "BookChapter")!)
            self.ChapterVc!.frame = self.myView!.bounds
            self.ChapterVc!.BookName.text = UserDefaults.standard.string(forKey: "BookName")
            self.ChapterVc!.ScreenName = "Home"
            self.ChapterVc!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.myView!.addSubview(self.ChapterVc!)
        }
    }
    
    
    
    func VerseSelectionAction(Chapter:Int) {
        
        
            if self.VerseView?.superview == nil {
                self.VerseView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
                self.view.addSubview(self.VerseView!)
                self.VerseListVc = VerseListView.fromNib(named: "VerseListView")
                self.VerseListVc!.SelectedBook = (UserDefaults.standard.string(forKey: "BookChapter")!)
                self.VerseListVc!.SelectedBookName = UserDefaults.standard.string(forKey: "BookName")!
                self.VerseListVc!.frame = self.VerseView!.bounds
                self.VerseListVc!.BookName.text = "\(UserDefaults.standard.string(forKey: "BookName")!) Ch-\(Chapter)"
                self.VerseListVc!.chapter = Chapter
                self.VerseListVc!.ScreenName = "Home"
                self.VerseListVc!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.VerseView!.addSubview(self.VerseListVc!)
            }
       }
    
    
    
    
    func CallAds() {
        
        if PaymentHistory.sharedInstance.paymentInfo() {
            if  LastClickCount  == 5 {
                LastClickCount = 0
                UserDefaults.standard.set(LastClickCount, forKey: "LastClickCount")
                self.IndestrialAd()
            }
            else {
                LastClickCount = LastClickCount+1
                UserDefaults.standard.set(LastClickCount, forKey: "LastClickCount")
            }
        }
        
    }
    
    
    func CallWallpaperAds() {
        
        if PaymentHistory.sharedInstance.paymentInfo() {
            if  WallpaperAds  == 5 {
                WallpaperAds = 0
                UserDefaults.standard.set(WallpaperAds, forKey: "WallpaperAds")
                self.IndestrialAd()
            }
            else {
                WallpaperAds = WallpaperAds+1
                UserDefaults.standard.set(WallpaperAds, forKey: "WallpaperAds")
            }
        }
        
    }
    
    
    func IndestrialAd() {

    }
    
    
    
    
    @IBAction func playerMenuAction(_ sender: Any) {
        self.PlayerButton.isEnabled = false
        if AUDIO_ENABLE == "1" && SPEECH_ENABLE == "0" {
            self.playerAnimationAction()
        } else if SPEECH_ENABLE == "1" && AUDIO_ENABLE == "0"{
            self.TextToSpeech()
        } else if SPEECH_ENABLE == "1" && AUDIO_ENABLE == "1"{
            self.playerMenuAnimationAction()
        } else {
            self.view.makeToast("Please try later", duration: 2.0, position: .bottom)
        }
    }
    
    @IBAction func SpeechFrameXibAction(_ sender: Any) {
        self.TextToSpeech()
        self.playerMenuAnimationAction()
    }
    
    
    func TextToSpeech() {
        self.myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
//        self.myView?.backgroundColor = self.Themecolor
        self.view.addSubview(self.myView!)
        let TextInfo = App_Protocol.delegateReaderSource?.GetTSData()

        self.SpeechView = SpeechVu.fromNib(named: "SpeechVu")
        self.SpeechView!.frame = self.myView!.bounds
        self.SpeechView!.AudioBibleList = TextInfo!.AudioBibleList
        self.SpeechView!.BookIndex = Int(UserDefaults.standard.string(forKey: "BookChapter")!)
        self.SpeechView!.BookName = TextInfo!.BookName
        self.SpeechView!.BookIndexCount = TextInfo!.pagecount
        self.SpeechView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.myView!.addSubview(self.SpeechView!)
        self.PlayerButton.isEnabled = true
    }
    
    
    @IBAction func PlayerAction(_ sender: Any) {
        
        self.playerAnimationAction()
        self.playerMenuAnimationAction()
    }
    
    
    @IBAction func CloseAVPlayerAction(_ sender: Any) {
        self.playerAnimationAction()
    }
    
    
    @objc func playerAnimationAction() {
        self.StopAv()
        if PLayerConstrain.constant == -200 {
            UIView.animate(withDuration: 0.4, animations: {
                self.PLayerConstrain.constant = 10
                self.SwipeDisable.isHidden = false
                self.view.layoutIfNeeded()
            }, completion: { finished in
                self.PlayerButton.isEnabled = true
            })
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                self.PLayerConstrain.constant = -200
                self.SwipeDisable.isHidden = true
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    
    
    func playerONOFFCheck() {
        if self.PlayerSuvViewBottom.constant == 25 {
            self.playerMenuAnimationAction()
        }
    }
    
    
    @objc func playerMenuAnimationAction() {
            if self.PlayerSuvViewBottom.constant == -23 {
                UIView.animate(withDuration: 0.4, animations: {
                    self.PlayerSuvViewBottom.constant = PlayerSuvViewConstrain
                     self.PlayerImage.image = UIImage(named: "close popup")
                    ImageTint.sharedInstance.imageTintcolorMethod(img: self.PlayerImage!, colorVu: self.Themecolor!)
                     self.view.layoutIfNeeded()
                }, completion: { finished in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.4) {
                        UIView.animate(withDuration: 0.4) {
                            self.playerIcon.isHidden = true
                            self.PlayerSuvViewWidth.constant = (isIpad ? 340:240) // PlayerSuvVuWidth
                            self.PlayerButton.isEnabled = true
                            self.view.layoutIfNeeded()
                        }
                    }
                })
            } else {
                UIView.animate(withDuration: 0.4, animations: {
                    self.playerIcon.isHidden = false
                    self.PlayerSuvViewWidth.constant = (isIpad ? 44:36)
                    self.view.layoutIfNeeded()
                }, completion: { finished in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.4) {
                        UIView.animate(withDuration: 0.4) {
                            self.PlayerSuvViewBottom.constant = -23
                            self.PlayerImage.image = UIImage(named: "headphone")
                            ImageTint.sharedInstance.imageTintcolorMethod(img: self.PlayerImage!, colorVu: self.Themecolor!)
                            self.PlayerButton.isEnabled = true
                             self.view.layoutIfNeeded()
                        }
                    }
                })
            }
    }
    
    
    
    func ClosePlayerPopup() {
        UIView.animate(withDuration: 0.4, animations: {
            self.playerIcon.isHidden = false
            self.PlayerSuvViewWidth.constant = (isIpad ? 44:36)
            self.view.layoutIfNeeded()
        }, completion: { finished in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.4) {
                UIView.animate(withDuration: 0.4) {
                    self.PlayerSuvViewBottom.constant = -23
                    self.PlayerImage.image = UIImage(named: "headphone")
                    ImageTint.sharedInstance.imageTintcolorMethod(img: self.PlayerImage!, colorVu: self.Themecolor!)
                    self.PlayerButton.isEnabled = true
                     self.view.layoutIfNeeded()
                }
            }
        })
    }
    
    
    
    
    @IBAction func SliderCardNibAction(_ sender: Any) {
        
        let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "SlideCardVC") as! SlideCardVC
        let ChapterNo = UserDefaults.standard.string(forKey: "BookChapter")
        vc.Bookname =  "\(UserDefaults.standard.string(forKey: "BookName")!)-\(ChapterNo!):0"
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    
    
    @IBAction func BookSelectionAction(_ sender: Any) {
        let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "BookListViewController") as! BookListViewController
        vc.ChapterNo = UserDefaults.standard.string(forKey: "BookChapter")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func SearchNavigation(_ sender: Any) {
        
        
        let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    func Quiz(Go:Bool) {
        let vc = kStoryboardQuizIphone.instantiateViewController(withIdentifier: "SelectionViewController") as! SelectionViewController
            vc.ChapterString = (Go ? UserDefaults.standard.string(forKey: "BookChapter")!:"")
            vc.BookString = (Go ? UserDefaults.standard.string(forKey: "BookName")!:"")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
 
    
        
    func FeedbackNavigate() {
        
        if NetworkManager.sharedInstance.isConnectedToInternet() {
            let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.view.makeToast("No internet connection", duration: 2.0, position: .center)
        }
    }
    
    
    
    
    @IBAction func HomeAction(_ sender: Any) {
        App_Protocol.delegateReaderSource?.ReloadBibleData(ChapterNo:UserDefaults.standard.integer(forKey: "BookChapter"))
        
        self.SelectedTab = "0"
        Navigateframe.isHidden = true
        self.Buttonfram()
        self.HomeBtnView.isHidden = false
        
        HomePageCall(Status: false)
    }
    
    func HomePageCall(Status:Bool) {
        
        if Status {
            self.SelectedTab = "0"
            Navigateframe.isHidden = true
            
            self.Buttonfram()
            self.HomeBtnView.isHidden = false
        }
        
        if AUDIO_ENABLE == "0" && SPEECH_ENABLE == "0" {
            PlayerView.isHidden = true
            PlayerSubView.isHidden = true
        } else {
            PlayerView.isHidden = false
            PlayerSubView.isHidden = false
        }
        
    }
    
    @IBAction func DailyVereseAction(_ sender: Any) {
        if self.SelectedTab != "1" {
            self.playerONOFFCheck()
            self.SelectedTab = "1"
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+(self.PlayerSuvViewBottom.constant == 25 ? 1:0.0)) {
                self.PlayerView.isHidden = true
                self.PlayerSubView.isHidden = true
                self.Buttonfram()
                self.DailyVerseBtnView.isHidden = false
                self.Navigateframe.isHidden = false
                let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "DailyVereseViewController") as! DailyVereseViewController
                self.addChild(vc)
                self.Navigateframe.addSubview(vc.view)
                self.Navigateframe.layer.masksToBounds = true
            }
        }
    }
    
    
    @IBAction func MylibraryAction(_ sender: Any) {
        if self.SelectedTab != "2" {
            self.playerONOFFCheck()
            self.SelectedTab = "2"
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+(self.PlayerSuvViewBottom.constant == 25 ? 1:0.0)) {
                self.PlayerView.isHidden = true
                self.PlayerSubView.isHidden = true
                self.Buttonfram()
                self.LibraryBtnView.isHidden = false
                self.Navigateframe.isHidden = false
                
                let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "MyLibraryViewController") as! MyLibraryViewController
                  self.addChild(vc)
                  self.Navigateframe.addSubview(vc.view)
                  self.Navigateframe.layer.masksToBounds = true
            }
        }
    }
    
    
    
    func AboutusCall() {
//        DispatchQueue.main.async {
//            self.MoreCall()
//        }
        
//        let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    @IBAction func MoreAction(_ sender: Any) {
        if self.SelectedTab != "3" {
            self.playerONOFFCheck()
            self.SelectedTab = "3"
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+(self.PlayerSuvViewBottom.constant == 25 ? 1:0.0)) {
                self.PlayerView.isHidden = true
                self.PlayerSubView.isHidden = true
                self.Buttonfram()
                self.MoreBtnView.isHidden = false
                self.Navigateframe.isHidden = false
                
                
                
                let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
                  self.addChild(vc)
                  self.Navigateframe.addSubview(vc.view)
                  self.Navigateframe.layer.masksToBounds = true
                
                
//                let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "SettingsViewController") as! UINavigationController
//                  self.addChild(vc)
//                  self.Navigateframe.addSubview(vc.view)
//                  self.Navigateframe.layer.masksToBounds = true
            }
        }
        
    }
    
    
    
    @IBAction func PaymentAction(_ sender: Any) {
        
        
        if CoreDataModel.sharedInstance.GetEndDate(entity: CDPaymentdateAPI) != "" {
            var date = CoreDataModel.sharedInstance.GetEndDate(entity: CDPaymentdateAPI)
            
            
            if date == "" {
                date = Date().string(format: "dd-MM-yyyy")
            }
            let showDate1 = GetReceptKey.shared.convertData(date: date)
             
            if showDate1.isGreaterThan(Date()) {
                self.SubscriptionVucall()
            } else {
                if NetworkManager.sharedInstance.isConnectedToInternet() {
                    let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "SubscrbViewController") as! SubscrbViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.view.makeToast("No internet connection", duration: 2.0, position: .bottom)
                }
            }
        } else {
            if NetworkManager.sharedInstance.isConnectedToInternet() {
                let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "SubscrbViewController") as! SubscrbViewController
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.view.makeToast("No internet connection", duration: 2.0, position: .bottom)
            }
        }
    }
    

    
    func Buttonfram() {
        self.HomeBtnView.isHidden = true
        self.DailyVerseBtnView.isHidden = true
        self.LibraryBtnView.isHidden = true
        self.MoreBtnView.isHidden = true
    }
    
       

    func NoteNib(VersePosition: Int, BookName: String, Pageindex:Int, BookVerse:String, note:String, SecondaryVerse:String) {
        
        self.myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        self.view.addSubview(self.myView!)
        self.NoteVu = SaveNotes.fromNib(named: "SaveNotes")
        self.NoteVu!.VerseStr = BookVerse
        self.NoteVu!.Note = note
        self.NoteVu!.Bookname = BookName
        self.NoteVu!.SecondaryVerse = SecondaryVerse
        self.NoteVu!.ChapterNo = "\(Pageindex-1):\(VersePosition)"
        self.NoteVu!.frame = self.myView!.bounds
        self.NoteVu!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.myView!.addSubview(self.NoteVu!)
    }

    
    
    func MenuNib(VersePosition: Int, BookName: String, Pageindex:Int, BookVerse:Array<String>, Bookmark:String, ColorCode:String, UnderlineStatus:String, note:String, SecondaryVerse:Array<String>) {
        self.ClosePlayerPopup()
        
        self.MenuFrame = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        self.view.addSubview(self.MenuFrame!)
        self.MenuView = VersesMenu.fromNib(named: "VersesMenu")
        self.MenuView!.VersePosition = VersePosition
        self.MenuView!.BookName = BookName
        self.MenuView!.BookmarkStatus = Bookmark
        self.MenuView!.ColorCode = ColorCode
        self.MenuView!.Pageindex = Pageindex
        self.MenuView!.BookVerse = BookVerse
        self.MenuView!.SecondaryVerse = SecondaryVerse
        self.MenuView!.Notetxt = note
        self.MenuView!.UnderlineStatus = UnderlineStatus
        self.MenuView!.frame = self.MenuFrame!.bounds
        self.MenuView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.MenuFrame!.addSubview(self.MenuView!)
    }
    

    func CallMenu(getString: String, VCSelection: String, TagSelection:String) {
        
        self.myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        self.view.addSubview(self.myView!)
        self.PopupMenuView = PopupMenu.fromNib(named: "PopupMenu")
        self.PopupMenuView!.getString = getString
        self.PopupMenuView!.VCSelection = VCSelection
        self.PopupMenuView!.TagSelection = TagSelection
        self.PopupMenuView!.frame = self.myView!.bounds
        self.PopupMenuView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.myView!.addSubview(self.PopupMenuView!)
    }
    

    
    func WallpaperNib(VersePosition: Int, BookName: String, Pageindex:Int, BookVerse:Array<String>, SecondaryVerse:Array<String>) {
        
        self.CloseMenu()
        self.myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        self.view.addSubview(self.myView!)
        self.WallpaperVU = WallpaperView.fromNib(named: "WallpaperView")
        self.WallpaperVU!.VerseStr = BookVerse[VersePosition-1]
        self.WallpaperVU!.Bookname = BookName
        self.WallpaperVU!.BooknameTxt = UserDefaults.standard.string(forKey: "BookName")
        self.WallpaperVU!.VerseArray = BookVerse
        self.WallpaperVU!.SecondaryVerse = SecondaryVerse
        self.WallpaperVU!.SourceView = self
        self.WallpaperVU!.frame = self.myView!.bounds
        self.WallpaperVU!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.myView!.addSubview(self.WallpaperVU!)
    }
    
    
    
    
    
    func CallInterstitialAd() {
        
        if UserDefaults.standard.string(forKey: "AdTime") == nil {
            let date = Date().addingTimeInterval(5 * 60)
            UserDefaults.standard.setValue(date.string(format: "HH:mm"), forKey: "AdTime")
        } else {
            var adtime = UserDefaults.standard.string(forKey: "AdTime")
            let f = DateFormatter()
            f.dateFormat = "HH:mm"
        
            if  f.date(from: Date().string(format: "HH:mm"))! >=  f.date(from: adtime!)! {
                UserDefaults.standard.setValue("", forKey: "AdTime")
                
            }
        }


    }
    
    
    
    
    func CloseView() {
        if self.myView! != nil {
            self.myView!.removeFromSuperview()
        }
    }
    
    func CloseChapterView() {
        
        if self.VerseView! != nil {
            self.VerseView!.removeFromSuperview()
        }
    }
    
    
    func CloseMenu() {
        if self.MenuFrame! != nil {
            self.MenuFrame!.removeFromSuperview()
        }
    }
    
    
    
    func ReloadCoredata() -> Array<String> {
        let book_name  = UserDefaults.standard.string(forKey: "BookName")!
        
            self.BookTxt.text = book_name
        
            self.BibleSavedVerses.removeAll()
            self.BookFilter.removeAll()
            self.BibleSavedVerses = CoreDataModel.sharedInstance.AudioBibleVerse(entity: CDBookSavedInfo, bookname: book_name)
        
        
            for items in self.BibleSavedVerses {
                let srt = CoreDataModel.sharedInstance.seperateByArrayBook(SeperateValue: items)
                self.BookFilter.append(srt)
            }
        
        return self.BookFilter
    }
    
    
    
    
    func AlertFrame(AlertNote:String,Vers:String,Title:String) {

        let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "Ad_ToastController") as! Ad_ToastController
        vc.AlertTxt = AlertNote
        vc.VText = Vers
        vc.VTitle = Title
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    func OpenPreview(SavedImage:UIImage, FrameHeight:CGFloat) {
//        self.view.makeToast("Image Saved Succesfully!", duration: 2.0, position: .bottom)
        
//        let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "ImageSavedVC") as! ImageSavedVC
//        vc.SavedImage = SavedImage
//        vc.FrameHeight = FrameHeight
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true, completion: nil)
    }
    
    
    
    func shared(VerseStr:String,Bookname:String) {
        
        let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "SharedViewController") as! SharedViewController
        vc.VerseStr = VerseStr
        vc.Bookname = Bookname
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
        
    }
        
    
    
    func shared(Link:String) {
        let text = "Hey, check out this incredible Reading Bible app, it offers an easy-to-use image editing feature to enhance your Bible study experience. : \(Link)"
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare as [Any] , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.popoverPresentationController?.sourceRect = self.view.bounds
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    func ConstrainChange(Top: CGFloat, bottom: CGFloat) {
            self.VeresViewBottom.constant = (Top < 0.0 ? 0.0:-72.0)
        
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
                self!.topBannerConstant.constant = Top
                self!.BottomMenyConstrain.constant = bottom
                self!.view.layoutIfNeeded()
         }, completion: { finished in
            })
    }
     
    
    
    func sharedImage(shared:UIImage) {
        
        let activityViewController = UIActivityViewController(activityItems: [shared], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        activityViewController.popoverPresentationController?.sourceRect = self.view.bounds
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    func sharedImage(sharedUrl:URL, VerseStr:String,Bookname:String) {
        
        
        let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "SharedViewController") as! SharedViewController
        vc.VerseImgData = self.loadImage(fileURL: sharedUrl)
        vc.VerseStr = VerseStr
        vc.Bookname = Bookname
        vc.VerseImgName = Bookname
        vc.ShareVerseImageURL = [sharedUrl]
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
        
        
//        let activityViewController = UIActivityViewController(activityItems: [sharedUrl], applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
//        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
//
//        activityViewController.popoverPresentationController?.sourceRect = self.view.bounds
//        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
//
//        self.present(activityViewController, animated: true, completion: nil)
//        activityViewController.completionWithItemsHandler = { activity, success, items, error in
//            self.dismiss(animated: true, completion: nil)
//            FileManager.default.clearTmpDirectory()
//        }
    }
    
    
    
    private func loadImage(fileURL: URL) -> Data? {
        do {
            let imageData = try Data(contentsOf: fileURL)
            return imageData
        } catch {
        }
        return nil
    }
    
    
    
    func MarkAsReadPopup() {
        let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "QuizAlertVC") as! QuizAlertVC
        vc.bookname = UserDefaults.standard.string(forKey: "BookName")!
        vc.Chapter = UserDefaults.standard.string(forKey: "BookChapter")!
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    
    
    
        
    func SliderCardPreview(Vereseimage:UIImage) {
        
        SaveImage.sharedInstance.Save(Mainview:self, saveImage: Vereseimage)
        
//        let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "ImagePreviewVc") as! ImagePreviewVc
//        vc.ImgVerse = Verese
//        vc.ImgVerseTitle = Book
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
    }
    
    
    
//    @objc func SliderCardPreview (notification: NSNotification) {
//        let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "ImagePreviewVc") as! ImagePreviewVc
//
//        vc.Img = (notification.userInfo!["verseimage"] as! String)
//        vc.ImgVerse = (notification.userInfo!["Verses"] as! String)
//        vc.ImgVerseTitle = (notification.userInfo!["VersesTitle"] as! String)
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
//    }
    
    
    
    
    func SubscriptionVucall() {
        self.myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        self.view.addSubview(self.myView!)
        self.SubscriptionVu = SubscriptionPopup.fromNib(named: "SubscriptionPopup")
        self.SubscriptionVu!.frame = self.myView!.bounds
        self.SubscriptionVu!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.myView!.addSubview(self.SubscriptionVu!)
        self.myView!.bringSubviewToFront(self.SubscriptionVu!)
    }
    
    
            
    
//    func moreAppScreen() {
//        
//        var MoreAppDate = UserDefaults.standard.string(forKey: "MoreAppDate") ?? ""
//                
//        if MoreAppDate == "" {
//            UserDefaults.standard.setValue(Date.tomorrow.string(format: "dd-MM-yyyy"), forKey: "MoreAppDate")
//            UserDefaults.standard.setValue(Date.DayThree.string(format: "dd-MM-yyyy"), forKey: "RateUS")
//        } else {
//            let showDate1 = GetReceptKey.shared.convertData(date: MoreAppDate)
//            let diff = showDate1.interval(ofComponent: .day, fromDate: Date())
//
//            if diff < 0 {
//
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.1) {
//                    let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "AdSplashViewController") as! AdSplashViewController
//                    vc.modalPresentationStyle = .overCurrentContext
//                    vc.modalTransitionStyle = .crossDissolve
//                    self.present(vc, animated: true, completion: nil)
//                }
//                
//            }
//        }
//    }
    
    
    
    
    
    
    @IBAction func NightModeAction(_ sender: Any) {
        self.NightMode()
    }
    
    
    
    
    // MARK: Night Mode
    @objc func NightMode() {
            var SourceColor:UIColor?
            if UserDefaults.standard.color(forKey: "SourceThemecolor") == nil {
                UserDefaults.standard.set(PrimaryColor, forKey: "SourceThemecolor")
            }
            SourceColor = UserDefaults.standard.color(forKey: "SourceThemecolor")!

            if (self.Themecolor!.toHexString() != UIColor.black.toHexString() &&  self.Themecolor!.toHexString() != BGNightMode.toHexString()) || self.Themecolor!.toHexString() == "#000000" {
                UserDefaults.standard.set(BGNightMode, forKey: "AppThemeColor")
                self.NightModeBtn.setImage(UIImage(named: "night-mode-on"), for: .normal)
            } else {
                self.NightModeBtn.setImage(UIImage(named: "night-mode-off"), for: .normal)
                UserDefaults.standard.set(SourceColor, forKey: "AppThemeColor")
            }

        self.PageConfig()
//           App_Protocol.delegateReaderSource?.ReloadBibleData(ChapterNo:UserDefaults.standard.integer(forKey: "BookChapter"))
        
          DispatchQueue.main.async {
              self.mainContainer()
           }
     }

    
    
    func CallIndustrialAd() {
        
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
//                let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "InterstitialViewController") as! InterstitialViewController
//                vc.LoadAdCatagory = "INTERSTITIAL"
//                vc.modalPresentationStyle = .overCurrentContext
//                vc.modalTransitionStyle = .crossDissolve
//                self.present(vc, animated: true, completion: nil)
//        }

    }
    
    
    

}

extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
}
 


extension UIImage {

    func imageWithSize(scaledToSize newSize: CGSize) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

}
