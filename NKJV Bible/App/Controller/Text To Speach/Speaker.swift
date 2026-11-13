//
//  Speaker.swift
//  Audio Bible
//
//  Created by Axeraan Technologies on 20/01/21.
//

import UIKit
import AVFoundation

class Speaker: NSObject,AVSpeechSynthesizerDelegate {
    let synth = AVSpeechSynthesizer()
    var utteranceRate = 0.4
    var myUtterance:AVSpeechUtterance?

        override init() {
            super.init()
            synth.delegate = self
        }

        func speak(_ string: String) {
            
            self.myUtterance = AVSpeechUtterance(string: string)
            
            let speeches = CoreDataModel.sharedInstance.GetSavedSpeechSettings(entity: CDSpeechSetting)
            let speechSettings = speeches.components(separatedBy: "/")
            

            
                self.myUtterance!.voice = AVSpeechSynthesisVoice(identifier: speechSettings[0])
                self.myUtterance!.rate = Float(speechSettings[3]) ?? AVSpeechUtteranceDefaultSpeechRate
                self.myUtterance!.pitchMultiplier = Float(speechSettings[2]) ?? 1.0
            
            
            synth.speak(self.myUtterance!)
        }
}

