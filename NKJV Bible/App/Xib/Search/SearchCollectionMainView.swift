//
//  SearchCollectionMainView.swift
//  Audio Bible
//
//  Created by Axeraan Technologies on 13/02/21.
//

import UIKit


@available(iOS 13.4, *)
class SearchCollectionMainView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet var SearchCollectionVu: UICollectionView!
    @IBOutlet var PlaceHolderImg: UIImageView!
    @IBOutlet var AlertLbl:UILabel!
    let Themecolor = UserDefaults.standard.color(forKey: "AppThemeColor")!
    
    var SearchTxt: Array<String> = []
    var corevalue: Array<String> = []
    var corevalueReverced: Array<String> = []
    var coreTitle: String?
    var Searchstring: String = ""
    var LineCount:CGFloat = 0.0
    var LineNote:CGFloat = 0.0
    
    var SecondaryBook:[String] = []
    var PrimaryBook:[String] = []
    
    private var lastContentOffset: CGFloat = 60
    
    @IBOutlet weak var ImageHeight: NSLayoutConstraint!
    @IBOutlet weak var ImageWidth: NSLayoutConstraint!
    
    var library = MyLibraryViewController()
    var fontsize: Int = 0
    
    override func draw(_ rect: CGRect) {

        self.AlertLbl.isHidden = true
        self.SearchCollectionVu.allowsSelection = false
        self.SearchCollectionVu.delegate = self
        self.SearchCollectionVu.dataSource = self
        self.PlaceHolderImg.image = UIImage(named: coreTitle ?? "search_PH")

        self.SearchCollectionVu.backgroundColor = (Themecolor == BGNightMode ? BGNightMode:.white)
        
        self.ImageHeight.constant = ScreenWidth/1.6
        self.ImageWidth.constant = ScreenWidth/1.6
        
        self.SearchCollectionVu!.register(UINib(nibName: "SearchCollectionView", bundle: nil), forCellWithReuseIdentifier: "Search")
        self.SearchCollectionVu!.register(UINib(nibName: "Notes", bundle: nil), forCellWithReuseIdentifier: "Notes")
        
        fontsize =  UserDefaults.standard.integer(forKey: "FontSize")
        if fontsize == 0 { fontsize = 17 }
        
        self.SecondaryBook = SecondLanguage.shared.BookList()
        self.PrimaryBook = BibleContent.sharedInstance.BookToList()
        
        
         self.PlaceHolderImg.image = UIImage(named: "\(coreTitle!).png")
        self.AlertLbl.isHidden = false
        if corevalue.count > 0 && coreTitle! == "BookMark" {
            self.PlaceHolderImg.isHidden = true
            self.AlertLbl.isHidden = true
        } else if corevalue.count > 0 && coreTitle! == "Highlites" {
            self.PlaceHolderImg.isHidden = true
            self.AlertLbl.isHidden = true
        } else if corevalue.count > 0 && coreTitle! == "Notes" {
            self.PlaceHolderImg.isHidden = true
            self.AlertLbl.isHidden = true
        } else if SearchTxt.count > 0 && coreTitle! == "search_PH" {
            self.PlaceHolderImg.isHidden = true
            self.AlertLbl.isHidden = true
        } else if corevalue.count > 0 && coreTitle! == "Underline" {
            self.PlaceHolderImg.isHidden = true
            self.AlertLbl.isHidden = true
        } else {
            self.SearchCollectionVu.isHidden = true
        }
        
        
        corevalueReverced = corevalue.reversed()
 
        
        DispatchQueue.main.async {
            self.SearchCollectionVu.collectionViewLayout.invalidateLayout()
            self.SearchCollectionVu.reloadData()
           }
        
    }
    
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
      }

      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        


        if SearchTxt.count != 0 {
            let seperatedValue:Array<String> =  self.SearchTxt[indexPath.row].components(separatedBy: "_")
            
            if SearchTxt.count <= 0 {
                LineCount =  seperatedValue[3].lines()
            } else {
                LineCount =  seperatedValue[0].lines()
            }
            return CGSize(width: self.SearchCollectionVu.frame.width , height: 60+(20*LineCount))
            
        } else {
            let seperatedValue:Array<String> =  self.corevalueReverced[indexPath.row].components(separatedBy: "_")
            if seperatedValue[2] != ""  && coreTitle == "Notes" {
                LineCount =  seperatedValue[3].lines()
                LineNote =  seperatedValue[2].Notelines()
                
                return CGSize(width: self.SearchCollectionVu.frame.width , height: 60+(20*LineCount)+((17*LineNote)+36))
            } else {
                LineCount = seperatedValue[3].lines()
                return CGSize(width: self.SearchCollectionVu.frame.width , height: 60+(20*LineCount))
            }
        }
      }
      
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.SearchTxt.count > 0 {
            return self.SearchTxt.count
        } else if self.corevalueReverced.count > 0 {
            return self.corevalueReverced.count
        } else {
           return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if SearchTxt.count != 0 {
            let cell = self.SearchCollectionVu!.dequeueReusableCell(withReuseIdentifier: "Search", for: indexPath) as! SearchCollectionView

            let seperatedValue:Array<String> =  self.SearchTxt[indexPath.row].components(separatedBy: "_")
            cell.DottedLines.addDashedLine()
            
            if SearchTxt.count <= 0 {
                cell.VerseLbl.text = seperatedValue[3] as String
                
                cell.VerseLbl.attributedText =  TextAttribute.shared.attributedTextBold(withString: seperatedValue[3], boldString: seperatedValue[3], font: UIFont(name:UserDefaults.standard.string(forKey: "FontName")!, size: 15)!, line: false, colorStatus: false, color: UIColor.clear)
                
            } else {

                
                cell.VerseLbl.textColor = (Themecolor == BGNightMode ? .white:.black)
                                
                let VersTitle = seperatedValue[1].replacingOccurrences(of: "-", with: ":")
                let Chapter = VersTitle.components(separatedBy: " ")
                let Chaptercontent = Chapter[Chapter.count-1]
                
                var BookNAme = ""
                
                for i in 0..<Chapter.count {
                    if i == 0 {
                        BookNAme.append(Chapter[i])
                        
                    } else if  i < Chapter.count-1 {
                        BookNAme.append(" \(Chapter[i])")
                    }
                }
                                
            
                
                
                let SecondTitle = self.SecondaryBook[self.PrimaryBook.firstIndex(of: BookNAme) ?? 0]
                let VersContent = seperatedValue[0].replacingOccurrences(of: "\n\n", with: "\n\(SecondTitle) \(Chaptercontent)- ")
                
                cell.VerseLbl.attributedText = TextAttribute.shared.attributedTextBoldSearch(withString: "\(VersTitle)-\(VersContent)", boldString: "\(VersTitle)-", SecondaryString: "\(SecondTitle) \(Chaptercontent)-", ColorString: self.Searchstring, font:UIFont(name:UserDefaults.standard.string(forKey: "FontName")!, size: 15)!, line:false, colorStatus: false, color: UIColor.clear)
                
            }

            
            ImageTint.sharedInstance.imageTintcolorMethod(img: cell.menuImage, colorVu: (Themecolor == BGNightMode ? .white:.darkGray))
            cell.MenuBtn.tag = indexPath.row
            cell.MenuBtn.addTarget(self, action: #selector(CallMenu), for: .touchUpInside)

//            cell.DottedLines.addDashedBorderView()

            return cell

            
        } else {
            let seperatedValue:Array<String> =  self.corevalueReverced[indexPath.row].components(separatedBy: "_")
            
            let VerseTitle =  seperatedValue[0].replacingOccurrences(of: "-", with: " ")
            let Chapter = seperatedValue[0].components(separatedBy: "-")
            let Chaptercontent = Chapter[Chapter.count-1]
            let SecondTitle = self.SecondaryBook[self.PrimaryBook.firstIndex(of: seperatedValue[0].components(separatedBy: "-")[0]) ?? 0]
            let VersContent = seperatedValue[3].replacingOccurrences(of: "\n\n", with: "\n\(SecondTitle) \(Chaptercontent)- ")
 
            
            if seperatedValue[2] != ""  && coreTitle == "Notes" {

                let cell = self.SearchCollectionVu!.dequeueReusableCell(withReuseIdentifier: "Notes", for: indexPath) as! Notes

                cell.DottedLines.addDashedLine()
                
                if SearchTxt.count <= 0 {
                                    
                    print("VersContent :",VersContent)
                    

                 cell.VerseLbl.attributedText = TextAttribute.shared.attributedTextBoldSearch(withString: "\(VerseTitle)-\(VersContent)", boldString: "\(VerseTitle)-", SecondaryString: "\(SecondTitle) \(Chaptercontent)-", ColorString: self.Searchstring, font:UIFont(name:UserDefaults.standard.string(forKey: "FontName")!, size: 17)!, line:false, colorStatus: false, color: .clear)
                    
                    
                    
                    
                    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    
                
                    
                    
                } else {
                    cell.VerseTitle.text = seperatedValue[1].replacingOccurrences(of: "-", with: ":")
                    
                    cell.VerseLbl.attributedText =  TextAttribute.shared.attributedTextBold(withString: seperatedValue[0], boldString: seperatedValue[3], font: cell.VerseTitle.font, line: false, colorStatus: false, color: UIColor.clear)
                }
                
                
                cell.VerseLbl.textColor = (Themecolor == BGNightMode ? .white:.black)
                cell.VerseTitle.textColor = (Themecolor == BGNightMode ? .white:.black)
                cell.NoteLbl.textColor = (Themecolor == BGNightMode ? .white:.black)
                cell.NoteTitle.textColor = (Themecolor == BGNightMode ? .white:.black)
                cell.NoteLbl.text = seperatedValue[2]
                cell.Noteheight.constant = 17*LineNote
                cell.MenuBtn.tag = indexPath.row
                cell.MenuBtn.addTarget(self, action: #selector(CallMenu), for: .touchUpInside)
                cell.VerseTitle.font = UIFont(name:UserDefaults.standard.string(forKey: "FontName")!, size: 15)
                cell.VerseLbl.font = UIFont(name:UserDefaults.standard.string(forKey: "FontName")!, size: 17)
                
                ImageTint.sharedInstance.imageTintcolorMethod(img: cell.menuImage, colorVu: (Themecolor == BGNightMode ? .white:.darkGray))
                
                
                return cell

            } else {
                
                let cell = self.SearchCollectionVu!.dequeueReusableCell(withReuseIdentifier: "Search", for: indexPath) as! SearchCollectionView
                
                
                if SearchTxt.count <= 0 {
                    
                    cell.VerseLbl.attributedText = TextAttribute.shared.attributedTextBoldSearch(withString: "\(VerseTitle)-\(VersContent)", boldString: "\(VerseTitle)-", SecondaryString: "\(SecondTitle) \(Chaptercontent)-", ColorString: self.Searchstring, font:UIFont(name:UserDefaults.standard.string(forKey: "FontName")!, size: 17)!, line:false, colorStatus: false, color: .clear)
                    
                } else {
                    cell.VerseLbl.attributedText =  TextAttribute.shared.attributedTextBold(withString: seperatedValue[0], boldString: seperatedValue[3], font: UIFont(name:UserDefaults.standard.string(forKey: "FontName")!, size: 17)!, line: false, colorStatus: false, color: UIColor.clear)
                }

                cell.MenuBtn.tag = indexPath.row
                cell.MenuBtn.addTarget(self, action: #selector(CallMenu), for: .touchUpInside)
//                cell.VerseLbl.font = UIFont(name:UserDefaults.standard.string(forKey: "FontName")!, size: CGFloat(fontsize))
                
                
                if coreTitle! == "Highlites" {
                    
                    cell.VerseLbl.attributedText = TextAttribute.shared.attributedTextBoldSearch(withString: "\(VerseTitle)-\(VersContent)", boldString: "\(VerseTitle)-", SecondaryString: "\(SecondTitle) \(Chaptercontent)-", ColorString: self.Searchstring, font:UIFont(name:UserDefaults.standard.string(forKey: "FontName")!, size: 17)!, line:false, colorStatus: true, color: (seperatedValue[1] == "#000000" ? UIColor.clear: hexColorConvert.shared.hexStringToUIColor(hex: seperatedValue[1])))
                    
                } else if coreTitle! == "Underline" {
                    
                    cell.VerseLbl.attributedText = TextAttribute.shared.attributedTextBoldSearch(withString: "\(VerseTitle)-\(VersContent)", boldString: "\(VerseTitle)-", SecondaryString: "\(SecondTitle) \(Chaptercontent)-", ColorString: self.Searchstring, font:UIFont(name:UserDefaults.standard.string(forKey: "FontName")!, size: 17)!, line:true, colorStatus: false, color: .clear)
                }
                
                

                if coreTitle! == "Highlites" {
                    cell.VerseLbl.textColor = .black
                } else {
                    cell.VerseLbl.textColor = (Themecolor == BGNightMode ? .white:.black)
                }
                
                ImageTint.sharedInstance.imageTintcolorMethod(img: cell.menuImage, colorVu: (Themecolor == BGNightMode ? .white:.darkGray))
                
                cell.DottedLines.addDashedLine()

                return cell
            }
        }
        
    }

    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
      let attributedString = NSMutableAttributedString(string: string,
                                                 attributes: [NSAttributedString.Key.font: font])
      let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
      let range = (string as NSString).range(of: boldString, options: .caseInsensitive)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CGFloat(UserDefaults.standard.integer(forKey: "LineGap"))
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:range)
        
        attributedString.addAttribute(.foregroundColor, value: DefaultYellow as Any, range: range)
        attributedString.addAttributes(boldFontAttribute, range: range)
      return attributedString
    }
    
    
    
    @objc func CallMenu(sender: UIButton!) {
                
        let dic:[String: String]?
        if self.SearchTxt.count != 0 {
            
            App_Protocol.delegateSearch?.popupvuew(SelectedVerse: self.SearchTxt[sender.tag])
        } else {
            dic = ["CompleteVerseInfo": self.corevalueReverced[sender.tag], "TagSelected": self.coreTitle!]
            App_Protocol.delegateMyLibrary?.popupvuew(SelectedVerse: self.corevalueReverced[sender.tag], SelectedTag: self.coreTitle!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PopupData"),object: nil, userInfo: dic)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastContentOffset-10 > scrollView.contentOffset.y {
            NotificationCenter.default.post(name: Notification.Name("ScrollUp"), object: nil)
            
        } else if lastContentOffset < scrollView.contentOffset.y {
            NotificationCenter.default.post(name: Notification.Name("ScrollDown"), object: nil)
        }
        
        if scrollView.contentOffset.y >= 60 {
            lastContentOffset = scrollView.contentOffset.y
        }
    }
}




extension String
{
    var digitString: String { filter { ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ").contains($0) } }
}
