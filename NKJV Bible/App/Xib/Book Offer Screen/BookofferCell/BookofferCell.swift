//
//  BookofferCell.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 01/06/24.
//

import UIKit

class BookofferCell: UICollectionViewCell {

    @IBOutlet weak var BookImg:UIImageView!
    
    @IBOutlet weak var BookImgHeight: NSLayoutConstraint!
    @IBOutlet weak var BookImgWidth: NSLayoutConstraint!
    
    @IBOutlet weak var ImgBg:UIView!
    @IBOutlet weak var Offerlbl:UILabel!
    @IBOutlet weak var BgHeight: NSLayoutConstraint!
    @IBOutlet weak var BgWidth: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
