//
//  ResultPopupVC.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 03/03/23.
//

import UIKit

class ResultPopupVC: UIViewController, ResultProtocol {
    
    @IBOutlet weak var BannerVu: UIView!
    @IBOutlet weak var BannerConstrain: NSLayoutConstraint!
    @IBOutlet weak var Question_Count: UILabel!
    @IBOutlet weak var Answe_Status: UILabel!
    
    @IBOutlet weak var AnswerView: UIView!
    @IBOutlet weak var MainView: UIView!
    
    @IBOutlet weak var AnswerLbl: UILabel!
    @IBOutlet weak var QuestionLbl: UILabel!
    @IBOutlet weak var CloseBtn: UIButton!
    
    @IBOutlet weak var TryBtn: UIButton!
    @IBOutlet weak var ShowBtn: UIButton!
    @IBOutlet weak var NextLbl: UILabel!
    
    
    @IBOutlet weak var TryVu: UIView!
    @IBOutlet weak var ShowVu: UIView!
    
    @IBOutlet weak var OK: UIButton!
    
    @IBOutlet weak var life1: UIImageView!
    @IBOutlet weak var life2: UIImageView!
    @IBOutlet weak var life3: UIImageView!
    
    
    @IBOutlet weak var Coins: UILabel!
    @IBOutlet weak var progresConstrain: NSLayoutConstraint!
    @IBOutlet weak var ProgressBar: UIView!
    @IBOutlet weak var ProgressInnerBar: UIView!

    
    
    
    let Themecolor = UserDefaults.standard.color(forKey: "AppThemeColor")!
    
    var AnsCount:Int = 0
    var QuesCount:Int = 0
    var AnsStatus:Bool = false
    
    var AnswerStr:String = ""
    var QuestionStr:String = ""
    var CorrectAnswers:[String] = []
    var Blank:[String] = []
    var WrongAnswer:[String] = []
    var LifeLine:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        self.Question_Count.text =  "Question \(AnsCount)/\(QuesCount)"
        self.Answe_Status.text = (AnsStatus ? "Correct":"Wrong")
        
        if AnsStatus {
            QuizClickSound.shared.CorrectSound()
        } else {
            QuizClickSound.shared.WrongSound()
        }
        
        self.TryVu.isHidden = AnsStatus
        self.ShowVu.isHidden = AnsStatus
        
        self.life1.image = UIImage(named: (LifeLine >= 1 ? "heart.png":"FadeHeart.png"))
        self.life2.image = UIImage(named: (LifeLine >= 2 ? "heart.png":"FadeHeart.png"))
        self.life3.image = UIImage(named: (LifeLine >= 3 ? "heart.png":"FadeHeart.png"))
        
        
        self.CloseBtn.backgroundColor = Themecolor
        self.Coins.text = "\(UserDefaults.standard.integer(forKey: "WalletMoney"))"
        
         
        
        for i in 0 ..< Blank.count {
            
            if Blank[i] != CorrectAnswers[i] {
                WrongAnswer.append(Blank[i])
            }
        }
        
        if LifeLine == 0 || AnsCount == 10 {
            self.NextLbl.text = "End Round"
        } else {
            self.NextLbl.text = "Next Question"
        }
        
        
        self.OK.layer.cornerRadius = 17
        self.OK.layer.masksToBounds = true
        
        self.ProgressBar.layer.borderColor = Themecolor.cgColor
        self.ProgressBar.layer.borderWidth = 1
        self.ProgressInnerBar.backgroundColor = Themecolor
         
        
        self.TryBtn.isHidden = AnsStatus
        self.ShowBtn.isHidden = AnsStatus
        
        
        self.AnswerLbl.attributedText = attributedTextBold(withString: self.AnswerStr, boldString: self.AnswerStr, font: UIFont(name:"Al Nile", size: 15)!, underlineValue: CorrectAnswers, Wrong: [])
        
        self.QuestionLbl.attributedText = attributedTextBold(withString: self.QuestionStr, boldString: self.QuestionStr, font: UIFont(name:"Al Nile", size: 15)!, underlineValue: Blank, Wrong: WrongAnswer)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.progresConstrain.constant = CGFloat(QuesCount-AnsCount)*(self.ProgressBar.frame.width/CGFloat(QuesCount))
    }
    
    
    @IBAction func TryAgain_Action(_ sender: Any) {
        QuizProtocol.QuizMaindelegate?.tryAgain()
        self.dismiss(animated: true, completion: nil)
        
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
//                let vc = kStoryboardQuizIphone.instantiateViewController(withIdentifier: "QuizAsViewController") as! QuizAsViewController
//                vc.LoadAdCatagory = "REWARDED"
//                vc.ResultAdReward = true
//                vc.modalPresentationStyle = .overCurrentContext
//                vc.modalTransitionStyle = .crossDissolve
//                self.present(vc, animated: true, completion: nil)
//        }
    }
    
    
    func NavigateBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ShowAnswer_Action(_ sender: Any) {
        UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "WalletMoney")-15, forKey: "WalletMoney")
        self.MainView.isHidden = false
    }
    
    @IBAction func ShowAnswerClose_Action(_ sender: Any) {
        self.MainView.isHidden = true
    }
    
    
    @IBAction func Next_Action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        QuizProtocol.QuizMaindelegate?.nextCall_Action()
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
    
    
    
    
    func attributedTextBold(withString string: String, boldString: String, font: UIFont, underlineValue:[String], Wrong:[String]) -> NSAttributedString {
        
      let attributedString = NSMutableAttributedString(string: string)
        
      let FontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
      let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6.0
         
      let range = (string as NSString).range(of: boldString, options: .caseInsensitive)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:range)
        attributedString.addAttributes(FontAttribute, range: range)
                
        
        for item in underlineValue {
            let range1 = (string as NSString).range(of: item, options: .caseInsensitive)
            attributedString.addAttributes(FontAttribute, range: range1)
            
            let TextBold: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name:"Cera Pro Bold", size: 15)!]
            var ForegroundColor: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: QuizGreen]
             
            if Wrong.contains(item) {
                ForegroundColor = [NSAttributedString.Key.foregroundColor: UIColor.red]
            }
            
            
            attributedString.addAttributes(ForegroundColor, range: range1)
            attributedString.addAttributes(TextBold, range: range1)
        }
                

                
      return attributedString
    }
    
    

}
