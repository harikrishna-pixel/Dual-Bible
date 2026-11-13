//
//  SettingAlert.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 23/08/23.
//

import UIKit

class SettingAlert: NSObject {

    static func GallaryPermission(SorceVc:UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: "Please enable permission to access gallery \n Select 'All photo' " , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
                }))
                alert.addAction(UIAlertAction(title: "Settings", style: .default, handler:{ (UIAlertAction)in
                    SettingNavigate.sharedInstance.settingsNavigate()
                }))
            
            alert.popoverPresentationController?.sourceView = SorceVc.view
            SorceVc.present(alert, animated: true, completion: {
                })
        }
        
    }
    
    
}
