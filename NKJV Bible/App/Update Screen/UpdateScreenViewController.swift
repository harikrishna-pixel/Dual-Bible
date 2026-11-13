//
//  UpdateScreenViewController.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 02/02/23.
//

import UIKit


//let vc = kStoryboardMainIphone.instantiateViewController(withIdentifier: "ImageSliderVC") as! ImageSliderVC
//vc.SelectedCell = indexPath.row
//vc.modalPresentationStyle = .overCurrentContext
//vc.modalTransitionStyle = .crossDissolve
//self.present(vc, animated: true, completion: nil)

class UpdateScreenViewController: UIViewController {

    @IBOutlet weak var UpdateTxt: UILabel!
    @IBOutlet weak var Version: UILabel!
    @IBOutlet weak var PreviewImageWidth: NSLayoutConstraint!
    
    var UpdateAppLink = ""
    var UpdateVersion = ""
    var UpdateText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.PreviewImageWidth.constant = ScreenWidth-(ScreenWidth/4.2)
        
        self.Version.text = UpdateVersion
        self.UpdateTxt.text = UpdateText
        
    }
    

    
    @IBAction func UpdateAction(_ sender: Any) {
        UIApplication.shared.open(URL(string: UpdateAppLink)!)
    }
    

    
    
    @IBAction func TrylaterAction(_ sender: Any) {
        UserDefaults.standard.set(Date().string(format: "MMM d, yyyy"), forKey: "CurrentDate")
        self.dismiss(animated: true, completion: nil)
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




enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

