//
//  TextList.swift
//  Audio Bible
//
//  Created by Axeraan Technologies on 13/10/21.
//

import UIKit

class TextList: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    let SansType = ["Playfair Display", "Merriweather", "Lora", "Source Serif Pro", "Roboto Slab"]
    let Sans_dark = ["Baskerville", "Lora"]
    let Serif = ["Arial", "Verdana", "Helvetica", "Futura", "Avenir"]
    
    let Serif_bold = "Helvetica"
    

    
    func TextList() {
        if let path = Bundle.main.path(forResource: "dailyVerse", ofType: "json") {
            do {
                
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                  let jsonOutput = jsonResult as! Array<AnyObject>
                
                
              } catch {
             
            }
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
