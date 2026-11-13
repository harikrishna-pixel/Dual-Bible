//
//  SettingsTableCell.swift
//  Audio Bible
//
//  Created by Axeraan Technologies on 11/02/21.
//

import UIKit

class SettingsTableCell: UITableViewCell {

    @IBOutlet var themeColor: UIView!
    @IBOutlet var FontStyle: UILabel!
    @IBOutlet var NotifiSwitch: UISwitch!
    @IBOutlet var NotifiTime: UILabel!
    
    @IBOutlet var Notifications: UILabel!
    @IBOutlet var Recent: UILabel!
    
    @IBOutlet var NotificationTime: UILabel!
    @IBOutlet var FontType: UILabel!
    @IBOutlet var Theme: UILabel!
    @IBOutlet var Feedback: UILabel!
    @IBOutlet var AboutUs: UILabel!
    @IBOutlet var RateUs: UILabel!
    @IBOutlet var MoreApp: UILabel!
    @IBOutlet var Help: UILabel!
    @IBOutlet var Quiz: UILabel!
    
    @IBOutlet var Notification: UILabel!
    @IBOutlet var FontTheme: UILabel!
    @IBOutlet var AboutApp: UILabel!
    @IBOutlet var Support: UILabel!
    
    @IBOutlet var arrow1: UIImageView!
    @IBOutlet var arrow2: UIImageView!
    @IBOutlet var arrow3: UIImageView!
    
    
    
    
    let Themecolor = UserDefaults.standard.color(forKey: "AppThemeColor")!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = (Themecolor == BGNightMode ? BGNightMode:.white)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
