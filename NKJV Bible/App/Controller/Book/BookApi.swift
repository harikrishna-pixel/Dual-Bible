//
//  BookApi.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 03/06/24.
//

import UIKit


class BookApi: NSObject {
    static let shared = BookApi()
    
    var BookDictionary: Array<Dictionary<String, AnyObject>> = []
    
    func GetBookCatagory() {
           print("book_ads_app_id :",UserDefaults.standard.integer(forKey: "book_ads_app_id"))
        
        if UserDefaults.standard.integer(forKey: "book_ads_app_id") > 0 {
            let parameters:Dictionary<String, AnyObject> = ["book_app_id": UserDefaults.standard.integer(forKey: "book_ads_app_id") as AnyObject]
            
            if NetworkManager.sharedInstance.isConnectedToInternet() {
                NetworkManager.sharedInstance.ImageFromGallery(urlString: "https://saveigm.com/bookads/admin/api/book/book_cat_list_by_app", params: parameters, completion: {(resultDictionary, error) -> () in
                    
                    if let Result:Dictionary<String, AnyObject> = resultDictionary {
                        let BookApiDictionary = Result["data"] as! Array<Dictionary<String, AnyObject>>
                        let categoryId:[String] =  BookApiDictionary.map({$0["categoryId"] as! String})
                        self.GetBooksLink(book_cat_id_List: categoryId)
                    }
                })
            }
        }
    }
    
    
    func GetBooksLink(book_cat_id_List:[String]) {
        
        DispatchQueue.main.async {
            self.BookDictionary.removeAll()
            CoreDataModel.sharedInstance.deleteAllData(CDMoreBookApi)
            self.DeleteAllImages(Folder: "BookImageS")
        }
        
        
        var LoopPosition = 0
        BookLoop()
        
        
        func BookLoop() {
            GetBookLoop(book_cat_id:book_cat_id_List[LoopPosition])
        }
        
        
        func GetBookLoop(book_cat_id:String) {
            
            let parameters:Dictionary<String, AnyObject> = ["book_cat_id": book_cat_id as AnyObject]
            NetworkManager.sharedInstance.ImageFromGallery(urlString: "https://saveigm.com/bookads/admin/api/book/book_list_by_cat", params: parameters, completion: {(resultDictionary, error) -> () in
                
                if let Result:Dictionary<String, AnyObject> = resultDictionary {
                    self.BookDictionary.append(contentsOf: Result["data"] as! Array<Dictionary<String, AnyObject>>)
                        LoopPosition = LoopPosition+1
                    if LoopPosition < book_cat_id_List.count {
                        BookLoop()
                    } else if LoopPosition >= book_cat_id_List.count {
                        self.SaveAllData(BookDictionary: self.BookDictionary, completion: {bookThumbURL,_  in
                            self.SaveimageInDirectory(bookThumbURL: bookThumbURL, Folder: "BookImageS")
                        })
                    }
                }
            })
        }
    }
    
        
    func SaveAllData(BookDictionary: Array<Dictionary<String, AnyObject>>, completion:@escaping (_ BookImgUrl:[String], _ error:Error?) -> ()) {
        
        DispatchQueue.main.async {
            guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appdelegate.persistentContainer.viewContext
            
            DispatchQueue.main.async {
                CoreDataModel.sharedInstance.deleteAllData(CDMoreBookApi)
                self.DeleteAllImages(Folder: "BookImageS")
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
                for item in BookDictionary {
                    let imagePath = (item["bookThumbURL"] as! String).components(separatedBy: "/")
                    CoreDataModel.sharedInstance.MoreBookShare(CDMoreBookApi,
                                                               appdelegate: appdelegate,
                                                               managedContext: managedContext,
                                                               bookThumbURL: imagePath[imagePath.count-1],
                                                               book_age: Int16(item["book_age"] as! String)!,
                                                               book_description: item["book_description"] as! String,
                                                               book_id: Int16(item["book_id"] as! String)!,
                                                               book_name: item["book_name"] as! String,
                                                               book_published_by: item["book_published_by"] as! String,
                                                               book_url: item["book_url"] as! String,
                                                               storeTitle: item["storeTitle"] as! String)
                }
                completion(BookDictionary.map({$0["bookThumbURL"] as! String}), nil)
            }
        }
    
    }
    
    
    
    
    
    
    func SaveimageInDirectory(bookThumbURL:[String], Folder:String) {
        var LoopPosition = 0
                
        DownloadImage(ImagePosition: LoopPosition)
        
        func DownloadImage(ImagePosition:Int) {
            DispatchQueue.main.async {
                if let imageURL:URL = URL(string: bookThumbURL[ImagePosition]) {
                    ImageLoader.image(for: imageURL) { image in
                        if self.saveImageInDocsDir(ImageNAme: imageURL.lastPathComponent, image: image!, Folder: Folder) {
                            LoopPosition = LoopPosition+1
                            if LoopPosition < bookThumbURL.count {
                                DownloadImage(ImagePosition:LoopPosition)
                            } else {
                                self.GetMorApp(completion: {AppImgUrl,error in
                                    self.SaveMorAppimageInDirectory(bookThumbURL: AppImgUrl, Folder: "AppimageS")
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    //=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
    //=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
    //=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
    
    
    
    
    func GetMorApp(completion:@escaping (_ AppImgUrl:[String], _ error:Error?) -> ()) {
        let parameters:Dictionary<String, AnyObject> = ["package_name": APPLE_ID as AnyObject]
        
        NetworkManager.sharedInstance.ImageFromGallery(urlString: GETMOREAPPLIST, params: parameters, completion: {(resultDictionary, error) -> () in
             
            if let Result:Dictionary<String, AnyObject> = resultDictionary {
                DispatchQueue.main.async {
                    CoreDataModel.sharedInstance.deleteAllData(CDMoreAppApi)
                    self.DeleteAllImages(Folder: "AppimageS")
                }
                let BookApiDictionary = Result["data"] as! Array<Dictionary<String, AnyObject>>
               
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
                    guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                    let managedContext = appdelegate.persistentContainer.viewContext
                    
                    
                    for item in BookApiDictionary {
                        let imagePath = (item["thumburl"] as! String).components(separatedBy: "/")
                        CoreDataModel.sharedInstance.MoreAppApi(CDMoreAppApi,
                                                                appdelegate: appdelegate,
                                                                managedContext: managedContext,
                                                                appId: Int16(item["appId"] as! String)!,
                                                                appName: item["appName"] as! String,
                                                                apptype: item["apptype"] as! String,
                                                                appurl: item["appurl"] as! String,
                                                                developed_by: item["developed_by"] as! String,
                                                                thumburl: imagePath[imagePath.count-1])
                    }
                    
                    completion(BookApiDictionary.map({$0["thumburl"] as! String}), nil)
                }
            }
        })
    }
    
    
    
    func DeleteAllImages(Folder: String) {
        
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        let folderPath = mainPath + "/\(Folder)/"

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: URL(string: folderPath)!,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for fileURL in fileURLs where fileURL.pathExtension == "jpg" {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch  { print(error) }
    }
    
    
    
    
    func SaveMorAppimageInDirectory(bookThumbURL:[String], Folder:String) {
        var LoopPosition = 0
        
        DownloadImage(ImagePosition: LoopPosition)
        
        func DownloadImage(ImagePosition:Int) {
            DispatchQueue.main.async {
                if bookThumbURL.count > ImagePosition {
                    if let imageURL:URL = URL(string: bookThumbURL[ImagePosition]) {
                        ImageLoader.image(for: imageURL) { image in
                            if self.saveImageInDocsDir(ImageNAme: imageURL.lastPathComponent, image: image!, Folder: Folder) {
                                LoopPosition = LoopPosition+1
                                if LoopPosition < bookThumbURL.count {
                                    DownloadImage(ImagePosition:LoopPosition)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    //=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
    //=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
    //=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
    
    

    
    func saveImageInDocsDir(ImageNAme:String, image: UIImage, Folder:String) -> Bool {
        var objCBool: ObjCBool = true
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        let folderPath = mainPath + "/\(Folder)/"

        let isExist = FileManager.default.fileExists(atPath: folderPath, isDirectory: &objCBool)
        if !isExist {
            do {
                try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }

        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageUrl = documentDirectory.appendingPathComponent("\(Folder)/\(ImageNAme)")
        if let data = image.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: imageUrl)
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    
    
    
}

