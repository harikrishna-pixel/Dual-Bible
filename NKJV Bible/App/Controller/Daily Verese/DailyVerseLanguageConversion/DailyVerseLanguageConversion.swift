//
//  DailyVerseLanguageConversion.swift
//  Audio Bible
//
//  Created by Axeraan Technologies on 03/06/21.
//

import UIKit

class DailyVerseLanguageConversion: NSObject {
    
    //
    var MessageTitleAndMsg = ""
    var DeilyVersAry: Array<String> = []
    var DeilyVersDateAry: Array<String> = []
    static let sharedInstance = DailyVerseLanguageConversion()
    
    
    func DailyVerseList(Book_Name:String,Chapter:Int,Book_Id:Int,verse_Id:String) -> String {
                        
        let chapterList =  BibleContent.sharedInstance.AudioBibleListJson(selecterBookName: Book_Name, selectedId: Chapter, bookNameID: Book_Id)
                let verse = verse_Id
                let bookChapterId = "\(Book_Name) \(Chapter):\(verse)"
        
                
        if verse.contains("--") {
                let verseArray = verse.components(separatedBy: "--")
                let verseText = String(format: "%@\n%@",chapterList[Int(verseArray[0])!-1],chapterList[Int(verseArray[1])!-1])
                self.MessageTitleAndMsg = "\(verseText)_\(bookChapterId)"
                    
        } else {
            
                 self.MessageTitleAndMsg =  "\(chapterList[Int(verse)!-1])||\(chapterList[Int(verse)!-1])_\(bookChapterId)"
               }
        
        return self.MessageTitleAndMsg
     }
    
    
    
    func DailyVerseList() -> Array<String> {
        
        
        self.DeilyVersDateAry = CoreDataModel.sharedInstance.GetAllNotificationDataTest(entity: CDDailyVerses)
        
        for i in 0 ..< UserDefaults.standard.integer(forKey: "Verses") {
            
            if let path = Bundle.main.path(forResource: "dailyVerse", ofType: "json") {
                do {
                    
                    
                      let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                      let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                      let jsonOutput = jsonResult as! Array<AnyObject>
                      let VerseInfo = jsonOutput[i]
                    
                      let chapterList =  BibleContent.sharedInstance.AudioBibleListJson(selecterBookName: VerseInfo["Book"] as! String, selectedId: VerseInfo["Chapter"] as! Int-1, bookNameID: VerseInfo["Book_Id"] as! Int)
                    
                      var verse = VerseInfo["Verse"] as! String
                      let BookId = VerseInfo["Book_Id"] as! Int
                      let BookName = BibleContent.sharedInstance.BookToPosition()[BookId-1].components(separatedBy: "-")
                      let bookChapterId = "\(BookName[0]) \(VerseInfo["Chapter"] as! Int):\(verse)"
                    
                    
                    if verse.contains("--") {
                        var verseArray = verse.components(separatedBy: "--")
                        
                        if Int(verseArray[0])! > chapterList.count {
                            verseArray[0] = String(chapterList.count-1)
                        }
                        if Int(verseArray[1])! > chapterList.count {
                            verseArray[1] = String(chapterList.count-1)
                        }
                        let verseText = String(format: "%@\n%@",chapterList[Int(verseArray[0])!-1],chapterList[Int(verseArray[1])!-1])
                        self.MessageTitleAndMsg = "\(bookChapterId)_\(self.DeilyVersDateAry[i])_\(verseText)"
                    } else {
                        if Int(verse)! > chapterList.count {
                            verse = String(chapterList.count-1)
                        }
                        
                        self.MessageTitleAndMsg =  "\(bookChapterId)_\(self.DeilyVersDateAry[i])_\(chapterList[Int(verse)!-1])"
                    }
                    
                  } catch {
                       // handle error
                }
                self.DeilyVersAry.append(self.MessageTitleAndMsg)
            }
            
        }
        return self.DeilyVersAry
    }
    
    
    
    
    func DailyVerseLAst() -> String {
        
        
        self.DeilyVersDateAry = CoreDataModel.sharedInstance.GetAllNotificationDataTest(entity: CDDailyVerses)
         
        let i = UserDefaults.standard.integer(forKey: "Verses")-1
        
            if let path = Bundle.main.path(forResource: "dailyVerse", ofType: "json") {
                do {
                    
                      let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                      let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                      let jsonOutput = jsonResult as! Array<AnyObject>
                      let VerseInfo = jsonOutput[i]
                    
                      let chapterList =  BibleContent.sharedInstance.AudioBibleListJson(selecterBookName: VerseInfo["Book"] as! String, selectedId: VerseInfo["Chapter"] as! Int-1, bookNameID: VerseInfo["Book_Id"] as! Int)
                    
                      let verse = VerseInfo["Verse"] as! String
                      let BookId = VerseInfo["Book_Id"] as! Int
                      let BookName = BibleContent.sharedInstance.BookToPosition()[BookId-1].components(separatedBy: "-")
                      let bookChapterId = "\(BookName[0]) \(VerseInfo["Chapter"] as! Int):\(verse)"
                    
                    
                    if verse.contains("--") {

                        
                        let verseArray = verse.components(separatedBy: "--")
                    
                        let verseText = String(format: "%@\n%@",chapterList[Int(verseArray[0])!-1],chapterList[Int(verseArray[1])!-1])
                        self.MessageTitleAndMsg = "\(bookChapterId)_\(self.DeilyVersDateAry[i])_\(verseText)"
                    } else {
                        
                        self.MessageTitleAndMsg =  "\(bookChapterId)_\(self.DeilyVersDateAry[i])_\(chapterList[Int(verse)!-1])"
                    }
                    
                  } catch {
                       // handle error
                 }

            }
            
        return self.MessageTitleAndMsg
    }
    
    
    
}

