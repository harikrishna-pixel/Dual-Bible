//
//  VersesMenu.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 13/12/22.
//

import UIKit

class VersesMenu: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, VersesMenuPopup {

    
    static let shared = VersesMenu()
    
    @IBOutlet weak var ColorCC: UICollectionView!
    @IBOutlet var DottedLines: UIView!
    
    @IBOutlet weak var Bookmark: UIView!
    @IBOutlet weak var Note: UIView!
    
    @IBOutlet weak var BookmarkTxt:UILabel!
    @IBOutlet weak var NoteTxt:UILabel!
    
    
    @IBOutlet weak var BookmarkImg: UIImageView!
    @IBOutlet weak var NoteImg: UIImageView!
    
    
    @IBOutlet weak var Underline: UIView!
    @IBOutlet weak var Refresh: UIView!
    @IBOutlet weak var Copy: UIView!
    @IBOutlet weak var Share: UIView!
    
    var SelectedColor:Int = -1
    
    
    @IBOutlet weak var UnderlineImg: UIImageView!
    @IBOutlet weak var RefreshImg: UIImageView!
    @IBOutlet weak var CopyImg: UIImageView!
    @IBOutlet weak var ShareImg: UIImageView!
    
    
    @IBOutlet weak var BookmarkWidth: NSLayoutConstraint!
    @IBOutlet weak var NoteWidth: NSLayoutConstraint!
    @IBOutlet weak var FrameWidth: NSLayoutConstraint!
    @IBOutlet weak var BMImageHeight: NSLayoutConstraint!
    @IBOutlet weak var NoteImageHeight: NSLayoutConstraint!
    @IBOutlet weak var FrameHeight: NSLayoutConstraint!
    
    
    
    var VersePosition:Int = -1
    var BookName:String = ""
    var Pageindex:Int = -1
    var BookVerse:Array<String>?
    var SecondaryVerse:Array<String>?
    var SecondaryVersetxt = ""
    var Notetxt:String = ""
    var BookmarkStatus:String = ""
    var ColorCode:String = ""
    var SelectedColorCode:String = ""
    var UnderlineStatus:String = ""
    
    
    var Themecolor:UIColor?
    
        
    var SecondaryBook:[String] = []
    var PrimaryBook:[String] = []
        
    
    override func draw(_ rect: CGRect) {
        self.Themecolor = UserDefaults.standard.color(forKey: "AppThemeColor")!
        
        
        SelectedColorCode = ColorCode
        self.DottedLines.addDashedBorderView()
        App_Protocol.DelegateVersesMenuPopup = self
        self.BookmarkWidth.constant = (isIpad ? 400:300)/3
        self.NoteWidth.constant = (isIpad ? 400:300)/3
        self.FrameWidth.constant = (isIpad ? 400:300)
        
        
        
        
        self.SecondaryBook = SecondLanguage.shared.BookList()
        self.PrimaryBook = BibleContent.sharedInstance.BookToList()
        
        
        
        if self.SecondaryVerse!.count > VersePosition-1 {
            SecondaryVersetxt = "\n\n\(self.SecondaryVerse![VersePosition-1])"
        }
        
        
        
        
        
        FrameHeight.constant = (isIpad ? 360:320)
        
        
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.BookmarkImg, colorVu: self.Themecolor!)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.NoteImg, colorVu: self.Themecolor!)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.UnderlineImg, colorVu: self.Themecolor!)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.RefreshImg, colorVu: self.Themecolor!)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.CopyImg, colorVu: self.Themecolor!)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.ShareImg, colorVu: self.Themecolor!)
        
        self.Underline.ViewBorder(color: self.Themecolor!)
        self.Refresh.ViewBorder(color: self.Themecolor!)
        self.Copy.ViewBorder(color: self.Themecolor!)
        self.Share.ViewBorder(color: self.Themecolor!)
        
        self.Bookmark.layer.cornerRadius = 4
        self.Note.layer.cornerRadius = 4
        
        self.Bookmark.backgroundColor = self.Themecolor!.withAlphaComponent(0.35)
        self.Note.backgroundColor = self.Themecolor!.withAlphaComponent(0.35)
        
        self.BookmarkTxt.textColor = self.Themecolor!
        self.NoteTxt.textColor = self.Themecolor!
        
        self.BookmarkTxt.font = UIFont.systemFont(ofSize: (isIpad ? 15:13), weight: UIFont.Weight.semibold)
        self.NoteTxt.font = UIFont.systemFont(ofSize: (isIpad ? 15:13), weight: UIFont.Weight.semibold)
        
        
                
        self.BMImageHeight.constant = (isIpad ? 18:13)
        self.NoteImageHeight.constant = (isIpad ? 18:13)
        
        
        self.ColorCC.delegate = self
        self.ColorCC.dataSource = self
        
        self.ColorCC.register(UINib(nibName: "ColorCell", bundle: nil), forCellWithReuseIdentifier: "ColorCell")
    }
    
    
    
    func ChangeNote(Notetxt:String,_ Status:Bool) {
        self.Notetxt = Notetxt
        
      self.makeToast("Notes \(Status ? "Deleted":"Saved") Successfully!", duration: 2.0, position: .bottom)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//            return CGSize(width: 40, height: 40)
//      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (isIpad ? 85:60), height: (isIpad ? 85:60))
    }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HighlightColors.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = self.ColorCC.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
            
          cell.ColorView.backgroundColor = hexColorConvert.shared.hexStringToUIColor(hex: HighlightColors[indexPath.row])
            cell.layer.cornerRadius = 4
        
            cell.Tick.isHidden = (self.SelectedColor == indexPath.row ? false : true)
            cell.Tick.isHidden = (self.SelectedColorCode == "#\(HighlightColors[indexPath.row])" ? false:true )
        
        
        cell.TicKiconwidth.constant = isIpad ? 22:14
        cell.TicKiconheight.constant = isIpad ? 22:14
        
        
            
            return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        
//        if self.SelectedColor == indexPath.row {
//            self.SelectedColor = -1
//        } else {
            self.SelectedColor = indexPath.row
            
            if self.SelectedColorCode == "#\(HighlightColors[indexPath.row])" {
                self.SelectedColorCode = ""
                self.SelectedColor = -1
                CoreDataModel.sharedInstance.coreDataInsert(CDBookSavedInfo, bookVerse:"\(BookName)-\(Pageindex-1):\(VersePosition)" , color: "#000000", Verses: "\(self.BookVerse![VersePosition-1])\(SecondaryVersetxt)")
            } else {
                self.SelectedColorCode = "#\(HighlightColors[indexPath.row])"
                
                
                CoreDataModel.sharedInstance.coreDataInsert(CDBookSavedInfo, bookVerse:"\(BookName)-\(Pageindex-1):\(VersePosition)" , color: "#\(HighlightColors[self.SelectedColor])", Verses: "\(self.BookVerse![VersePosition-1])\(SecondaryVersetxt)")
            }
            
//        }
        self.ColorCC.reloadData()
        
        App_Protocol.delegateReaderSource?.ReloadBibleData(ChapterNo:Pageindex-1)
    }
    
    
    
    @IBAction func CloseAction(_ sender: Any) {
        App_Protocol.delegateReader?.CloseMenu()
    }
    
    
    @IBAction func NoteAction(_ sender: Any) {
        App_Protocol.delegateReader?.NoteNib(VersePosition: VersePosition, BookName: BookName, Pageindex: Pageindex, BookVerse: BookVerse![VersePosition-1], note:Notetxt, SecondaryVerse:self.SecondaryVerse![VersePosition-1])
        App_Protocol.delegateReaderSource?.ReloadBibleData(ChapterNo:UserDefaults.standard.integer(forKey: "BookChapter"))
    }
    
    @IBAction func BookmarkAction(_ sender: Any) {
        
        if BookmarkStatus == "bookMarked" {
            CoreDataModel.sharedInstance.coreDataInsertBookmarked(CDBookSavedInfo, bookVerse:"\(BookName)-\(Pageindex-1):\(VersePosition)" , Bookmark: "", Verses: "\(self.BookVerse![VersePosition-1])\(SecondaryVersetxt)")
            
            App_Protocol.delegateReader?.AlertFrame(AlertNote: "Bookmark Removed Successfully!!",Vers:"\(self.BookVerse![VersePosition-1])\(SecondaryVersetxt)",Title:"\(BookName)-\(Pageindex-1):\(VersePosition)")
            BookmarkStatus = ""
        } else {
            RateUsCall.shared.ClickCount()
            BookmarkStatus = "bookMarked"
            CoreDataModel.sharedInstance.coreDataInsertBookmarked(CDBookSavedInfo, bookVerse:"\(BookName)-\(Pageindex-1):\(VersePosition)" , Bookmark: "bookMarked", Verses: "\(self.BookVerse![VersePosition-1])\(SecondaryVersetxt)")
            App_Protocol.delegateReader?.AlertFrame(AlertNote: "Bookmark saved Successfully!!",Vers:"\(self.BookVerse![VersePosition-1])\(SecondaryVersetxt)",Title:"\(BookName)-\(Pageindex-1):\(VersePosition)")
        }

        print("BookChapter :",UserDefaults.standard.integer(forKey: "BookChapter"))
        
        App_Protocol.delegateReaderSource?.ReloadBibleData(ChapterNo:UserDefaults.standard.integer(forKey: "BookChapter"))
        
    }
    
    @IBAction func UnderlineAction(_ sender: Any) {
        RateUsCall.shared.ClickCount()
        CoreDataModel.sharedInstance.coreDataInsertUnderLine(CDBookSavedInfo, bookVerse: "\(BookName)-\(Pageindex-1):\(VersePosition)", Bookmark: "", Verses: "\(self.BookVerse![VersePosition-1])\(SecondaryVersetxt)", Underlinestatus: (UnderlineStatus == "true" ? false:true))
        
        
        App_Protocol.delegateReader?.AlertFrame(AlertNote: UnderlineStatus == "true" ?  "Underline Removed Successfully!!" : "Verse Underlined Successfully!!" , Vers:"\(self.BookVerse![VersePosition-1])\(SecondaryVersetxt)",Title:"\(BookName)-\(Pageindex-1):\(VersePosition)")
        
        
        if UnderlineStatus == "false" {
            UnderlineStatus = "true"
        } else {
            UnderlineStatus = "false"
        }
        
    
        App_Protocol.delegateReaderSource?.ReloadBibleData(ChapterNo:UserDefaults.standard.integer(forKey: "BookChapter"))
    }
    
    
    @IBAction func CopyAction(_ sender: Any) {
        RateUsCall.shared.ClickCount()
        let SecondTitle = self.SecondaryBook[self.PrimaryBook.firstIndex(of: BookName) ?? 0]
        
        UIPasteboard.general.string = "\(BookName)-\(Pageindex-1):\(VersePosition)\n\n\(self.BookVerse![VersePosition-1])\n\n\(SecondTitle) \(Pageindex-1):\(VersePosition)-\(SecondaryVersetxt)"

        
        App_Protocol.delegateReader?.AlertFrame(AlertNote: "Copied Succesfully!!",Vers:"\(self.BookVerse![VersePosition-1])\(SecondaryVersetxt)",Title:"\(BookName)-\(Pageindex-1):\(VersePosition)")
    }
    
    
    @IBAction func RefreshAction(_ sender: Any) {
        
        
        CoreDataModel.sharedInstance.coreDataRemoveAllData(CDBookSavedInfo, bookVerse: "\(BookName)-\(Pageindex-1):\(VersePosition)")
        App_Protocol.delegateReaderSource?.ReloadBibleData(ChapterNo:UserDefaults.standard.integer(forKey: "BookChapter"))
        
        App_Protocol.delegateReader?.AlertFrame(AlertNote: "Verse Reset Successfully!!",Vers:"\(self.BookVerse![VersePosition-1])\(SecondaryVersetxt)",Title:"\(BookName)-\(Pageindex-1):\(VersePosition)")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            App_Protocol.delegateReader?.CloseMenu()
        }
        
    }
    
    @IBAction func WallpaperAction(_ sender: Any) {

        App_Protocol.delegateReader?.WallpaperNib(VersePosition: VersePosition, BookName: "\(BookName)-\(Pageindex-1):\(VersePosition)", Pageindex: Pageindex, BookVerse: self.BookVerse!, SecondaryVerse: self.SecondaryVerse!)
                
    }
    
    
    @IBAction func ShareAction(_ sender: Any) {
        
        let SecondTitle = self.SecondaryBook[self.PrimaryBook.firstIndex(of: BookName) ?? 0]
//        let VersContent = seperatedValue[0].replacingOccurrences(of: "\n\n", with: "\n\n\(SecondTitle) \(Pageindex-1):\(VersePosition)- ")
        
        
        
        App_Protocol.delegateReader?.shared(VerseStr: "\(BookName)-\(Pageindex-1):\(VersePosition)\n\n\(self.BookVerse![VersePosition-1])\n\n\(SecondTitle) \(Pageindex-1):\(VersePosition)-\(SecondaryVersetxt)", Bookname: "")
    }
    
    
    
    
    
    
    
     
    

}
