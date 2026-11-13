//
//  SlideCardVC.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 29/03/23.
//

import UIKit
import AVFoundation
import UnityAds

class SlideCardVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SlideCard {

    
    
    @IBOutlet weak var BannerVu: UIView!
    @IBOutlet weak var MenuBar: UIView!
    @IBOutlet weak var BannerConstrain: NSLayoutConstraint!
    @IBOutlet weak var ChapterTxt:UILabel!
    @IBOutlet weak var BookTxt:UILabel!
    @IBOutlet weak var NightModeBtn:UIButton!
    @IBOutlet weak var RefreshBtn:UIButton!
    @IBOutlet weak var AdInfo:UIButton!

    
    
    @IBOutlet var CardCollectionCell: UICollectionView!
    
//    @IBOutlet weak var BlurVu:UIView!
//    @IBOutlet weak var MenuBottom: NSLayoutConstraint!
//    @IBOutlet weak var PreviousVu: UIView!
//    @IBOutlet weak var NextVu: UIView!
//    @IBOutlet weak var BookmarkVu: UIImageView!
    
//    @IBOutlet weak var MenuConstrains: NSLayoutConstraint!
    
    lazy var SecondBibleList:Array<String> = []
    
    
    weak var SubscriptionVu: SubscriptionPopup?
    weak var NoteVu: SaveNotes?

    var BookFilter:Array<String> = []
    var myView:UIView?
    var BookArrayTitle:String = ""
    var Bookname:String?
    var SelectedPath:Int = 0
    var CellSpace:Float?
    var isfirstTimeTransform:Bool = true
    var HighlightStatus:Bool = false
    var BookName:String = ""
    var bookCount:Int = 0
    var ChaterNumber:String = ""
    var SecondBook:String = ""
    var BGImage:[Int] = []
    var BGImageCount:Int = 0
    var BibleSavedVerses:Array<String> = []
    var DisableConerRadius:Bool = false
    var saveImage:UIImage?
    
    var SwipeOn:Bool = false
    
    
    lazy var BibleTxt:String = ""
    var ColorString:CGFloat  = 0.0
    
    
    var ImageTab:Int = 0
    var BGColor:[String] = ["#bddffa", "#fffac3", "#fabbd0", "#c3e0c4", "#fed6b2", "#fe9798", "#e7b9f8"]
    var Banners:UADSBannerView!
    
    var SecondaryBook:[String] = []
    var PrimaryBook:[String] = []
    
    
    weak var HighlighterVu: HighlighterView?
    weak var CardCell: SlideCardCell?
    var VerseArray:Array<String> = []
    
    var ChapterVc: ChapterView?
    var VerseView:UIView?
    var VerseListVc: VerseListView?
    
    var Themecolor = UserDefaults.standard.color(forKey: "AppThemeColor")!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        App_Protocol.DelegateSlideCard = self
        self.Config()
        self.BannerConstrain.constant = FrameConstrains //(StatusbarHeight > 30 ? 90:70)
        // Do any additional setup after loading the view.
        
        if  self.Themecolor.toHexString() == BGNightMode.toHexString() {
            self.NightModeBtn.setImage(UIImage(named: "night-mode-on"), for: .normal)
        } else {
            self.NightModeBtn.setImage(UIImage(named: "night-mode-off"), for: .normal)
        }
        
        if IS_SUBSCRIPTION_ENABLE == 0 {
            self.AdInfo.isHidden = true
        }
         
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.paymentStatus()
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
    
    
    
    
    
    
    func NotesSavedStatus(Status: Bool) {
        self.view.makeToast("Notes \(Status ? "Deleted":"Saved") Successfully!", duration: 2.0, position: .bottom)
    }

    
    
    func ChapterVers(Book:String) {

        Bookname = Book
        self.Config()
        
        let BookArray = Bookname!.components(separatedBy: [":", "-"])
        var indexPath = IndexPath(row: Int(BookArray[BookArray.count-1])!, section: 0)
     
        DispatchQueue.main.async {
            self.CardCollectionCell.isPagingEnabled = false
            self.CardCollectionCell.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            self.CardCollectionCell.isPagingEnabled = true
          }
        
        
        self.SelectedPath = Int(BookArray[BookArray.count-1])!
    }

    
    
    func colorconFig() {
        Themecolor = UserDefaults.standard.color(forKey: "AppThemeColor")!
        
        BannerVu.backgroundColor = (self.Themecolor == BGNightMode ? DarkModeColor:Themecolor)
        self.MenuBar.backgroundColor = Themecolor
        
        self.view.setNeedsDisplay()
    }
    
    func Config(pathRow:Int = 0) {
        
        
        DispatchQueue.main.async {
            self.colorconFig()
            self.CardCollectionCell.isPagingEnabled = false
            self.CardCollectionCell.scrollToItem(at: IndexPath(item: pathRow, section: 0), at: .centeredHorizontally, animated: false)
            self.CardCollectionCell.isPagingEnabled = true
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChangeHighlightStatus), name: Notification.Name("CloseHighLite"), object: nil)
        
//        self.reloadView()
        self.CellSpace = Float(self.view.frame.width)-Float((self.view.bounds.width/10)*7)
        
        
        let BookArray = Bookname!.components(separatedBy: [":", "-"])
        self.ChapterTxt.text = "Ch-\(BookArray[1])"
        self.BookTxt.text = BookArray[0]
        
        
        self.VerseArray = BibleContent.sharedInstance.AudioBibleList(selecterBookName: BookArray[0], selectedId: Int(BookArray[BookArray.count-2])!-1)
        BookArrayTitle =  String(format: "%@ %@", BookArray[0],BookArray[1])
        
                
        
        if UserDefaults.standard.string(forKey: "SecondLanguage") ?? "" != ""  {
            let bookPosition = BibleContent.sharedInstance.BookToPosition(stringBook: BookArray[0])
            self.SecondBook = "\(SecondLanguage.shared.BookToPosition(bookPosition: bookPosition).components(separatedBy: "-")[0]) \(BookArray[1])"
            self.SecondBibleList = SecondLanguage.shared.AudioBibleList(selectedId: Int(BookArray[1])!-1, bookPosition: bookPosition)
        }
        


        
        
        ChaterNumber = BookArray[1]
        
        
        self.BookTxt.text = BookArray[0]
        self.BookName = BookArray[0]
        self.ReloadCoredata()
        self.CardCollectionCell.delegate = self
        self.CardCollectionCell.dataSource = self
        self.CardCollectionCell.register(UINib(nibName: "SlideCardCell", bundle: nil), forCellWithReuseIdentifier: "SlideCardCell")
        
        
        
        self.view.setNeedsLayout()
        self.bookCount = BibleContent.sharedInstance.AudioBibleListCount(selecterBookName: BookArray[0])
        
        
        self.SelectedPath = 0
        BGImage.removeAll()
        
        for _ in 0 ..< self.VerseArray.count {
            if BGImageCount >= 10 {
                BGImageCount = 0
            }
            BGImageCount = BGImageCount+1
            BGImage.append(BGImageCount)
        }
        

        self.CardCollectionCell.reloadData()
    }
    
    
    @objc func ChangeHighlightStatus() {
        if HighlightStatus == false {
            HighlightStatus = true
            self.SliderNib()
        } else {
            self.DismissVu()
            HighlightStatus = false
        }
    }
    
    
    
    func DismissVu() {
        self.myView?.removeFromSuperview()
    }
    
   
    
    
    func ReloadCoredata() {
        self.BibleSavedVerses.removeAll()
        self.BookFilter.removeAll()
        self.BibleSavedVerses = CoreDataModel.sharedInstance.AudioBibleVerse(entity: CDBookSavedInfo, bookname: self.BookName)
        
        for items in self.BibleSavedVerses {
            let srt = CoreDataModel.sharedInstance.seperateByArrayBook(SeperateValue: items)
            
            self.BookFilter.append(srt)
        }
        
    }
    
    
    func SliderNib() {
        
        self.SelectedPath =  (self.SelectedPath >= self.VerseArray.count ?  self.SelectedPath-1:self.SelectedPath)

        let B_Title = "\(BookName)-\(ChaterNumber):\(self.SelectedPath+1)"
        
        let BookVerse = Bookname?.components(separatedBy: ":")[0]
        
        let indexPath = NSIndexPath(row: self.SelectedPath, section: 0)
        let cell = self.CardCollectionCell.cellForItem(at: indexPath as IndexPath)  as? SlideCardCell

        self.myView = UIView(frame: CGRect(x: 25, y: screenSize.height-(120+StatusbarHeight), width: screenSize.width-50, height: 60))
        self.view.addSubview(self.myView!)
        self.HighlighterVu = HighlighterView.fromNib(named: "HighlighterView")
        self.HighlighterVu!.frame = self.myView!.bounds
        self.HighlighterVu!.verse = self.VerseArray[self.SelectedPath]
        self.HighlighterVu!.book = B_Title  // "\(BookVerse!):\(self.SelectedPath!+1)" //"\(self.BookArrayTitle):\(self.SelectedPath!+1)"
        if cell!.SliderShadowVu.layer.borderWidth > 1 {
            self.HighlighterVu!.verseColor = UIColor(cgColor: cell!.SliderShadowVu.layer.borderColor!)
        } else  {
            self.HighlighterVu!.verseColor = UIColor.clear
        }
        self.HighlighterVu!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.myView!.addSubview(self.HighlighterVu!)
    }
    
    
    
    @objc func clickIMage() {
        self.SwipeOn = true
        self.CardCollectionCell.isScrollEnabled = false
        let indexPaths = NSIndexPath(row: self.SelectedPath, section: 0)
        self.CardCell = self.CardCollectionCell.cellForItem(at: indexPaths as IndexPath)  as? SlideCardCell
        
        if BGImageCount >= 10 {
            BGImageCount = 0
        }
        
        BGImageCount = BGImageCount+1
        self.CardCell!.SliderImage.image = UIImage(named: "S\(BGImageCount).jpg")
        
        self.CardCollectionCell.isScrollEnabled = true
    }
    
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    @IBAction func Dismiss_Action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        App_Protocol.delegateReaderSource?.ReloadBibleData(ChapterNo:UserDefaults.standard.integer(forKey: "BookChapter"))
    }
    
    
    @IBAction func NightMode_Action(_ sender: Any) {
        App_Protocol.delegateReader?.NightMode()
        
        let SourceColor:UIColor = UserDefaults.standard.color(forKey: "SourceThemecolor")!
        
        if (self.Themecolor.toHexString() != UIColor.black.toHexString() &&  self.Themecolor.toHexString() != BGNightMode.toHexString()) || self.Themecolor.toHexString() == "#000000" {
            UserDefaults.standard.set(BGNightMode, forKey: "AppThemeColor")
            self.NightModeBtn.setImage(UIImage(named: "night-mode-on"), for: .normal)
        } else {
            self.NightModeBtn.setImage(UIImage(named: "night-mode-off"), for: .normal)
            UserDefaults.standard.set(SourceColor, forKey: "AppThemeColor")
        }
        
        
        DispatchQueue.main.async {
            self.colorconFig()
        }
    }
    
    
    
    
    
    @IBAction func Book_Action(_ sender: Any) {
        let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "BookListViewController") as! BookListViewController
        vc.ChapterNo = UserDefaults.standard.string(forKey: "BookChapter")
        vc.HideProgressBar = true
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
        

    
    
    @IBAction func BookMarkAction(_ sender: Any) {
//        self.RefreshBtn.isEnabled = true
           self.CloseHighlite()
           
           self.SelectedPath =  (self.SelectedPath >= self.VerseArray.count ?  self.SelectedPath-1:self.SelectedPath)
           
          if UserDefaults.standard.string(forKey: "SecondLanguage") ?? "" != ""  && APP_TYPE != "1" {
              BibleTxt = "\n\n\(self.SecondBibleList.count > self.SelectedPath ? self.SecondBibleList[self.SelectedPath]:"")"
           }
    
           var B_Title = "\(BookName)-\(ChaterNumber):\(self.SelectedPath+1)"
           let indexPaths = NSIndexPath(row: self.SelectedPath, section: 0)
           
           let multilineCell = self.CardCollectionCell.cellForItem(at: indexPaths as IndexPath)  as? SlideCardCell
           
           if multilineCell!.SliderBookMarkIcon.isHidden == false {
               CoreDataModel.sharedInstance.coreDataInsertBookmarked(CDBookSavedInfo, bookVerse:B_Title , Bookmark: "", Verses: self.VerseArray[self.SelectedPath])
               self.view.makeToast("Bookmark removed.", duration: 2.0, position: .bottom)
               
           }
        else {
               CoreDataModel.sharedInstance.coreDataInsertBookmarked(CDBookSavedInfo, bookVerse:B_Title , Bookmark: "bookMarked", Verses: self.VerseArray[self.SelectedPath])
               self.view.makeToast("Bookmarked successfully", duration: 2.0, position: .bottom)
               RateUsCall.shared.ClickCount()
           }
           
           self.reloadCoreCollectionData(Index: self.SelectedPath)
       }
       
    
    
    func reloadCoreCollectionData(Index:Int) {
        self.ReloadCoredata()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            let indexPath = NSIndexPath(row: Index, section: 0)
            self.CardCollectionCell.reloadItems(at: [indexPath as IndexPath])
            let cell = self.CardCollectionCell.cellForItem(at: indexPath as IndexPath)  as? SlideCardCell
            cell?.transform = CGAffineTransform.identity
        }
    }
       



    func CloseHighlite() {
        if  self.SelectedPath >= self.VerseArray.count {
            self.SelectedPath = self.SelectedPath-1
        }
        
        if HighlightStatus == true {
            self.DismissVu()
            HighlightStatus = false
        }
    }

    
    func CloseVc() {
        if self.myView! != nil {
            self.myView!.removeFromSuperview()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.reloadCoreCollectionData(Index: self.SelectedPath)
//                self.RefreshBtn.isEnabled = true
            }
        }
    }
    
    

    @IBAction func Refresh_Action(_ sender: Any) {
        self.CloseHighlite()
        CoreDataModel.sharedInstance.coreDataRemoveAllData(CDBookSavedInfo, bookVerse: "\(BookName)-\(ChaterNumber):\(self.SelectedPath+1)")
//        App_Protocol.delegateReaderSource?.ReloadBibleData(ChapterNo:UserDefaults.standard.integer(forKey: "BookChapter"))
        
//        RefreshBtn.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.4) {
            self.reloadCoreCollectionData(Index: self.SelectedPath)
        }
        self.view.makeToast("Reset successfully", duration: 2.0, position: .bottom)
        
        
    }
    
    
        
    @IBAction func Note_Action(_ sender: Any) {
        
        self.CloseHighlite()
        let bookVerse = String(format: "\(BookName)-\(self.ChaterNumber):%d", self.SelectedPath+1)
        
        
        if UserDefaults.standard.string(forKey: "SecondLanguage") ?? "" != ""  && APP_TYPE != "1" {
            BibleTxt = "\n\n\(self.SecondBibleList.count > self.SelectedPath ? self.SecondBibleList[self.SelectedPath]:"")"
        }
        
        self.myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        self.view.addSubview(self.myView!)
        self.NoteVu = SaveNotes.fromNib(named: "SaveNotes")
        self.NoteVu!.VerseStr = "\(self.VerseArray[self.SelectedPath])\(BibleTxt)"
        
            if BookFilter.count > 0 && BookFilter.contains(bookVerse) {
                let indexOfVerse = self.BookFilter.firstIndex(of: bookVerse)
                
                let SplitCellData = CoreDataModel.sharedInstance.seperateByArray(SeperateValue: self.BibleSavedVerses[indexOfVerse!])
                
                self.NoteVu!.Note = SplitCellData[1]
            } else {
                self.NoteVu!.Note = ""
            }
        
             self.NoteVu!.isSlideCard = true
             self.NoteVu!.Bookname = BookName
             self.NoteVu!.ChapterNo = "\(ChaterNumber):\(self.SelectedPath+1)"
             self.NoteVu!.frame = self.myView!.bounds
             self.NoteVu!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
             self.myView!.addSubview(self.NoteVu!)
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
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    vc.presentVu = true
                    self.present(vc, animated: true, completion: nil)
                } else {
                    self.view.makeToast("No internet connection", duration: 2.0, position: .bottom)
                }
            }
        } else {
            if NetworkManager.sharedInstance.isConnectedToInternet() {
                let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "SubscrbViewController") as! SubscrbViewController
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                vc.presentVu = true
                self.present(vc, animated: true, completion: nil)
            } else {
                self.view.makeToast("No internet connection", duration: 2.0, position: .bottom)
            }
        }
    }
    
    
    
    
    func SubscriptionVucall() {
        self.myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        self.view.addSubview(self.myView!)
        self.SubscriptionVu = SubscriptionPopup.fromNib(named: "SubscriptionPopup")
        self.SubscriptionVu!.frame = self.myView!.bounds
        self.SubscriptionVu!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.SubscriptionVu!.Cardframe = true
        self.myView!.addSubview(self.SubscriptionVu!)
        self.myView!.bringSubviewToFront(self.SubscriptionVu!)
    }
    
    func CloseView() {
        self.myView?.removeFromSuperview()
    }
    
       @IBAction func SaveAction(_ sender: Any) {
           
           self.CloseHighlite()
  
           
         let indexPaths = NSIndexPath(row: self.SelectedPath, section: 0)
           
           DispatchQueue.main.async {
               
               self.DisableConerRadius = true
               let cell = self.CardCollectionCell.cellForItem(at: indexPaths as IndexPath)  as? SlideCardCell
               
               self.ColorString = cell!.SliderShadowVu.layer.borderWidth
               
               cell!.SliderShadowVu.layer.borderWidth = 0

               
               self.saveImage = cell!.SliderShadowVu.asImage()
               let BorerColors = UIColor(cgColor: cell!.SliderShadowVu.layer.borderColor!)
               DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
//                   if  BorerColors.toHexString() != "#000000" {
//                       self.CardCell!.SliderShadowVu.layer.borderWidth = 5
//                   }
                   if self.ColorString != 0 {
                       cell!.SliderShadowVu.layer.borderWidth = self.ColorString
                       self.ColorString = 0
                   }
                   
               }
               
               self.DisableConerRadius = false
               
               
               DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
                   SaveImage.sharedInstance.Save(Mainview:self, saveImage: self.saveImage!)
           
                   let imageRectsize = AVMakeRect(aspectRatio: self.saveImage!.size, insideRect: UIScreen.main.bounds)
                   App_Protocol.delegateReader?.OpenPreview(SavedImage: self.saveImage!, FrameHeight: imageRectsize.height)

               }
           }
       }



    @IBAction func CopyAction(_ sender: Any) {
       self.CloseHighlite()
       self.SelectedPath =  (self.SelectedPath >= self.VerseArray.count ?  self.SelectedPath-1:self.SelectedPath)
       
        
        if UserDefaults.standard.string(forKey: "SecondLanguage") ?? "" != ""  && APP_TYPE != "1" {
            BibleTxt = "\n\n\(self.SecondBibleList.count > self.SelectedPath ? self.SecondBibleList[self.SelectedPath]:"")"
        }
        
        
       let copyverse =  "\(self.BookArrayTitle):\(self.SelectedPath+1)\n\n\(self.VerseArray[self.SelectedPath])\n\n\(self.SecondBook):\(self.SelectedPath+1)\(BibleTxt)"
       
       UIPasteboard.general.string = copyverse
        self.view.makeToast("Copied successfully", duration: 2.0, position: .bottom)
        
   }
       


       @IBAction func HighlightAction(_ sender: Any) {
//           RefreshBtn.isEnabled = true
           
           self.ChangeHighlightStatus()
       }



    @objc func ShareBtn_Action(sender: UIButton!) {
        self.CloseHighlite()
        let indexPaths = NSIndexPath(row: self.SelectedPath, section: 0)
        
         
        let multilineCell = self.CardCollectionCell.cellForItem(at: indexPaths as IndexPath)  as? SlideCardCell
        self.ColorString = multilineCell!.SliderShadowVu.layer.borderWidth
        
        multilineCell!.SliderShadowVu.layer.borderWidth = 0
        
        let BorerColors = UIColor(cgColor: multilineCell!.SliderShadowVu.layer.borderColor!)
        self.saveImage = multilineCell!.SliderShadowVu.asImage()
        
//        if  BorerColors.toHexString() != "#000000" {
//            multilineCell!.SliderShadowVu.layer.borderWidth = 5
//        }
        
        if self.ColorString != 0 {
            multilineCell!.SliderShadowVu.layer.borderWidth = self.ColorString
            self.ColorString = 0
        }
    
        
        
        let BookName = "\(self.BookArrayTitle.replacingOccurrences(of: "-", with: " ")):\(self.SelectedPath+1)"
         
        
        let url = URL(fileURLWithPath: NSTemporaryDirectory())
        let fileURL = url.appendingPathComponent("\(BookName).png")
        try! self.saveImage?.pngData()?.write(to: fileURL)
                    
        self.sharedImage(sharedUrl:fileURL,VerseStr:multilineCell!.Verse.text!, Bookname:BookName)
        
//        self.sharedImage(sharedUrl:fileURL)
        
    }



    

}






extension SlideCardVC {
    // MARK:- COllection view Delegate
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
              return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
          }

          func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
              if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
                  return CGSize(width: self.view.bounds.width-10, height: Imagesize)
              } else {
                  return CGSize(width: self.view.bounds.width-10, height: Imagesize-10)
              }
              
          }
        
            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return self.VerseArray.count
            }
            
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        self.CardCell = (self.CardCollectionCell.dequeueReusableCell(withReuseIdentifier: "SlideCardCell", for: indexPath) as! SlideCardCell)
        
        
        self.CardCell?.ShareBtn.addTarget(self, action: #selector(ShareBtn_Action), for: .touchUpInside)
        
        self.CardCell!.Verse.font = UIFont.systemFont(ofSize: (isIpad ? 30:22), weight: .bold)
//        self.CardCell!.Book.font = UIFont.systemFont(ofSize: (isIpad ? 22:14))
        self.CardCell!.BookMarkHeight.constant = (isIpad ? 28:20)
        self.CardCell!.NotesHeight.constant = (isIpad ? 28:20)
        
        
//        self.CardCell!.SliderImage.image = UIImage(named: "S\(BGImage[indexPath.row]).jpg")
        
        
        if !SwipeOn {
            self.CardCell!.SliderImage.image = UIImage(named: "S\(BGImage[indexPath.row]).jpg")
        }
        
        
        if ImageTab <= 10 && SwipeOn {
            self.CardCell!.SliderImage.image = UIImage(named: "S\(BGImageCount).jpg")
        }
        
        
        
        
        if UserDefaults.standard.string(forKey: "SecondLanguage") ?? "" != ""  && APP_TYPE != "1" {
            BibleTxt = "\n\n\(self.SecondBibleList.count > indexPath.row ? self.SecondBibleList[indexPath.row]:"")"
        }
         
        
        if PaymentHistory.sharedInstance.paymentInfoVerify() {
            self.CardCell!.WaterMark.isHidden = false
        } else {
            self.CardCell!.WaterMark.isHidden = true
        }
        
        
        self.CardCell!.Verse.text = "\(self.BookArrayTitle):\(indexPath.row+1)\n\n\(self.VerseArray[indexPath.row])\n\n\(self.SecondBook):\(indexPath.row+1)\(BibleTxt)"
        self.CardCell!.Verse.textAlignment = .justified
        
        
        var B_Title = "\(BookName)-\(ChaterNumber):\(indexPath.row+1)"
        self.CardCell!.WaterMarkLbl.text = APPNAME_SPLASH
        
        
        
        DispatchQueue.main.async {
            if self.BookFilter.contains(B_Title) {
                let indexOfVerse = self.BookFilter.firstIndex(of: B_Title)
                
                let SplitCellData = CoreDataModel.sharedInstance.seperateByArray(SeperateValue: self.BibleSavedVerses[indexOfVerse!])
                
                if SplitCellData[1] != "" {
                    self.CardCell!.SliderNoteIcon.isHidden = false
                } else {
                    self.CardCell!.SliderNoteIcon.isHidden = true
                }
                
                
                if SplitCellData[SplitCellData.count-2] == "bookMarked" {
                    self.CardCell!.SliderBookMarkIcon.isHidden = false
                } else {
                    self.CardCell!.SliderBookMarkIcon.isHidden = true
                }
                 
                
                if SplitCellData[0] != "#000000" {
                    self.CardCell!.SliderShadowVu.layer.borderWidth = (self.DisableConerRadius ? 0:5)
                    self.CardCell!.SliderShadowVu.layer.borderColor = self.hexStringToUIColor(hex: SplitCellData[0]).cgColor
                } else {
                    self.CardCell!.SliderShadowVu.layer.borderWidth = 0
                }

            } else {
                self.CardCell!.SliderBookMarkIcon.isHidden = true
                self.CardCell!.SliderNoteIcon.isHidden = true
                self.CardCell!.SliderShadowVu.layer.borderWidth = 0
            }
        }
        
        self.CardCell!.changeImage.addTarget(self, action: #selector(clickIMage), for: .touchUpInside)
        
        self.CardCell!.SliderImageView.layer.masksToBounds = true
//                self.CardCell!.SliderImageView.layer.cornerRadius = (DisableConerRadius ? 0:10)
//                self.SelectedPath = indexPath.row
        return self.CardCell!
        
    }
        
    
            

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.SelectedPath == indexPath.row {
            
            let Cell = self.CardCollectionCell.cellForItem(at: indexPath)  as? SlideCardCell
            ImageTab = ImageTab < 10 ? ImageTab+1:10
            
            self.clickIMage()
        }
    }
    
    
    
    
    
    
    
    
    func sharedImage(sharedUrl:URL, VerseStr:String,Bookname:String) {
        
        
        if UserDefaults.standard.string(forKey: "SecondLanguage") ?? "" != ""  && APP_TYPE != "1" {
            BibleTxt = "\n\n\(self.SecondBibleList.count > self.SelectedPath ? self.SecondBibleList[self.SelectedPath]:"")"
        }
                
        
        let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "SharedViewController") as! SharedViewController
        vc.VerseImgData = self.loadImage(fileURL: sharedUrl)
        vc.VerseStr = "\(self.BookArrayTitle):\(self.SelectedPath+1)\n\n\(self.VerseArray[self.SelectedPath])\n\n\(self.SecondBook):\(self.SelectedPath+1)\(BibleTxt)"
        vc.Bookname = ""
        vc.VerseImgName = Bookname
        vc.ShareVerseImageURL = [sharedUrl]
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
        
        
    }
    
    
    
    
    private func loadImage(fileURL: URL) -> Data? {
        do {
            let imageData = try Data(contentsOf: fileURL)
            return imageData
        } catch {
        }
        return nil
    }
    
    
    
    
    
         
        @IBAction func VerseSelectionAction(_ sender: Any) {
            
            if self.myView?.superview == nil {
                self.myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
                self.view.addSubview(self.myView!)
                self.ChapterVc = ChapterView.fromNib(named: "ChapterView")
                self.ChapterVc!.SelectedBook = (UserDefaults.standard.string(forKey: "BookChapter")!)
                self.ChapterVc!.frame = self.myView!.bounds
                self.ChapterVc!.BookName.text = UserDefaults.standard.string(forKey: "BookName")
                self.ChapterVc!.ScreenName = "Slide"
                self.ChapterVc!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.myView!.addSubview(self.ChapterVc!)
            }
            
        
//            if self.VerseView?.superview == nil {
//                self.VerseView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
//                self.view.addSubview(self.VerseView!)
//                self.VerseListVc = VerseListView.fromNib(named: "VerseListView")
//                self.VerseListVc!.SelectedBook = (UserDefaults.standard.string(forKey: "BookChapter")!)
//                self.VerseListVc!.SelectedBookName = UserDefaults.standard.string(forKey: "BookName")!
//                self.VerseListVc!.frame = self.VerseView!.bounds
//                self.VerseListVc!.BookName.text = "\(UserDefaults.standard.string(forKey: "BookName")!) Ch-\(ChaterNumber)"
//                self.VerseListVc!.chapter = Int(ChaterNumber)!
//                self.VerseListVc!.ScreenName = "Slider"
//                self.VerseListVc!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//                self.VerseView!.addSubview(self.VerseListVc!)
//            }
       }
    
    

    
    
    func VerseSelectionAction(Chapter: Int) {
        
        if self.VerseView?.superview == nil {
            self.VerseView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
            self.view.addSubview(self.VerseView!)
            self.VerseListVc = VerseListView.fromNib(named: "VerseListView")
            self.VerseListVc!.SelectedBook = (UserDefaults.standard.string(forKey: "BookChapter")!)
            self.VerseListVc!.SelectedBookName = UserDefaults.standard.string(forKey: "BookName")!
            self.VerseListVc!.frame = self.VerseView!.bounds
            self.VerseListVc!.BookName.text = "\(UserDefaults.standard.string(forKey: "BookName")!) Ch-\(Chapter)"
            self.VerseListVc!.chapter = Chapter
            self.VerseListVc!.ScreenName = "Slide"
            self.VerseListVc!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.VerseView!.addSubview(self.VerseListVc!)
        }
    }
    
    
    
    
    func CloseChapterView() {
        
        if self.myView! != nil {
            self.myView!.removeFromSuperview()
        }
    }
    
    func CloseVerseView() {
        
        if self.VerseView! != nil {
            self.VerseView!.removeFromSuperview()
        }
    }
    
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        self.CloseHighlite()
        
        let pageWidth: Float = Float(self.view.bounds.width) // width + space

        let currentOffset = CGFloat(scrollView.contentOffset.x)
        let targetOffset = targetContentOffset.pointee.x
        var newTargetOffset: Float = 0
         
        if targetOffset > currentOffset-(ScreenWidth/3) {
            newTargetOffset = ceilf(Float(currentOffset) / pageWidth) * pageWidth
        } else {
            newTargetOffset = floorf(Float(currentOffset) / pageWidth) * pageWidth
        }
        
        if newTargetOffset < 0 {
            newTargetOffset = 0
        } else if CGFloat(newTargetOffset) > scrollView.contentSize.width {
            newTargetOffset = Float(scrollView.contentSize.width)
        }

        targetContentOffset.pointee.x = currentOffset
        scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: 0), animated: true)
                  
        self.SelectedPath = Int((newTargetOffset / pageWidth)+0.01)
        self.SwipeOn = false
        self.ImageTab = 0
        
        
       }
    
    
}


extension SlideCardVC {
    @objc func reloadNotedata() {
        self.reloadCoreCollectionData(Index: self.SelectedPath)
    }
}
