//
//  SelectionViewController.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 18/01/23.
//

import UIKit

class SelectionViewController: UIViewController, QuizSelect {
    
    
    
    
    @IBOutlet weak var BookView: UIView!
    @IBOutlet weak var ChapterView: UIView!
    
    
    @IBOutlet weak var BookSelect: UIView!
    @IBOutlet weak var ChapterSelect: UIView!
    @IBOutlet weak var EasySelect: UIView!
    @IBOutlet weak var MediumSelect: UIView!
    @IBOutlet weak var HardSelect: UIView!
    
    @IBOutlet weak var EasyTxt: UILabel!
    @IBOutlet weak var MediumTxt: UILabel!
    @IBOutlet weak var HardTxt: UILabel!
    
    
    @IBOutlet weak var BookListVu: UIView!
    @IBOutlet weak var ChapterListVu: UIView!
    
    
    @IBOutlet weak var BookTxt:UILabel!
    @IBOutlet weak var ChapterTxt:UILabel!
    
    
    @IBOutlet weak var EasyBtn: UIButton!
    @IBOutlet weak var MediumBtn: UIButton!
    @IBOutlet weak var HardBtn: UIButton!
    @IBOutlet weak var BlankAlert: UILabel!
    @IBOutlet weak var Start: UIButton!
    
    
    @IBOutlet weak var LogoImage: UIImageView!
    @IBOutlet weak var TitleLbl: UILabel!
    
    @IBOutlet weak var BannerVu: UIView!
    @IBOutlet weak var BannerConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var WalletMoney: UILabel!

    
    weak var BookCell :BookList?
    weak var ChapterCell :Chapter?
    var ChapterCount :Int = 0
    
    var ChapterString :String = ""
    var BookString :String = ""
    
    var Level :String = "Easy"
    var Themecolor:UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if UserDefaults.standard.integer(forKey: "QuestionList") == 0 {
            UserDefaults.standard.setValue(10, forKey: "QuestionList")
        }
        
        QuizProtocol.QuizSelectdelegate = self  
        
        self.Themecolor = UserDefaults.standard.color(forKey: "AppThemeColor")!
        
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.LogoImage!, colorVu: ((Themecolor == BGNightMode ? DarkModeColor:Themecolor)!))
        self.TitleLbl.textColor = self.Themecolor
        
        
        self.BannerConstrain.constant = (StatusbarHeight > 30 ? 90:70)
        BannerVu.backgroundColor = (Themecolor == BGNightMode ? DarkModeColor:Themecolor)
        self.WalletMoney.text =  "\(UserDefaults.standard.integer(forKey: "WalletMoney"))"
        self.BlankAlert.textColor = self.Themecolor
        
        if !UserDefaults.standard.bool(forKey: "NotFirstTime") {
            UserDefaults.standard.set(1000, forKey: "WalletMoney")
            UserDefaults.standard.set(true, forKey: "NotFirstTime")
        }

        
        if !UserDefaults.standard.bool(forKey: "FirstTime") {
            UserDefaults.standard.set(true, forKey: "MusicSwitch")
            UserDefaults.standard.set(true, forKey: "ToneSwitch")
            UserDefaults.standard.set(true, forKey: "VibSwitch")
            UserDefaults.standard.set(true, forKey: "FirstTime")
        }
        
        
        self.BookSelect.ViewShadow(6, color: UIColor.darkGray)
        self.ChapterSelect.ViewShadow(6, color: UIColor.darkGray)
        
        
        self.BookListVu.ViewShadow(6, color: UIColor.darkGray)
        self.ChapterListVu.ViewShadow(6, color: UIColor.darkGray)
        self.BookView.ViewShadow(6, color: UIColor.darkGray)
        self.ChapterView.ViewShadow(6, color: UIColor.darkGray)
        self.EasySelect.ViewShadow(6, color: UIColor.darkGray)
        self.MediumSelect.ViewShadow(6, color: UIColor.darkGray)
        self.HardSelect.ViewShadow(6, color: UIColor.darkGray)
        
        
        let TextInfo = App_Protocol.delegateReaderSource?.GetTSData()

        self.EasySelect.backgroundColor = self.Themecolor
        self.EasyTxt.textColor = UIColor.white
        self.Start.backgroundColor = self.Themecolor

        if ChapterString != "" {
            self.BookTxt.text = BookString
            self.ChapterTxt.text = ChapterString
            self.Start.isHidden = false
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.WalletMoney.text =  "\(UserDefaults.standard.integer(forKey: "WalletMoney"))"
    }
    
    
    @IBAction func BookListAction(_ sender: Any) {
        self.BookOpenClose()
    }
    
    
    
    func BookOpenClose() {
        
        if self.BookListVu.isHidden {
            self.BookListVu.isHidden = false
            self.ChapterListVu.isHidden = true
             
            self.BookCell = BookList.fromNib(named: "BookList")
            self.BookCell!.frame = self.BookListVu!.bounds
            self.BookCell!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.BookListVu!.addSubview(self.BookCell!)
//            self.BookListVu!.ViewBorder(color: self.Themecolor!)
            
        } else {
            self.BookListVu.isHidden = true
            self.BookCell?.removeFromSuperview()
        }
    }
    
    
    
    func Selection(BookCount:String) {
        
        self.BookTxt.text = BookCount.components(separatedBy: "-")[0]
        self.ChapterCount = Int(BookCount.components(separatedBy: "-")[1])!
        self.ChapterTxt.text = "Chapter"
        self.Start.isHidden = true
        self.BookOpenClose()
        self.ChapterOpenClose()
        
    }
    
    
    func ChapterSelection(Chapter: String) {
        self.ChapterTxt.text = Chapter
        self.ChapterOpenClose()
        self.Start.isHidden = false
    }
    
    
    @IBAction func ChapterListAction(_ sender: Any) {
        self.ChapterOpenClose()
    }
    
    
    
    func ChapterOpenClose() {
        if self.ChapterListVu.isHidden && self.BookTxt.text != "Book" {
            self.ChapterListVu.isHidden = false
            
            self.ChapterCell = Chapter.fromNib(named: "Chapter")
            self.ChapterCell!.frame = self.ChapterListVu!.bounds
            self.ChapterCell!.ChapterCount = self.ChapterCount
            self.ChapterCell!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.ChapterListVu!.addSubview(self.ChapterCell!)
//            self.ChapterListVu!.ViewBorder(color: self.Themecolor!)
            
        } else {
            self.ChapterListVu.isHidden = true
            self.BookCell?.removeFromSuperview()
            if self.BookTxt.text == "Book" {
                self.view.makeToast("Please select Book first", duration: 2.0, position: .bottom)
            }
        } 
    }
    
    
    @IBAction func Level_Action(sender: UIButton) {
        
        self.EasySelect.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.MediumSelect.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.HardSelect.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        self.EasyTxt.textColor = UIColor.black
        self.MediumTxt.textColor = UIColor.black
        self.HardTxt.textColor = UIColor.black
        
        
        switch sender {
        case EasyBtn:
            self.EasySelect.backgroundColor = self.Themecolor
            self.EasyTxt.textColor = UIColor.white
            self.Level = "Easy"
            self.BlankAlert.text = "2 Blanks to fill"
            
        case MediumBtn:
            self.MediumSelect.backgroundColor = self.Themecolor
            self.MediumTxt.textColor = UIColor.white
            self.Level = "Medium"
            self.BlankAlert.text = "4 Blanks to fill"
            
        case HardBtn:
            self.HardSelect.backgroundColor = self.Themecolor
            self.HardTxt.textColor = UIColor.white
            self.Level = "Hard"
            self.BlankAlert.text = "6 Blanks to fill"
            
        default:
            break

        }

    }
    
    
    
    
    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Start(_ sender: Any) {
        

        let vc = kStoryboardQuizIphone.instantiateViewController(withIdentifier: "QuizMainPageVC") as! QuizMainPageVC
        vc.level = self.Level
        vc.BookName = self.BookTxt.text!
        vc.Chapter = Int(self.ChapterTxt.text!)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
    @IBAction func Settings_Action(_ sender: Any) {
        
        let vc = kStoryboardQuizIphone.instantiateViewController(withIdentifier: "QuizSettingVC") as! QuizSettingVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func Wallet_Action(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                    let vc = kStoryboardQuizIphone.instantiateViewController(withIdentifier: "QuizWalletVC") as! QuizWalletVC
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: true, completion: nil)
            }
    }
      

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
