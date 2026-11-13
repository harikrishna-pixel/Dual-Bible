//
//  ReaderSourceViewController.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 09/12/22.
//

import UIKit

class ReaderSourceViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ReaderSourceDelegate {
    

    @IBOutlet weak var BibleCollectionView: UICollectionView!
    
    
    lazy var AudioBibleList:Array<String> = []
    lazy var SecondBibleList:Array<String> = []
    lazy var MarkAsReadArray: Array<String> = []
    var Pageindex:Int = 1
    var Book:String = ""
    var VereseIndex:Int = 1
    var upDownStatus:Bool = true
    var SelectedIndex:IndexPath = IndexPath(item: 0, section: 0)
    
    var Themecolor:UIColor?
     
    var mainfont: UIFont?
    
    var secondfont: UIFont?
    var SplitCellData: [String] = []
    var indexOfVerse: Array<String>.Index?
    
    lazy var BibleSavedVerses:Array<String> = []
    lazy var BookFilter:Array<String> = []
    lazy var BibleTxt:String = ""

    
    private var lastContentOffset: CGFloat = 60
    var ADView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth-20, height: 198))
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        
        
        self.BibleCollectionView.register(UINib(nibName: "BannerAd", bundle: nil), forCellWithReuseIdentifier: "BannerAd")
        
        self.BibleCollectionView.register(UINib(nibName: "AdFrameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AdFrameCollectionViewCell")
        self.BibleCollectionView.register(UINib(nibName: "CopyRightsCell", bundle: nil), forCellWithReuseIdentifier: "CopyRightsCell")
        
        
        mainfont = UIFont(name:UserDefaults.standard.string(forKey: "FontName")!, size: CGFloat(UserDefaults.standard.float(forKey: "FontSize")))
        secondfont = UIFont(name:UserDefaults.standard.string(forKey: "SubFontName")!, size: CGFloat(UserDefaults.standard.float(forKey: "FontSize")))
        
        App_Protocol.delegateReaderSource = self
        self.BibleCollectionView.register(UINib(nibName: "CopyRightsCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier:"CopyRightsCell")
        self.MarkAsReadArray = CoreDataModel.sharedInstance.GetMarkasReadStatus(entity: CDMarkAsRead)
        self.BibleCollectionView.reloadData()
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.BibleCollectionView.register(UINib(nibName: "BannerAd", bundle: nil), forCellWithReuseIdentifier: "BannerAd")
        
        self.BibleCollectionView.register(UINib(nibName: "AdFrameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AdFrameCollectionViewCell")
        self.BibleCollectionView.register(UINib(nibName: "CopyRightsCell", bundle: nil), forCellWithReuseIdentifier: "CopyRightsCell")

        self.ReloadBibleData(ChapterNo: self.Pageindex)
    }
    
    
    
    func ReloadBibleData(ChapterNo:Int) {
        
        mainfont = UIFont(name:UserDefaults.standard.string(forKey: "FontName")!, size: CGFloat(UserDefaults.standard.float(forKey: "FontSize")))
        secondfont = UIFont(name:UserDefaults.standard.string(forKey: "SubFontName")!, size: CGFloat(UserDefaults.standard.float(forKey: "FontSize")))
        
        
        self.Themecolor = UserDefaults.standard.color(forKey: "AppThemeColor")
        
        UserDefaults.standard.set(ChapterNo, forKey: "BookChapter")
        Book = UserDefaults.standard.string(forKey: "BookName")!

        
        GoogleBannerAD.shared.SourceVC = self
        self.ADView = GoogleBannerAD.shared.InitBanner(width: ScreenWidth-20, height: 198, BannerId: GOOGLE_BANNER_ADS_ID3)
        GoogleBannerAD.shared.loadAd()
        
        self.BibleSavedVerses = CoreDataModel.sharedInstance.AudioBibleVerse(entity: CDBookSavedInfo, bookname: Book)
        self.AudioBibleList = BibleContent.sharedInstance.AudioBibleList(selecterBookName: Book , selectedId: ChapterNo-1)
        BookFilter = ReloadCoredata()
        self.BibleCollectionView.backgroundColor = (self.Themecolor == BGNightMode ? self.Themecolor:UIColor.white)
        Pageindex = UserDefaults.standard.integer(forKey: "BookChapter")
        
        
        BookURL.sharedInstance.bookURL(BookNo: String(self.Pageindex))
        App_Protocol.delegateReader?.PageConfig()
        App_Protocol.delegatePageController?.ReloadAllData(index: Pageindex) 
        self.reloadCollectionView(collectionView: self.BibleCollectionView)
        
    }
    
    

    
    
    
    func ReloadFont(ChapterNo:Int) {
        
        mainfont = UIFont(name:UserDefaults.standard.string(forKey: "FontName")!, size: CGFloat(UserDefaults.standard.float(forKey: "FontSize")))
        secondfont = UIFont(name:UserDefaults.standard.string(forKey: "SubFontName")!, size: CGFloat(UserDefaults.standard.float(forKey: "FontSize")))
        
        
        self.BibleCollectionView.register(UINib(nibName: "BannerAd", bundle: nil), forCellWithReuseIdentifier: "BannerAd")
        
        self.BibleCollectionView.register(UINib(nibName: "AdFrameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AdFrameCollectionViewCell")
        
        self.BibleCollectionView.register(UINib(nibName: "CopyRightsCell", bundle: nil), forCellWithReuseIdentifier: "CopyRightsCell")
        
        
//        self.BibleCollectionView.register(UINib(nibName: "MarkasReadCC", bundle: nil), forCellWithReuseIdentifier: "MarkasReadCC")
        self.Themecolor = UserDefaults.standard.color(forKey: "AppThemeColor")
        
        GoogleBannerAD.shared.SourceVC = self
        self.ADView = GoogleBannerAD.shared.InitBanner(width: ScreenWidth-20, height: 198, BannerId: GOOGLE_BANNER_ADS_ID3)
        GoogleBannerAD.shared.loadAd()

        
        UserDefaults.standard.set(ChapterNo, forKey: "BookChapter")
        Book = UserDefaults.standard.string(forKey: "BookName")!
         
        self.BibleSavedVerses = CoreDataModel.sharedInstance.AudioBibleVerse(entity: CDBookSavedInfo, bookname: Book)
        self.AudioBibleList = BibleContent.sharedInstance.AudioBibleList(selecterBookName: Book , selectedId: ChapterNo-1)

        BookFilter = ReloadCoredata()
        self.BibleCollectionView.backgroundColor = (self.Themecolor == BGNightMode ? self.Themecolor:UIColor.white)
        Pageindex = UserDefaults.standard.integer(forKey: "BookChapter")
        
        
        BookURL.sharedInstance.bookURL(BookNo: String(self.Pageindex))
        App_Protocol.delegatePageController?.ReloadAllData(index: Pageindex)
        self.reloadCollectionView(collectionView: self.BibleCollectionView)
        
    }
        
    
    
    func reloadCollectionView(collectionView: UICollectionView) {
        self.SecondaryBook()
     let contentOffset = collectionView.contentOffset
         collectionView.reloadData()
         collectionView.layoutIfNeeded()
         collectionView.setContentOffset(contentOffset, animated: false)
        
     }
    
    
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//            return CGSize(width: UIScreen.main.bounds.size.width, height: 120)
//      }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if PaymentHistory.sharedInstance.paymentInfo() {
            return self.AudioBibleList.count+2
        } else {
            return self.AudioBibleList.count+1
        }
        
    }
        
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
     
         if indexPath.row == self.AudioBibleList.count {

                 let cell = self.BibleCollectionView.dequeueReusableCell(withReuseIdentifier: "AdFrameCollectionViewCell", for: indexPath) as! AdFrameCollectionViewCell
            
            if self.MarkAsReadArray.contains("\(Book)-\(self.Pageindex)") {
                cell.MarkAsReadBtn.backgroundColor = (Themecolor == BGNightMode ? DarkModeColor:Themecolor)
                cell.MarkAsReadBtn.setTitle("Marked as Read", for: .normal)
                cell.MarkAsReadBtn.setTitleColor(.white, for: .normal)
            } else {
                cell.MarkAsReadBtn.setTitle("Mark as Read", for: .normal)
                cell.MarkAsReadBtn.backgroundColor = .systemGray6
                cell.MarkAsReadBtn.setTitleColor(.black, for: .normal)
                
            }

            cell.MarkAsReadBtn.addTarget(self, action: #selector(MarkAsReadAction), for: .touchUpInside)
//            cell.BibleAllOffice.addTarget(self, action: #selector(BibleOfficeAction), for: .touchUpInside)
            
//             if PaymentHistory.sharedInstance.paymentInfo() {
//                 for view in cell.ADView.subviews {
//                     view.removeFromSuperview()
//                 }
//                 cell.ADView.addSubview(UnityBannerVC.shared.InitBanner(height: 198))
//                 cell.ADView.backgroundColor = .clear
//             }
             
            
             return cell

         }
        else if indexPath.row == self.AudioBibleList.count+1 {

            let cell = self.BibleCollectionView.dequeueReusableCell(withReuseIdentifier: "BannerAd", for: indexPath) as! BannerAd
           
             if PaymentHistory.sharedInstance.paymentInfo() {
                 for view in cell.ADView.subviews {
                     view.removeFromSuperview()
                 }
                 cell.ADView.addSubview(self.ADView)
                 cell.ADView.backgroundColor = .clear
             }
            return cell

        }
        else {
            
             let cell = self.BibleCollectionView.dequeueReusableCell(withReuseIdentifier: "BibleVerseCC", for: indexPath) as! BibleVerseCC
             let bookVerse = String(format: "\(Book)-%d:%d", self.Pageindex, indexPath.row+1)
             
             cell.backgroundColor = (self.Themecolor == BGNightMode ? self.Themecolor:UIColor.white)
             cell.BibleDetaillbl.textColor = (self.Themecolor == BGNightMode ? UIColor.white:UIColor.black)
                
//            cell.DotLine.addDashedLine()
            
             if UserDefaults.standard.string(forKey: "SecondLanguage") ?? "" != ""  && APP_TYPE != "1" {
                 BibleTxt = "\n\(self.SecondBibleList.count > indexPath.row ? self.SecondBibleList[indexPath.row]:"")"
             }
             
             
             if BookFilter.count > 0 && BookFilter.contains(bookVerse) {
                 
                 indexOfVerse = self.BookFilter.firstIndex(of: bookVerse)
                 SplitCellData = CoreDataModel.sharedInstance.seperateByArray(SeperateValue: self.BibleSavedVerses[indexOfVerse!])
                                 
                                  
                 cell.FrameConstrain.constant = CGFloat(UserDefaults.standard.float(forKey: "FontSize"))

                 
                 cell.BibleDetaillbl.attributedText =  TextAttribute.shared.attributedTextBold1(withString: "\(indexPath.row+1).\(self.AudioBibleList[indexPath.row])\(BibleTxt)", SecondString: (BibleTxt), boldString: "\(indexPath.row+1).\(self.AudioBibleList[indexPath.row])\(BibleTxt)", font: mainfont!, Secondfont: UIFont(name: APPFONT, size: CGFloat(UserDefaults.standard.float(forKey: "FontSize")))!, line:(SplitCellData[4] == "true" ? true:false), colorStatus: (SplitCellData[0] == "#000000" ? false: true), color: (SplitCellData[0] == "#000000" ? UIColor.clear: hexColorConvert.shared.hexStringToUIColor(hex: SplitCellData[0])), number: "\(indexPath.row+1).",Bookmark:(SplitCellData[SplitCellData.count-2] == "" ? false:true) ,Note:(SplitCellData[1] == "" ? false:true))
                 
             } else {
                 
                 cell.BibleDetaillbl.attributedText = TextAttribute.shared.attributedTextBold1(withString: "\(indexPath.row+1).\(self.AudioBibleList[indexPath.row])\(BibleTxt)", SecondString: BibleTxt, boldString: "\(indexPath.row+1).\(self.AudioBibleList[indexPath.row])\(BibleTxt)", font: mainfont!, Secondfont: secondfont!, line:false, colorStatus: false, color: UIColor.clear, number: "\(indexPath.row+1).",Bookmark:false,Note:false)
             }
             
              return cell
             
         }

    }
    
    @objc func MarkAsReadAction(sender: UIButton!) {
            CoreDataModel.sharedInstance.coreDataInsertMarkAsRead(CDMarkAsRead, veresInfo: "\(Book)-\(self.Pageindex)")
            self.MarkAsReadArray = CoreDataModel.sharedInstance.GetMarkasReadStatus(entity: CDMarkAsRead)
        
        let indexPaths = NSIndexPath(row:0 , section: 0)
        let indexPaths1 = NSIndexPath(row:self.AudioBibleList.count , section: 0)
        
        let footer = self.BibleCollectionView.dequeueReusableCell(withReuseIdentifier: "AdFrameCollectionViewCell", for: indexPaths1 as IndexPath) as? AdFrameCollectionViewCell
        
        if self.MarkAsReadArray.contains("\(Book)-\(self.Pageindex)") {
            footer!.MarkAsReadBtn.backgroundColor = (Themecolor == BGNightMode ? DarkModeColor:Themecolor)
            footer!.MarkAsReadBtn.setTitle("Marked as Read", for: .normal)
            footer!.MarkAsReadBtn.setTitleColor(.white, for: .normal)
            
        } else {
            footer!.MarkAsReadBtn.setTitle("Mark as Read", for: .normal)
            footer!.MarkAsReadBtn.backgroundColor = .systemGray6
            footer!.MarkAsReadBtn.setTitleColor(.black, for: .normal)
        }
        
        
        if UserDefaults.standard.string(forKey: "AdTime") ?? "" == "" {
            let date = Date().addingTimeInterval(5 * 60)
            UserDefaults.standard.setValue(date.string(format: "HH:mm"), forKey: "AdTime")
        }
        App_Protocol.delegateReader?.CallInterstitialAd()
        self.BibleCollectionView.reloadItems(at: [indexPaths1 as IndexPath])

        
    }
    
    
    func CallAd() {
        
        var adtime = UserDefaults.standard.string(forKey: "AdTime")
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
    
        if  f.date(from: Date().string(format: "HH:mm"))! >=  f.date(from: adtime!)! {
            UserDefaults.standard.setValue("", forKey: "AdTime")
        }

    }
    
    
    @objc func BibleOfficeAction(sender: UIButton!) {
        let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "CopYRightsVc") as! CopYRightsVc
        vc.LoaderView = COPIRIGHTS_URL
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
     
    
    func SecondaryBook(){
        if UserDefaults.standard.string(forKey: "SecondLanguage") ?? "" != ""  {
            let bookPosition = BibleContent.sharedInstance.BookToPosition(stringBook: Book)
            self.SecondBibleList = SecondLanguage.shared.AudioBibleList(selectedId: self.Pageindex-1, bookPosition: bookPosition)
        }
        
    }
    
    
    
    func GetTSData() ->(AudioBibleList:Array<String>, BookName:String, pagecount:Int) {
        return (AudioBibleList:self.AudioBibleList, BookName:Book, pagecount:10)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        SelectedIndex = indexPath
        
        let bookVerse = String(format: "\(Book)-%d:%d", self.Pageindex, indexPath.row+1)
        
        App_Protocol.delegateReader?.CallAds()
        
        if indexPath.row != self.AudioBibleList.count {
            if BookFilter.count > 0 && BookFilter.contains(bookVerse) {
                let indexOfVerse = self.BookFilter.firstIndex(of: bookVerse)
                
                
                let SplitCellData = CoreDataModel.sharedInstance.seperateByArray(SeperateValue: self.BibleSavedVerses[indexOfVerse!])
                
                App_Protocol.delegateReader?.MenuNib(VersePosition: indexPath.row+1, BookName: Book, Pageindex: Pageindex+1, BookVerse: self.AudioBibleList, Bookmark: SplitCellData[SplitCellData.count-2], ColorCode: SplitCellData[0], UnderlineStatus: SplitCellData[4], note:SplitCellData[1], SecondaryVerse: self.SecondBibleList)
            } else {
                
                App_Protocol.delegateReader?.MenuNib(VersePosition: indexPath.row+1, BookName: Book, Pageindex: Pageindex+1, BookVerse: self.AudioBibleList, Bookmark: "", ColorCode: "", UnderlineStatus: "", note:"", SecondaryVerse: self.SecondBibleList)
            }
        }
    }
    
//
//    func collectionView(_ collectionView: UICollectionView,
//                       viewForSupplementaryElementOfKind kind: String,
//                       at indexPath: IndexPath) -> UICollectionReusableView {
//
//       switch kind {
//
//       case UICollectionView.elementKindSectionHeader:
//        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
//
//        headerView.backgroundColor = .clear
//              return headerView
//
//       case UICollectionView.elementKindSectionFooter:
//        let footerView = self.BibleCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CopyRightsCell", for: indexPath) as!  CopyRightsCell
//
//           if self.MarkAsReadArray.contains("\(Book)-\(self.Pageindex)") {
//               footerView.MarkAsReadBtn.backgroundColor = (Themecolor == BGNightMode ? DarkModeColor:Themecolor)
//               footerView.MarkAsReadBtn.setTitle("Marked as Read", for: .normal)
//               footerView.MarkAsReadBtn.setTitleColor(.white, for: .normal)
//           } else {
//               footerView.MarkAsReadBtn.setTitle("Mark as Read", for: .normal)
//               footerView.MarkAsReadBtn.backgroundColor = .systemGray6
//               footerView.MarkAsReadBtn.setTitleColor(.black, for: .normal)
//           }
//
//           footerView.MarkAsReadBtn.addTarget(self, action: #selector(MarkAsReadAction), for: .touchUpInside)
//           footerView.BibleAllOffice.addTarget(self, action: #selector(BibleOfficeAction), for: .touchUpInside)
//
//
//           return footerView
//       default:
//           let cell = self.BibleCollectionView.dequeueReusableCell(withReuseIdentifier: "BibleVerseCC", for: indexPath) as! BibleVerseCC
//        return cell
//       }
//   }
//
    
    
    
    
    
        
    
    func navigateToSelectedVerse() {
        
        var ReadingVerse = UserDefaults.standard.string(forKey: "readdata") ?? ""
        let spaceCount = ReadingVerse.filter{$0 == " "}.count
        
        if  ReadingVerse != nil && ReadingVerse != "" && ReadingVerse != "Verse Of The Day"  {
            if ReadingVerse.contains("--") {
                ReadingVerse = ReadingVerse.components(separatedBy: "--")[0]
            }
            let SeperateVerse = ReadingVerse.components(separatedBy: [":","-"," "])
            
//            if ReadingVerse.contains("The Song of Songs") {
                self.Pageindex = Int(SeperateVerse[SeperateVerse.count-2])!
                self.VereseIndex = Int(SeperateVerse[SeperateVerse.count-1])!
            
            
            self.Book = ""
            
                for i in 0 ..< SeperateVerse.count {
                    if i < SeperateVerse.count-2 {
                        if i == 0 {
                            self.Book.append(SeperateVerse[i])
                        } else {
                            self.Book.append(" \(SeperateVerse[i])")
                        }
                    }
                }
            
            UserDefaults.standard.set(self.Pageindex, forKey: "BookChapter")
            UserDefaults.standard.set(self.Book, forKey: "BookName")
            
            App_Protocol.delegateReader?.HomePageCall(Status: true)
            let indexPaths = NSIndexPath(row: self.VereseIndex-1, section: 0)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
                self.AudioBibleList = BibleContent.sharedInstance.AudioBibleList(selecterBookName: self.Book , selectedId: ((self.Pageindex == 0 ) ? 0:self.Pageindex-1))
                            
                let bookPosition = BibleContent.sharedInstance.BookToPosition(stringBook: self.Book)
                self.SecondBibleList = SecondLanguage.shared.AudioBibleList(selectedId: self.Pageindex-1, bookPosition: bookPosition)
                
                self.BibleCollectionView.reloadData()
                self.BibleCollectionView.scrollToItem(at: indexPaths as IndexPath, at: .centeredVertically, animated: true)
                 self.view.layoutIfNeeded()
                App_Protocol.delegateReader?.PageConfig()
                UserDefaults.standard.set("", forKey: "readdata")
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.6) {
                    let cell = self.BibleCollectionView.cellForItem(at: indexPaths as IndexPath) as? BibleVerseCC
                    cell?.backgroundColor = (self.Themecolor == BGNightMode ? UIColor.white.withAlphaComponent(0.5):self.Themecolor?.withAlphaComponent(0.5))
                    UIView.animate(withDuration: 1.0) {
                        cell?.backgroundColor = (self.Themecolor == BGNightMode ? UIColor.white.withAlphaComponent(0.0):self.Themecolor?.withAlphaComponent(0.0))
                         self.view.layoutIfNeeded()
                        
                        
                    }
                }
            }
        }
    }
    
    
    
    func ReloadCoredata() -> Array<String> {
        let book_name  = UserDefaults.standard.string(forKey: "BookName")!
        
            self.BibleSavedVerses.removeAll()
            self.BookFilter.removeAll()
        
            
        
            self.BibleSavedVerses = CoreDataModel.sharedInstance.AudioBibleVerse(entity: CDBookSavedInfo, bookname: book_name)
         
            let corevalue = CoreDataModel.sharedInstance.GetAllData(entity: CDBookSavedInfo)
        
                
            for items in self.BibleSavedVerses {
                let srt = CoreDataModel.sharedInstance.seperateByArrayBook(SeperateValue: items)
                self.BookFilter.append(srt)
            }
        
        return self.BookFilter
    }
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        App_Protocol.delegateReader?.ClosePlayerPopup()
        
        if lastContentOffset-10 > scrollView.contentOffset.y {
            if upDownStatus {
                App_Protocol.delegateReader?.ConstrainChange(Top: 0.0, bottom:StatusbarHeight)
                upDownStatus = false
            }
        } else if lastContentOffset < scrollView.contentOffset.y {
            if upDownStatus == false {
                App_Protocol.delegateReader?.ConstrainChange(Top: -200, bottom:-100)
                upDownStatus = true
            }
            
        }
        if scrollView.contentOffset.y >= 60 {
            lastContentOffset = scrollView.contentOffset.y
        }
    }
    
}





