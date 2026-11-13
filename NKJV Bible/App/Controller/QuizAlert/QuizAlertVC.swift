//
//  QuizAlertVC.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 22/03/23.
//

import UIKit

class QuizAlertVC: UIViewController {

    @IBOutlet weak var VeresText:UILabel!
    
    @IBOutlet weak var Mainview:UIView!
    @IBOutlet weak var ReadButton:UIView!
    @IBOutlet weak var YesButton:UIView!
    
    

    var Ch_Count: Int = 0
    var chapterNo: Int = 0
    
    var bookname:String = ""
    var Chapter:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.VeresText.text = "\(bookname) Chapter \(Chapter) completed!!!"
        // Do any additional setup after loading the view.
        
        self.Mainview.layer.cornerRadius = 16
        self.ReadButton.layer.cornerRadius = self.ReadButton.frame.height/2
        self.YesButton.layer.cornerRadius = self.YesButton.frame.height/2
        
        
        self.Ch_Count = BibleContent.sharedInstance.AudioBibleListCount(selecterBookName: UserDefaults.standard.string(forKey: "BookName")!)
        self.chapterNo = Int(UserDefaults.standard.string(forKey: "BookChapter")!)!
        
        if self.chapterNo >= self.Ch_Count {
            ReadButton.isHidden = true
        }
     
    }
    
    @IBAction func Read_Action(_ sender: Any) {
        
        
        UserDefaults.standard.setValue(chapterNo+1, forKey: "BookChapter")
        App_Protocol.delegateReaderSource?.ReloadBibleData(ChapterNo:UserDefaults.standard.integer(forKey: "BookChapter"))
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Yes_Action(_ sender: Any) {
        App_Protocol.delegateReader?.Quiz(Go:true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Close_Action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Dismiss_Action(_ sender: Any) {
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
