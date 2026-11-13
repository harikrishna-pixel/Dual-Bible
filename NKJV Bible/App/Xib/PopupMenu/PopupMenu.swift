//
//  PopupMenu.swift
//  Audio Bible
//
//  Created by Axeraan Technologies on 15/02/21.
//

import UIKit

class PopupMenu: UIView {
 
    @IBOutlet var verse: UILabel!
    @IBOutlet var Book: UILabel!
    @IBOutlet var Popupframe: UIView!
    @IBOutlet var Popupframetext: UILabel!
    @IBOutlet var PopupframeBook: UILabel!
    @IBOutlet var DeleteVu: UIView!
    
    
    @IBOutlet var CopyIcon: UIImageView!
    @IBOutlet var ShareIcon: UIImageView!
    @IBOutlet var ReadIcon: UIImageView!
    @IBOutlet var DeleteIcon: UIImageView!
    
    @IBOutlet weak var WLeftConstrain: NSLayoutConstraint!
    @IBOutlet weak var WRightConstrain: NSLayoutConstraint!
    
    
     var getString: String!
     var VCSelection: String!
     var TagSelection: String!
    
     var Chapter: String = ""
     var BookName: String = ""
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func draw(_ rect: CGRect) {
        self.DeleteVu.isHidden = true
        
        let seperateArray = getString.components(separatedBy: "_")
        let Themecolor = UserDefaults.standard.color(forKey: "AppThemeColor")!
        

        let PrimaryBook = BibleContent.sharedInstance.BookToList()
        
        
        if VCSelection == "SearchViewController" {
            self.Popupframetext.text = seperateArray[0]
            self.PopupframeBook.text = seperateArray[1].replacingOccurrences(of: "-", with: ":")
            
                              
            let bookIntex = seperateArray[1].components(separatedBy: " ")
            for i in 0..<bookIntex.count {
                
                if i == 0 {
                    self.BookName.append("\(seperateArray[1].components(separatedBy: " ")[i])")
                } else if i < bookIntex.count-1 {
                    self.BookName.append(" \(seperateArray[1].components(separatedBy: " ")[i])")
                } else {
                    self.Chapter = "\(seperateArray[1].components(separatedBy: " ")[i].replacingOccurrences(of: "-", with: ":") )"
                }
            }
            
            self.BookName = SecondLanguage.shared.BookList()[PrimaryBook.firstIndex(of: self.BookName)!]
            
            
        } else if VCSelection == "DailyVerses" {
            self.Popupframetext.text = seperateArray[2]
            self.PopupframeBook.text = seperateArray[0]
            
            
            let bookIntex = seperateArray[0].components(separatedBy: " ")
            for i in 0..<bookIntex.count {
                if i < bookIntex.count-1 {
                    self.BookName.append(" \(seperateArray[0].components(separatedBy: " ")[i])")
                }
            }
            
        } else {
            self.DeleteVu.isHidden = false
            self.Popupframetext.text = seperateArray[3]
            self.PopupframeBook.text = seperateArray[0].replacingOccurrences(of: "-", with: " ")
            
            self.Chapter = seperateArray[0].components(separatedBy: "-")[1]
            self.BookName = SecondLanguage.shared.BookList()[PrimaryBook.firstIndex(of: seperateArray[0].components(separatedBy: "-")[0])!]
            
        }
        


        
        
        
        self.PopupframeBook.font = UIFont(name:UserDefaults.standard.string(forKey: "FontName")!, size: 15)
        self.Popupframetext.font = UIFont(name:UserDefaults.standard.string(forKey: "FontName")!, size: 15)
        
        
        if Themecolor == BGNightMode {
            ImageTint.sharedInstance.imageTintcolorMethod(img: self.CopyIcon!, colorVu: .black)
            ImageTint.sharedInstance.imageTintcolorMethod(img: self.ShareIcon!, colorVu: .black)
            ImageTint.sharedInstance.imageTintcolorMethod(img: self.ReadIcon!, colorVu: .black)
            ImageTint.sharedInstance.imageTintcolorMethod(img: self.DeleteIcon!, colorVu: .black)
        }
        
        
        
        if isIpad {
            self.WLeftConstrain.constant = 120
            self.WRightConstrain.constant = 120
        }
        
        
        self.Popupframetext.text = self.Popupframetext.text!.trimmingCharacters(in: .whitespaces)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.Popupframe.layer.cornerRadius = 30
          }
    }
    

    
    
    @IBAction func Close(_ sender: Any) {
     if VCSelection == "SearchViewController" {
        App_Protocol.delegateSearch?.CloseView()
    } else {
        App_Protocol.delegateReader?.CloseView()
    }
    }
    
    
    @IBAction func CloseAction(_ sender: Any) {
         if VCSelection == "SearchViewController" {
            App_Protocol.delegateSearch?.CloseView()
        } else {
            App_Protocol.delegateReader?.CloseView()
        }
    }
    
    
    
    @IBAction func ReadVerse(_ sender: Any) {
        
        UserDefaults.standard.set(self.PopupframeBook.text, forKey: "readdata")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3) {
            App_Protocol.delegateReaderSource?.navigateToSelectedVerse()
        }
        
         if VCSelection == "SearchViewController" {
            App_Protocol.delegateSearch?.navigateMainClass()
         } else {
             App_Protocol.delegateReader?.CloseView()
         }
    }
    
     
    
    
    @IBAction func copYText(_ sender: Any) {
        self.makeToast("Copied successfully", duration: 2.0, position: .center)
        
        let content = self.Popupframetext.text!.replacingOccurrences(of: "\n\n", with: "\n\(self.BookName) \(self.Chapter)- ")
        
          UIPasteboard.general.string = "\(self.PopupframeBook.text!)-\(content)\n\nRead more at: \(APP_LINK)"
          DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
              App_Protocol.delegateMyLibrary?.CloseView()
        }
    }
    
    
    @IBAction func ShareVerse(_ sender: Any) {
        let content = self.Popupframetext.text!.replacingOccurrences(of: "\n\n", with: "\n\(self.BookName) \(self.Chapter)- ")
        App_Protocol.delegateReader?.shared(VerseStr: "\(self.PopupframeBook.text!)-\(content)", Bookname: "")
    }
    
    
    @IBAction func DeleteVerse(_ sender: Any) {
        
        self.PopupframeBook.text! = getString.components(separatedBy: "_")[0]
        
        
        switch self.TagSelection {
        case "BookMark":

            CoreDataModel.sharedInstance.coreDataDeleteBookMark(CDBookSavedInfo, bookVerse: self.PopupframeBook.text!, Bookmark: "")
            self.makeToast("Bookmark removed", duration: 2.0, position: .bottom)

        case "Highlites":
            
            CoreDataModel.sharedInstance.coreDataDeleteColor(CDBookSavedInfo, bookVerse: self.PopupframeBook.text!, color: "#000000")
            self.makeToast("Highlites removed", duration: 2.0, position: .bottom)
            
        case "Underline":
            CoreDataModel.sharedInstance.coreDataDeleteUnderline(CDBookSavedInfo, bookVerse: self.PopupframeBook.text!)
            self.makeToast("Underline removed", duration: 2.0, position: .bottom)
            

        case "Notes":
            CoreDataModel.sharedInstance.coreDataDeleteNote(CDBookSavedInfo, bookVerse:self.PopupframeBook.text!, notes: "")
            self.makeToast("Notes removed", duration: 2.0, position: .bottom)

        default: break

        }
        
        
        App_Protocol.delegateReader?.CloseView()
        App_Protocol.delegateMyLibrary?.ReloadAllData()
    }
    
    
    
    
}
