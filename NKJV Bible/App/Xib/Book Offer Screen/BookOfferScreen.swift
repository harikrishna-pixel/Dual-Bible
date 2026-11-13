//
//  BookOfferScreen.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 30/05/24.
//

import UIKit

class BookOfferScreen: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var Mainframe:UIView!
    @IBOutlet weak var BookImgCollectionview:UICollectionView!
    @IBOutlet weak var BookImgHeight: NSLayoutConstraint!
    @IBOutlet weak var BookImgLeading: NSLayoutConstraint!
    @IBOutlet weak var BookImgTrailing: NSLayoutConstraint!
    
    
    
    var AllMoreLink: [String] = []
    var SelectedPath: Int = 0

    var bookThumbURL: [String] = []
    var book_age: [String] = []
    var book_id: [String] = []
    var book_name: [String] = []
    var book_published_by: [String] = []
    var book_url: [String] = []
    var storeTitle: [String] = []
    var ImageHide:Bool = true
    
    
    
    override func draw(_ rect: CGRect) {
        self.Mainframe.layer.cornerRadius = 24
        self.Mainframe.layer.masksToBounds = true

        self.BookImgCollectionview.delegate = self
        self.BookImgCollectionview.dataSource = self
        
        self.BookImgCollectionview.register(UINib(nibName: "BookofferCell", bundle: nil), forCellWithReuseIdentifier: "BookofferCell")
        
        self.bookThumbURL.removeAll()
        self.book_age.removeAll()
        self.book_id.removeAll()
        self.book_name.removeAll()
        self.book_published_by.removeAll()
        self.book_url.removeAll()
        self.storeTitle.removeAll()
        self.BookImgHeight.constant =  (ScreenHeight/100)*90
        
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            self.BookImgHeight.constant =  (ScreenHeight/100)*70
            self.BookImgLeading.constant = (ScreenHeight/100)*12
            self.BookImgTrailing.constant = (ScreenHeight/100)*12
        } else {
            self.BookImgHeight.constant =  (ScreenHeight/100)*80
            self.BookImgLeading.constant = (ScreenHeight/100)*4
            self.BookImgTrailing.constant = (ScreenHeight/100)*4
        }

        
        
        for item in self.AllMoreLink {
            let itemSeperate = item.components(separatedBy: "####")
            self.bookThumbURL.append(itemSeperate[0])
            self.book_age.append(itemSeperate[1])
            self.book_id.append(itemSeperate[2])
            self.book_name.append(itemSeperate[3])
            self.book_published_by.append(itemSeperate[4])
            self.book_url.append(itemSeperate[5])
            self.storeTitle.append(itemSeperate[6])   
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.6) {
            self.ImageHide = false
            self.BookImgCollectionview.reloadData()
        }
        
    }
    
    
    
    @IBAction func GrabIt(_ sender: Any) {
        UIApplication.shared.open(URL(string: self.book_url[self.SelectedPath])!)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
            self.removeFromSuperview()
        }
    }
    
    @IBAction func Notnow(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    
    

}

extension BookOfferScreen {
    
    // MARK:- Collection view Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      }

      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: self.BookImgCollectionview.frame.width, height: BookImgCollectionview.frame.height)
      }
    
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.AllMoreLink.count
        }
    
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = (self.BookImgCollectionview.dequeueReusableCell(withReuseIdentifier: "BookofferCell", for: indexPath) as! BookofferCell)
            cell.ImgBg.BookShadow()
            cell.BookImg.layer.masksToBounds = true
            cell.BookImg.isHidden = ImageHide
            
            if let CoverImage = ImageLoader.getImageFromDir(imageName: self.bookThumbURL[indexPath.item], FolderName: "BookImageS") {
                cell.BookImg.image = CoverImage
            } else {
                cell.BookImg.image = UIImage(named: "bookplaceholder")
            }
             
            cell.BookImgHeight.constant = self.BookImgCollectionview.frame.height-40
            cell.BookImgWidth.constant = self.BookImgCollectionview.frame.width-50
            
            cell.BgHeight.constant = self.BookImgCollectionview.frame.height-40
            cell.BgWidth.constant = self.BookImgCollectionview.frame.width-50
            
            cell.Offerlbl.rotate(degrees: 330)
            
            return cell
        }
    
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        }

    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        
        let pageWidth: Float = Float(BookImgCollectionview.frame.width+10) // width + space

        let currentOffset = CGFloat(scrollView.contentOffset.x)
        let targetOffset = targetContentOffset.pointee.x
        var newTargetOffset: Float = 0
         
        if targetOffset > currentOffset-(ScreenWidth/3) {
            newTargetOffset = ceilf(Float(currentOffset) / pageWidth) * pageWidth
        } else {
            newTargetOffset = floorf(Float(currentOffset) / pageWidth) * pageWidth
        }
        
        if newTargetOffset < 0 {
            newTargetOffset = 0
        } else if CGFloat(newTargetOffset) > scrollView.contentSize.width {
            newTargetOffset = Float(scrollView.contentSize.width)
        }

        targetContentOffset.pointee.x = currentOffset
        scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: 0), animated: true)
                  
        self.SelectedPath = Int((newTargetOffset / pageWidth)+0.01)
    }
    
    
        
    
    
}


extension UILabel {
    func rotate(degrees: CGFloat) {
        rotate(radians: CGFloat.pi * degrees / 180.0)
    }

    func rotate(radians: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
}
