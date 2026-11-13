//
//  QuizWalletVC.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 28/02/23.
//

import UIKit


class QuizWalletVC: UIViewController, UITableViewDelegate, UITableViewDataSource, QuizPay {
    
    
    @IBOutlet weak var BannerVu: UIView!
    @IBOutlet weak var BannerConstrain: NSLayoutConstraint!
    
    @IBOutlet var WalletCoin: UILabel!
    @IBOutlet var WalletTable: UITableView!
    
    let Themecolor = UserDefaults.standard.color(forKey: "AppThemeColor")!
    var QuizWalletCell: QuizWalletTableCell?
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.BannerConstrain.constant = (StatusbarHeight > 30 ? 90:70)
        BannerVu.backgroundColor = (Themecolor == BGNightMode ? DarkModeColor:Themecolor)
        
        self.WalletCoin.text = "\(UserDefaults.standard.integer(forKey: "WalletMoney"))"
        QuizProtocol.QuizPaydelegate = self
        
    }
    
    
    
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        QuizProtocol.QuizMaindelegate?.UpdatePay()
    }
    

    func AdAmount(amount: Int) {
        self.WalletCoin.text = "\(UserDefaults.standard.integer(forKey: "WalletMoney"))" 
    }
    
    
     // MARK:- Tableview Delegate
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 50
     }
     
     func numberOfSections(in tableView: UITableView) -> Int {
         return 2
     }
     
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 1
       }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         switch (indexPath.section) {
         
         case 0:
             
             self.QuizWalletCell = (self.WalletTable.dequeueReusableCell(withIdentifier: "DailyClaim") as! QuizWalletTableCell?)
               self.QuizWalletCell!.DailyVu.ViewShadow(0, color: UIColor.gray)
             return self.QuizWalletCell!
             
         case 1:
             
             self.QuizWalletCell = (self.WalletTable.dequeueReusableCell(withIdentifier: "QuizWalletCell") as! QuizWalletTableCell?)
               self.QuizWalletCell!.walletVu.ViewShadow(0, color: UIColor.gray)
             return self.QuizWalletCell!
             
         default: break
         }

         return self.QuizWalletCell!
       }
     

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.WalletTable.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section) {
        case 0:
            
            let vc = kStoryboardQuizIphone.instantiateViewController(withIdentifier: "QuizAsViewController") as! QuizAsViewController
            vc.LoadAdCatagory = "INTERSTITIAL"
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
            
        case 1:
            
            let vc = kStoryboardQuizIphone.instantiateViewController(withIdentifier: "QuizAsViewController") as! QuizAsViewController
            vc.LoadAdCatagory = "REWARDED"
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
            
        default:
          break
            
        }
    }
    
    
    func alertVu() {
        let alert = UIAlertController(title: "Alert", message: "Ad not available please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    

}


