//
//  CustomPhotoAlbum.swift
//  Audio Bible
//
//  Created by Axeraan Technologies on 11/03/21.
//

import UIKit
import Photos

class CustomPhotoAlbum {

    static let albumName = APPNAME
    static let sharedInstance = CustomPhotoAlbum()
    
    var photo: UIImage!
    var photoPHAsset: Array<Any> = []
    var photoPHAssetArray: Array<PHAsset> = []
    var assetCollection: PHAssetCollection!
    var images:Array<UIImage> = []

    init() {
        
        
        func fetchAssetCollectionForAlbum() -> PHAssetCollection! {

            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
            fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
            let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            
            
            if let firstObject: AnyObject = collection.firstObject {
                return (collection.firstObject!)
            }

            return nil
        }

        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }

        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CustomPhotoAlbum.albumName)
        }) { success, _ in
            if success {
                self.assetCollection = fetchAssetCollectionForAlbum()
            }
        }
    }

    func saveImage(image: UIImage) {

        if assetCollection == nil {
            return   // If there was an error upstream, skip the save.
        }

        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
            albumChangeRequest!.addAssets([assetPlaceholder] as NSFastEnumeration)
        }, completionHandler: nil)
    }
    
    

    // MARK:- Delete Album
    func deleteAlbum(albumName: String) {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "title = %@", albumName)
        let album = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)

        // check if album is available
        if album.firstObject != nil {

            // request to delete album
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.deleteAssetCollections(album)
        }, completionHandler: { (success, error) in
            if success {
                print(" \(albumName) removed succesfully")
            } else if error != nil {
                print("request failed. please try again")
            }
        })
        } else {
            print("requested album \(albumName) not found in photos")
        }
    }
    
  
    

    func deleteSelectedPhotoFromGallery(ImageIndex:Int) {
       PHPhotoLibrary.shared().performChanges({
          guard let request = PHAssetCollectionChangeRequest(for: self.assetCollection) else {
                return
            }
           if ImageIndex < 0 {
               return
           }
        let asset:PHAsset = self.photoPHAssetArray[ImageIndex]
//        request.removeAssets([asset] as NSArray)
        request.removeAssets(at: IndexSet([ImageIndex]))
        }) { (result, error) in
            
            
        }
        
    }
    
    
    

    
    func fetchCustomAlbumPhotos()
    {
        var assetCollection = PHAssetCollection()
        var albumFound = Bool()
        var photoAssets = PHFetchResult<AnyObject>()
        let fetchOptions = PHFetchOptions()

        fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

        if let firstObject = collection.firstObject {
            //found the album
            assetCollection = firstObject
            albumFound = true
        }
        else { albumFound = false }
        _ = collection.count
        photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil) as! PHFetchResult<AnyObject>
        let imageManager = PHCachingImageManager()
        photoAssets.enumerateObjects{(object: AnyObject!,
            count: Int,
            stop: UnsafeMutablePointer<ObjCBool>) in

            if object is PHAsset{
                let asset = object as! PHAsset
                
                self.photoPHAssetArray.append(asset)
                self.photoPHAsset.append(asset)
                                
                let imageSize = CGSize(width: asset.pixelWidth,
                                       height: asset.pixelHeight)
                
                /* For faster performance, and maybe degraded image */
                let options = PHImageRequestOptions()
                options.deliveryMode = .highQualityFormat
//                options.deliveryMode = .fastFormat
                options.isSynchronous = true
                imageManager.requestImage(for: asset,
                                                  targetSize: imageSize,
                                                  contentMode: .aspectFit,
                                                  options: options,
                                                  resultHandler: {
                                                    (image, info) -> Void in
                                                                                                                                                    
                                                    
                                                    self.photo = image!
                                                    /* The image is now available to us */
                                                    self.addImgToArray(uploadImage: self.photo!)
                })
            }
        }
    }
    
    
    

    func addImgToArray(uploadImage:UIImage)
    {
        self.images.append(uploadImage)
    }
}



extension PHAsset {

    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}

