//
//  ScoreBoardVC.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 21/03/23.
//

import UIKit

class ScoreBoardVC: UIViewController {

    @IBOutlet weak var BannerVu: UIView!
    @IBOutlet weak var BannerConstrain: NSLayoutConstraint!
    
    
    @IBOutlet weak var scoreVu: UIView!
    @IBOutlet weak var Slogan: UILabel!
    @IBOutlet weak var ClaimMoney: UIButton!
    @IBOutlet weak var ClaimMoneyimg: UIImageView!
    
    @IBOutlet weak var ScoreLbl: UILabel!
    @IBOutlet weak var ScoreCoins: UILabel!
    @IBOutlet weak var WalletMoney: UILabel!
//    @IBOutlet weak var ClickVu: UIView!


    let Themecolor:UIColor = UserDefaults.standard.color(forKey: "AppThemeColor")!
    
    var AnswerKeyWords:Dictionary<Int,Array<String>> = [:]
    var Score:Int = 0
    var LifeLine:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.BannerConstrain.constant = (StatusbarHeight > 30 ? 90:70)
        BannerVu.backgroundColor = (Themecolor == BGNightMode ? DarkModeColor:Themecolor)
        self.ScoreLbl.text = "Score \(Score)/10"
        
        if self.Score >= 7 {
            self.ScoreCoins.text = "X \(Score)"
        } else {
            self.ScoreCoins.isHidden  = true
            self.ClaimMoney.isHidden = true
            self.ClaimMoneyimg.isHidden = true
        }
        
        self.Slogan.text = resultTxt(correct: Score)
        
        
        self.scoreVu.ViewBorder(color: Themecolor, radius: 20)
        self.WalletMoney.text = "\(UserDefaults.standard.integer(forKey: "WalletMoney"))"
        
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func Claim_Action(_ sender: Any) {
//        self.ClickVu.isHidden = false
        self.ClaimMoney.backgroundColor = UIColor.gray
        UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "WalletMoney")+(Score), forKey: "WalletMoney")
        QuizClickSound.shared.CoinCollectSound()
        self.WalletMoney.text = "\(UserDefaults.standard.integer(forKey: "WalletMoney"))"
    }
    
    
    
    @IBAction func ViewAnswer_Action(_ sender: Any) {
        
        let vc = kStoryboardQuizIphone.instantiateViewController(withIdentifier: "QuizAnswersVC") as! QuizAnswersVC
        vc.ShowResult = "Show"
        vc.AnswerKeyWords = self.AnswerKeyWords
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
    
    
    
    @IBAction func Back(_ sender: Any) {
        navigationController?.popToViewController(ofClass: SelectionViewController.self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func resultTxt(correct:Int) -> String {
        var Title = ""
        if correct <= 3 {
            Title = "Need Improvement"
            
        } else if correct == 4 {
            Title = "Try even better"
        } else if correct > 4 && correct <= 6 {
            Title = "Well- played!"
        }
        else if correct >= 7 &&  correct <= 9 {
            Title = "Great job!"
        } else {
            Title = "Excellent!"
        }
        return Title
    }
    
    

}
