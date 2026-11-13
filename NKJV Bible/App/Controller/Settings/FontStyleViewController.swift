//
//  FontStyleViewController.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 13/12/22.
//

import UIKit

class FontStyleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var FontViewTable: UITableView!
    @IBOutlet weak var BannerVu: UIView!
    
    @IBOutlet weak var FontViewSizeSlider: UISlider!
    @IBOutlet weak var FontLabel: UILabel!
    @IBOutlet weak var FontSizeLabel: UILabel!
    @IBOutlet weak var SelectedFont: UILabel!
    @IBOutlet weak var BannerConstrain: NSLayoutConstraint!
    
     
    
    @IBOutlet weak var LineGapSlider: UISlider!
    @IBOutlet weak var LineGapLbl: UILabel!
    
    
    let Themecolor = UserDefaults.standard.color(forKey: "AppThemeColor")!
    
    let labelContent = "Please adjust to your preferred reading size below."
    var FontTableCell: FontCell?
    var FontListArray:Array<String> = []
    var SubFont:Array<String> = []
    var DefaultFontname:String?
    var Fontsize: CGFloat = 17.0
    var LineGap: CGFloat = 4.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        BannerVu.backgroundColor = (Themecolor == BGNightMode ? DarkModeColor:Themecolor)
        
        self.FontViewTable.backgroundColor = (Themecolor == BGNightMode ? BGNightMode:.white)
        self.view.backgroundColor = (Themecolor == BGNightMode ? BGNightMode:.white)
        self.SelectedFont.textColor  = (Themecolor == BGNightMode ? .white:.darkGray)
        
        self.BannerConstrain.constant = (StatusbarHeight > 30 ? 90:70)
        
        
        self.FontViewTable.register(UINib(nibName: "FontCell", bundle: nil), forCellReuseIdentifier: "Font")
        self.FontList()
        self.DefaultFontname = UserDefaults.standard.string(forKey: "FontName")
                
        let FontIndex = self.FontListArray.firstIndex(of: self.DefaultFontname!)
        let indexPaths = NSIndexPath(row:FontIndex!, section: 0)
        self.FontViewTable.scrollToRow(at: indexPaths as IndexPath, at: UITableView.ScrollPosition.middle, animated: true)
         
        self.FontViewSizeSlider.value = Float(UserDefaults.standard.integer(forKey: "FontSize"))
        self.FontSizeLabel.text = "Font Size : \(UserDefaults.standard.integer(forKey: "FontSize"))"
        
//        self.FontLabel.font = UIFont(name: UserDefaults.standard.string(forKey: "FontName")!, size: CGFloat(self.FontViewSizeSlider.value))
        self.FontViewSizeSlider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        
        
        self.FontLabel.attributedText = TextAttribute.shared.attributedLineGap(withString: labelContent, boldString: labelContent, font: UIFont(name: UserDefaults.standard.string(forKey: "FontName")!, size: CGFloat(self.FontViewSizeSlider.value))!)
        
        
        
        self.LineGapSlider.value = Float(UserDefaults.standard.integer(forKey: "LineGap"))
        self.LineGapLbl.text = "Line Gap : \(UserDefaults.standard.integer(forKey: "LineGap"))"
        self.LineGapSlider.addTarget(self, action: #selector(onSliderLineGapChanged(slider:event:)), for: .valueChanged)
        
    }
    
    func FontList() {
        Text_List.sharedInstance.TextList()
        self.FontListArray = Text_List.sharedInstance.MAinfont
        self.SubFont = Text_List.sharedInstance.Subfont
        
  
        self.FontViewTable.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.FontListArray.count
      }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
      {
        
        self.FontTableCell = self.FontViewTable.dequeueReusableCell(withIdentifier: "Font") as? FontCell
        
            self.FontTableCell!.FontLabel.text = self.FontListArray[indexPath.row]
            self.FontTableCell!.FontLineVu.backgroundColor = .systemGray4
        
        if self.FontListArray[indexPath.row] == "OTHER FONTS" {
            self.FontTableCell!.selectionStyle = UITableViewCell.SelectionStyle.none
            self.FontTableCell!.FontLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
            self.FontTableCell!.FontLabel.textColor = UIColor.darkGray
            
        } else  {
            self.FontTableCell!.FontLabel.font = UIFont(name:self.FontListArray[indexPath.row], size: 15)
        }

          if DefaultFontname == self.FontListArray[indexPath.row] {
                self.FontTableCell!.FontImage.isHidden = false
            } else {
                self.FontTableCell!.FontImage.isHidden = true
            }
        return self.FontTableCell!
      }

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if self.FontListArray[indexPath.row] != "OTHER FONTS" {
        self.DefaultFontname = self.FontListArray[indexPath.row]
        UserDefaults.standard.set(DefaultFontname, forKey: "FontName")
        UserDefaults.standard.set(self.SubFont[indexPath.row], forKey: "SubFontName")
        self.FontViewTable.deselectRow(at: indexPath, animated: true)
        self.FontViewTable.reloadData()
        self.FontLabel.font = UIFont(name: UserDefaults.standard.string(forKey: "FontName")!, size: CGFloat(self.FontViewSizeSlider.value))
        
        App_Protocol.delegateReaderSource?.ReloadFont(ChapterNo:UserDefaults.standard.integer(forKey: "BookChapter"))
    }    
}
    

    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}



@available(iOS 11.0, *)
extension FontStyleViewController  {
     
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:

                break
            case .moved:
                let fontValue = FontViewSizeSlider.value
                self.Fontsize = CGFloat(fontValue)
                
                self.FontLabel.attributedText = TextAttribute.shared.attributedLineGap(withString: labelContent, boldString: labelContent, font: UIFont(name: UserDefaults.standard.string(forKey: "FontName")!, size: self.Fontsize)!)
        
                self.FontSizeLabel.text = "Font Size : \(Int(self.Fontsize))"
                UserDefaults.standard.set(self.Fontsize, forKey: "FontSize")
                break
            case .ended:
                App_Protocol.delegateReaderSource?.ReloadFont(ChapterNo:UserDefaults.standard.integer(forKey: "BookChapter"))
                break
            default:
                break
            }
        }
    }
    
    
    
    
    
    @objc func onSliderLineGapChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:

                break
            case .moved:
                let fontValue = LineGapSlider.value
                self.LineGap = CGFloat(fontValue)
                
                self.FontLabel.attributedText = TextAttribute.shared.attributedLineGap(withString: labelContent, boldString: labelContent, font: UIFont(name: UserDefaults.standard.string(forKey: "FontName")!, size: CGFloat(UserDefaults.standard.integer(forKey: "FontSize")))!)
                
                self.LineGapLbl.text = "Line Gap : \(Int(self.LineGap))"
                  UserDefaults.standard.set(self.LineGap, forKey: "LineGap")
                break
            case .ended:
                App_Protocol.delegateReaderSource?.ReloadFont(ChapterNo:UserDefaults.standard.integer(forKey: "BookChapter"))
                break
            default:
                break
            }
        }
    }
    
    
    
}
    

