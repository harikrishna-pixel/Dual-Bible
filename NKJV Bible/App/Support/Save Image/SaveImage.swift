//
//  SaveImage.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 21/01/23.
//

import UIKit
import Photos
import AVFoundation


class SaveImage: NSObject {
    
    static let sharedInstance = SaveImage()
    
    var status: PHAuthorizationStatus?
      
    
    func Save(Mainview:UIViewController, saveImage:UIImage) {
        
        if #available(iOS 14, *) {
            status = PHPhotoLibrary.authorizationStatus(for: PHAccessLevel(rawValue: PHAccessLevel.RawValue(GETALL))!)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }
    
            switch self.status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status) in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {
                            self.ConvertIntoImage(Mainview:Mainview, saveImage: saveImage)
                              Mainview.view.makeToast("Image Saved Succesfully!", duration: 2.0, position: .bottom)
                        }
                        break
                    case .denied:
                        self.AlertVc(Mainview:Mainview)
                    default:
                      break
                    }
                })
            case .restricted:
                   self.AlertVc(Mainview:Mainview)
            case .denied:
                   self.AlertVc(Mainview:Mainview)
                break
            case .authorized:
                DispatchQueue.main.async {
                    self.ConvertIntoImage(Mainview:Mainview, saveImage: saveImage)
                      Mainview.view.makeToast("Image Saved Succesfully!", duration: 2.0, position: .bottom)
                }
                break
                
            case .limited:
                self.AlertVc(Mainview:Mainview)
                break
                
            default:
              break
            
            }
    }
    
    
    
    
    func ConvertIntoImage(Mainview:UIViewController, saveImage:UIImage) {
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.authorized) {
            DispatchQueue.main.async {
                CustomPhotoAlbum.sharedInstance.saveImage(image: saveImage)
                Mainview.view.makeToast("Image Saved Succesfully!", duration: 2.0, position: .bottom)
            }

        } else {
            Mainview.view.makeToast("Save Image now", duration: 2.0, position: .bottom)
        }
    }
    
    
    
    @objc func  AlertVc(Mainview:UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: "Please enable permission to access gallery \n Select 'All photo' " , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
                }))
                alert.addAction(UIAlertAction(title: "Settings", style: .default, handler:{ (UIAlertAction)in
                    SettingNavigate.sharedInstance.settingsNavigate()
                    
                }))


                // for iPad Support
            alert.popoverPresentationController?.sourceView = Mainview.view
              Mainview.present(alert, animated: true, completion: {
                })
        }
    }
    
    
    
}
