//
//  QuizAsViewController.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 28/02/23.
//

import UIKit


class QuizAsViewController: UIViewController {

    @IBOutlet weak var Loader: UIActivityIndicatorView!
    var LoadAdCatagory = ""
    var ResultAdReward:Bool = false
    
    //////////////////////////////////////////////////////////////////////////////////////////    Interstitial    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch LoadAdCatagory {
        case "INTERSTITIAL":
          
            break
        case "REWARDED":
          
            break
        default:
          
          break
        }
    }
    

    
    func CloseVc() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            self.dismiss(animated: true, completion: nil)
            QuizProtocol.QuizPaydelegate?.AdAmount(amount: UserDefaults.standard.integer(forKey: "WalletMoney"))
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
