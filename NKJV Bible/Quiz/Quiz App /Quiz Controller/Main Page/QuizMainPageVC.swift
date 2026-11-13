//
//  QuizMainPageVC.swift
//  NKJV Bible
//
//  Created by ajayprasanth on 20/02/23.
//

import UIKit
import AVFoundation

class QuizMainPageVC: UIViewController, AVAudioPlayerDelegate, QuizMainPagePC {

    

//    @IBOutlet weak var leveltxt: UILabel!
    @IBOutlet weak var LifeView: UIView!
    @IBOutlet weak var ProgressBar: UIView!
    @IBOutlet weak var ProgressInnerBar: UIView!
    
    @IBOutlet weak var BannerVu: UIView!
    @IBOutlet weak var BannerConstrain: NSLayoutConstraint!
        
//    @IBOutlet weak var TimerLbl: UILabel!
    @IBOutlet weak var QuestionTxt: UILabel!
    @IBOutlet weak var QuestionVu: UIView!
    @IBOutlet weak var QuestionLbl: UILabel!
    
    @IBOutlet weak var Nextview: UIView!
    @IBOutlet weak var Previousview: UIView!
    @IBOutlet weak var AdsView: UIView!
    @IBOutlet weak var WalletMoney: UILabel!
    
    
    @IBOutlet weak var FreeCoinVu: UIView!
    @IBOutlet weak var halfVu: UIView!
    @IBOutlet weak var HintVu: UIView!
    
    @IBOutlet weak var halfBlockVu: UIView!

    
//    @IBOutlet weak var SpinVu: UIView!
    
    @IBOutlet weak var PoceedBtn: UIButton!
    @IBOutlet weak var HalfBtn:UIButton!
    @IBOutlet weak var HintBtn:UIButton!
        
    
    @IBOutlet weak var life1: UIImageView!
    @IBOutlet weak var life2: UIImageView!
    @IBOutlet weak var life3: UIImageView!
    
    
    
    var questionShow:String = ""
    var ResultCorrect:Int = 0
    var ResultWrong:Int = 0
    var Hint:Int = 0
    
    var CorrectAnswers:[String] = []
    var Answer:[String] = []
    var AnswerKeyWords:Dictionary<Int,Array<String>> = [:]
    var KeyWords:Dictionary<Int,Array<String>> = [:]
    var KeyWord:[String] = []
    var BlankList:[String] = []
    var BookName:String = ""
    var Chapter:Int = 0
    var QuestionList:[String] = []
    var CurrentQuestion:Int = 1
    var level:String = ""
    var NumberOFDash:Int = 0
    var LifeLine:Int = 3
    var RawQuestionsList:[String] = []
    
    
    
    var timer: Timer?
    var totalTime = 59
    
    var Score:Int = 0
    
    var QKeyWordsAry:[String] = []
    var QAnswerAry:[String] = []
    var QAnswerKeyWords:[String] = []
    
    
    
    var AnswerKewords:[String] = []
    var Blank:[String] = []
    var AnswerBlank:[String] = []
    @IBOutlet var QuizAnswerCV: UICollectionView!
    @IBOutlet weak var progresConstrain: NSLayoutConstraint!
    var QuizAnswer:QuizAnswerCC!
    
    
    var player: AVAudioPlayer?
    
    var MusicName:[String] = ["The Thinking Time"]
    var recard:Int = 0
    
    let Themecolor:UIColor = UserDefaults.standard.color(forKey: "AppThemeColor")!
    
     
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        
        self.life1.image = UIImage(named: "heart.png")
        self.life2.image = UIImage(named: "heart.png")
        self.life3.image = UIImage(named: "heart.png")
        
        
        QuizProtocol.QuizMaindelegate = self
     
        self.playSound()
        
        self.BannerConstrain.constant = (StatusbarHeight > 30 ? 90:70)
        BannerVu.backgroundColor = (Themecolor == BGNightMode ? DarkModeColor:Themecolor)
        
        self.PoceedBtn.backgroundColor = Themecolor
        self.PoceedBtn.layer.cornerRadius = self.PoceedBtn.frame.height/2
        self.PoceedBtn.isHidden = true
        
        self.FreeCoinVu.backgroundColor = Themecolor
        self.halfVu.backgroundColor = Themecolor
        self.HintVu.backgroundColor = Themecolor
        self.LifeView.layer.cornerRadius = self.LifeView.frame.height/2
        self.LifeView.layer.borderWidth = 1
        self.LifeView.layer.borderColor = Themecolor.cgColor
        
        self.halfVu.layer.masksToBounds = true
        
        
        var AudioBibleList = BibleContent.sharedInstance.AudioBibleList(selecterBookName: BookName , selectedId: Chapter-1)
        
        
        self.Nextview.backgroundColor = Themecolor
        self.Previousview.backgroundColor = Themecolor

        AudioBibleList.shuffle()
        
        let QuestionCount =  (UserDefaults.standard.integer(forKey: "QuestionList") <= AudioBibleList.count  ? UserDefaults.standard.integer(forKey: "QuestionList"):AudioBibleList.count)
        
                
        
        for i in 0 ..< AudioBibleList.count {
            if  self.QuestionList.count < QuestionCount && AudioBibleList[i].components(separatedBy: " ").count >= 10 {
                self.QuestionList.append(" \(AudioBibleList[i]) ")
            }
        }
        
        
        
        for i in 1 ..< self.QuestionList.count+1 {
            AnswerKeyWords[i] = []
        }
        
        
        self.ProgressBar.layer.borderColor = Themecolor.cgColor
        self.ProgressBar.layer.borderWidth = 1
        ProgressInnerBar.backgroundColor = Themecolor
                
        self.QuestionVu.ViewShadow(10, color: UserDefaults.standard.color(forKey: "AppThemeColor")!)
        
    }
 
    
     
      private func startOtpTimer() {
             self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
         }
     
     @objc func updateTimer() {
         
         
         if self.totalTime == 0 {
             self.nextCall_Action()
         }
         
             if totalTime != 0 {
                 totalTime -= 1  // decrease counter timer
             } else {
                 if let timer = self.timer {
                     timer.invalidate()
                     self.timer = nil
                 }
             }
         }
     func timeFormatted(_ totalSeconds: Int) -> String {
         let seconds: Int = totalSeconds % 60
         let minutes: Int = (totalSeconds / 60) % 60
         return String(format: "%02d:%02d", minutes, seconds)
     }

    
    func UpdatePay() {
        self.WalletMoney.text =  "\(UserDefaults.standard.integer(forKey: "WalletMoney"))"
    }
    


    override func viewDidAppear(_ animated: Bool) {
        self.WalletMoney.text =  "\(UserDefaults.standard.integer(forKey: "WalletMoney"))"
        UserDefaults.standard.set(Date().string(format: "dd-MM-yy"), forKey: "LastAnsweredDate")
        self.refreshQuestion(Number:CurrentQuestion)
        self.refreshAns()
        
        if UserDefaults.standard.bool(forKey: "MusicSwitch") {
            self.player?.play()
        } else {
            self.player?.stop()
        }
        let comparedValue = Answer.filter () { Blank.contains($0) }
        if comparedValue.count >= 1 {
            self.PoceedBtn.isHidden = false
        } else {
            self.PoceedBtn.isHidden = true
        }
        if UserDefaults.standard.bool(forKey: "TimerSwitch") {
            DispatchQueue.main.async {
//                self.TimerLbl.isHidden = false
                self.Previousview.isHidden = true
                self.startOtpTimer()
            }
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        self.player?.stop()
    }
    
    
    
    


    
    func refreshAns() {
//        self.TimerLbl.text = "01:00"
        Answer = AnswerKeyWords[CurrentQuestion]!
        
        for item in Answer {
            if let range = self.questionShow.range(of:" ________ ") {
                self.questionShow = self.questionShow.replacingCharacters(in: range, with:item)
             }
        }
          
        self.QuestionTxt.attributedText = attributedTextBold(withString: self.questionShow, boldString: self.questionShow, font: UIFont(name:"Al Nile", size: 17)!, underlineValue: Answer)
            
    }
    
    
    
    func refreshQuestion(Number:Int) {
        self.progresConstrain.constant = CGFloat(self.QuestionList.count-CurrentQuestion)*(self.ProgressBar.frame.width/CGFloat(self.QuestionList.count))

        self.QuestionLbl.text = "Question \(Number)/\(self.QuestionList.count)"
        self.Blank.removeAll()
        
        var sometext = self.QuestionList[Number-1].components(separatedBy: " ").filter { $0 != "" }.filter { $0 != " "}

        self.KeyWord.removeAll()
        self.KeyWord = sometext
        sometext.shuffle()
        var ans:[String] = []
        
        
        func validateGenericString(_ string: String) -> Bool {
            return string.range(of: ".*[^A-Za-z0-9].*", options: .regularExpression) == nil
        }
        
        AnswerKewords.removeAll()
        for item in sometext {
            
            if validateGenericString(item) {
                if AnswerKewords.contains(where: {$0.caseInsensitiveCompare(" \(item) ") == .orderedSame}) || AnswerKewords.contains(" \(item) ") {
                    ans.append(" \(item) ")
                } else if item.count >= 4 {
                    AnswerKewords.append(" \(item) ")
                }
            }
        }
        
    
        for item in ans {
            AnswerKewords = AnswerKewords.filter(){$0 != item}
            AnswerKewords = AnswerKewords.filter(){$0 != item.capitalized}
            AnswerKewords = AnswerKewords.filter(){$0 != item.lowercased()}
        }
        
        
        
        if !KeyWords.keys.contains(CurrentQuestion) {
            
            for i in 0 ..< AnswerKewords.count {
                if Blank.count == Number_of_Dash() {
                    break
                } else {
                    Blank.append(AnswerKewords[i])
                }
            }
            KeyWords[CurrentQuestion] = Blank
        } else {
            Blank = KeyWords[CurrentQuestion]!
        }
        
        
        self.questionShow = QuestionList[Number-1]
        
        if  !RawQuestionsList.contains(QuestionList[Number-1]) {
            RawQuestionsList.append(QuestionList[Number-1])
        }
        
        
        for item in Blank {
            self.questionShow = self.questionShow.replacingOccurrences(of: item, with: " ________ ")
        }
        
        
        if !BlankList.contains(self.questionShow) {
            BlankList.append(self.questionShow)
        }
        
        
        self.QuestionTxt.attributedText = attributedTextBold(withString: self.questionShow, boldString: self.questionShow, font: UIFont(name:UserDefaults.standard.string(forKey: "FontName")!, size: CGFloat(UserDefaults.standard.float(forKey: "FontSize")))!, underlineValue: Blank)

        self.QuizAnswerCV.reloadData()
        
        
        CorrectAnswers.removeAll()
        for item in self.KeyWord {
            if Blank.contains(" \(item) ") {
                CorrectAnswers.append(" \(item) ")
            }
        }
    }
    
    
    
    
    func Number_of_Dash() -> Int {

        
        
        switch level {
        case "Easy":
            
            if level == "Easy" && AnswerKewords.count > 2 {
                NumberOFDash = 2
            }
            
        case "Medium":
            
            if level == "Medium" && AnswerKewords.count > 4 {
                NumberOFDash = 4
            } else {
                NumberOFDash = 2
            }
                        
        case "Hard":
            
            if level == "Hard" && AnswerKewords.count > 6 {
                NumberOFDash = 6
            } else {
                NumberOFDash = 3
            }
            
        default:
            
          break
        }
        
        return NumberOFDash
    }
    
    
    
    
    
    @IBAction func Back(_ sender: Any) {
        
        let otherAlert = UIAlertController(title: "Quit Quiz", message: "Do you want to Quit the quiz ?", preferredStyle: UIAlertController.Style.alert)

        let printSomething = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { _ in
            self.navigationController?.popViewController(animated: true)
           }
        let dismiss = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)

           otherAlert.addAction(printSomething)
           otherAlert.addAction(dismiss)

        self.present(otherAlert, animated: true, completion: nil)
    }
    
    

    @IBAction func Setting_Action(_ sender: Any) {
        let vc = kStoryboardQuizIphone.instantiateViewController(withIdentifier: "QuizSettingVC") as! QuizSettingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func Wallet_Action(_ sender: Any) {
        self.CallWalllet()
    }
    
    @IBAction func FreeCoin_Action(_ sender: Any) {
        self.CallWalllet()
    }
    
    
    @IBAction func CoinBtn_Action(_ sender: Any) {
        self.CallWalllet()
    }
    
      
    
    
    
    func CallWalllet() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                let vc = kStoryboardQuizIphone.instantiateViewController(withIdentifier: "QuizWalletVC") as! QuizWalletVC
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func Half_Action(_ sender: Any) {
        
        if UserDefaults.standard.integer(forKey: "WalletMoney") >= 30 {
            halfBlockVu.isHidden = false

//        @IBOutlet weak var HintBlockVu: UIView!
            
            let filterAry = Answer.filter { $0 != " ________ " }
            if filterAry.count <= Blank.count-2 {

                Answer = Answer.filter { $0 != " ________ " }
                
                for i in 0 ..< NumberOFDash/2 {
                    
                    if Answer.count <= i {
                        Answer.append(CorrectAnswers[i])
                        
                        let range = self.questionShow.range(of:" ________ ")
                        self.questionShow = self.questionShow.replacingCharacters(in: range!, with:CorrectAnswers[i])
                    }
                    else if CorrectAnswers[i] != Answer[i] {
                        
                        self.questionShow =  self.questionShow.replacingOccurrences(of: Answer[i], with: CorrectAnswers[i])
                        Answer[i] = CorrectAnswers[i]
                        
                    } else if let range = self.questionShow.range(of:" ________ ") {
                        
                        if CorrectAnswers[i] == Answer[i] {
                            Answer.append(CorrectAnswers[i+1])
                            self.questionShow = self.questionShow.replacingCharacters(in: range, with:CorrectAnswers[i+1])
                        } else {
                            Answer.append(CorrectAnswers[i])
                            self.questionShow = self.questionShow.replacingCharacters(in: range, with:CorrectAnswers[i])
                        }
                    }
                }
                
                AnswerKeyWords[CurrentQuestion]! = Answer
                self.QuizAnswerCV.reloadData()
                
                self.QuestionTxt.attributedText = attributedTextBold(withString: self.questionShow, boldString: self.questionShow, font: UIFont(name:UserDefaults.standard.string(forKey: "FontName")!, size: CGFloat(UserDefaults.standard.float(forKey: "FontSize")))!, underlineValue: Blank)
                
            }
            
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "WalletMoney")-30, forKey: "WalletMoney")
            self.WalletMoney.text =  "\(UserDefaults.standard.integer(forKey: "WalletMoney"))"
                        
        } else {
            self.CallWalllet()
        }
        
        let comparedValue = Answer.filter () { Blank.contains($0) }
        if comparedValue.count >= 1 {
            self.PoceedBtn.isHidden = false
        } else {
            self.PoceedBtn.isHidden = true
        }
    }
    
    
    
    
    
    @IBAction func Spin_Action(_ sender: Any) {
        
    }
        
    @IBAction func Hint_Action(_ sender: Any) {
        
        if UserDefaults.standard.integer(forKey: "WalletMoney") >= 20 {
            
                Hint = Hint+1
                UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "WalletMoney")-20, forKey: "WalletMoney")
            self.view.makeToast(QuestionList[CurrentQuestion-1], duration: 3, position: .center)
                self.WalletMoney.text =  "\(UserDefaults.standard.integer(forKey: "WalletMoney"))"
            
        } else {
            self.CallWalllet()
        }
    }
    
    func tryAgain() {
        self.LifeLine = self.LifeLine+1
        
        self.life1.image = UIImage(named: (LifeLine >= 1 ? "heart.png":"FadeHeart.png"))
        self.life2.image = UIImage(named: (LifeLine >= 2 ? "heart.png":"FadeHeart.png"))
        self.life3.image = UIImage(named: (LifeLine >= 3 ? "heart.png":"FadeHeart.png"))
        
        self.AnswerKeyWords[CurrentQuestion]! = []
        self.Answer = []
        for item in Blank {
            self.questionShow = self.questionShow.replacingOccurrences(of: item, with: " ________ ")
        }
        self.QuestionTxt.attributedText = attributedTextBold(withString: self.questionShow, boldString: self.questionShow, font: UIFont(name:UserDefaults.standard.string(forKey: "FontName")!, size: CGFloat(UserDefaults.standard.float(forKey: "FontSize")))!, underlineValue: Blank)
        self.QuizAnswerCV.reloadData()
        
        
    }
    
    
    
    @IBAction func NextAction(_ sender: Any) {

        if CurrentQuestion-1 == 0 {
            UserDefaults.standard.setValue([], forKey: "KeyWords")
            UserDefaults.standard.setValue([], forKey: "AnswerAry")
            UserDefaults.standard.setValue([], forKey: "AnswerKeyWords")
        }
        
        if !self.QAnswerAry.contains(QuestionList[CurrentQuestion-1]) {
            self.QAnswerAry.append(QuestionList[CurrentQuestion-1])
            self.QKeyWordsAry.append((self.KeyWords[CurrentQuestion]?.joined(separator: "@@@"))!)
            self.QAnswerKeyWords.append((self.AnswerKeyWords[CurrentQuestion]?.joined(separator: "@@@"))!)
            
        } else {
            
            self.QKeyWordsAry[CurrentQuestion-1] = (self.KeyWords[CurrentQuestion]?.joined(separator: "@@@"))!
            self.QAnswerKeyWords[CurrentQuestion-1] = (self.AnswerKeyWords[CurrentQuestion]?.joined(separator: "@@@"))!
            
        }
        
        if questionShow != QuestionList[CurrentQuestion-1] {
            LifeLine = LifeLine-1
        } else {
            self.Score = self.Score+1
        }
        
        
        
        self.life1.image = UIImage(named: (LifeLine >= 1 ? "heart.png":"FadeHeart.png"))
        self.life2.image = UIImage(named: (LifeLine >= 2 ? "heart.png":"FadeHeart.png"))
        self.life3.image = UIImage(named: (LifeLine >= 3 ? "heart.png":"FadeHeart.png"))
        
        
        
        
        UserDefaults.standard.setValue(self.QKeyWordsAry, forKey: "KeyWords")
        UserDefaults.standard.setValue(self.QAnswerAry, forKey: "AnswerAry")
        UserDefaults.standard.setValue(self.QAnswerKeyWords, forKey: "AnswerKeyWords")
        
        
        
           self.PoceedBtn.isHidden = (LifeLine == 0 ? true:false)
             
        
        
            let vc = kStoryboardQuizIphone.instantiateViewController(withIdentifier: "ResultPopupVC") as! ResultPopupVC
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                vc.AnsCount = CurrentQuestion
                vc.QuesCount = self.QuestionList.count
                vc.LifeLine = self.LifeLine
            
                vc.AnsStatus =  (questionShow == QuestionList[CurrentQuestion-1] ? true:false)
                vc.AnswerStr = QuestionList[CurrentQuestion-1]
                vc.QuestionStr = self.questionShow
                vc.Blank = self.Answer
                vc.CorrectAnswers = self.CorrectAnswers

            self.present(vc, animated: true, completion: nil)
        
        
            
    }
    
    
    
    func nextCall_Action() {
        self.PoceedBtn.isHidden = true
        if self.LifeLine == 0 {
            let vc = kStoryboardQuizIphone.instantiateViewController(withIdentifier: "ScoreBoardVC") as! ScoreBoardVC
            vc.Score = self.Score
            vc.LifeLine = self.LifeLine
            vc.AnswerKeyWords = self.AnswerKeyWords
            self.navigationController?.pushViewController(vc, animated: true)
             
        } else {
            
            self.halfBlockVu.isHidden = true
            
            self.Hint = 0
            
            if UserDefaults.standard.bool(forKey: "TimerSwitch") {
                    self.timer?.invalidate()
                    self.timer = nil
                    self.totalTime = 60
                    self.startOtpTimer()
            }
            
            if QuestionList[CurrentQuestion-1] == self.questionShow && CurrentQuestion <= self.QuestionList.count {
                self.ResultCorrect = self.ResultCorrect+1
            }
            
            
            if CurrentQuestion < self.QuestionList.count {
                CurrentQuestion = CurrentQuestion+1
                self.refreshQuestion(Number:CurrentQuestion)
                self.refreshAns()
            
                
            } else if CurrentQuestion == self.QuestionList.count {
                
                self.PoceedBtn.isHidden = true
                
                self.timer?.invalidate()
                self.timer = nil
                
    //            self.stop()
                
                let vc = kStoryboardQuizIphone.instantiateViewController(withIdentifier: "ScoreBoardVC") as! ScoreBoardVC
                vc.Score = self.Score
                vc.LifeLine = self.LifeLine
                vc.AnswerKeyWords = self.AnswerKeyWords
                self.navigationController?.pushViewController(vc, animated: true)
                
                
                
//                let vc = kStoryboardQuizIphone.instantiateViewController(withIdentifier: "QuizResultViewController") as! QuizResultViewController
//                vc.Correct = ResultCorrect
//                vc.OverAllcount = self.QuestionList.count
//                vc.Chapter = Chapter
//                vc.Booknname = BookName
//                vc.RawQuestionsList = RawQuestionsList
//                vc.AnswerKeyWords = AnswerKeyWords
//                vc.KeyWords = KeyWords
//                vc.BlankList = BlankList
//                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    

    
    
    
    @IBAction func PreviousAction(_ sender: Any) {
        
        if CurrentQuestion > 1 {
            CurrentQuestion = CurrentQuestion-1
            self.refreshQuestion(Number:CurrentQuestion)
            self.refreshAns()
        }
    }
    

    
    func attributedTextBold(withString string: String, boldString: String, font: UIFont, underlineValue:[String]) -> NSAttributedString {
        
      let attributedString = NSMutableAttributedString(string: string)
        
      let FontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
      let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10.0
         
      let range = (string as NSString).range(of: boldString, options: .caseInsensitive)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:range)
        attributedString.addAttributes(FontAttribute, range: range)
        
        
        for item in underlineValue {
            let range1 = (string as NSString).range(of: item, options: .caseInsensitive)
            attributedString.addAttributes(FontAttribute, range: range1)
            
            let ForegroundColor: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UserDefaults.standard.color(forKey: "AppThemeColor")!]
            
//            let TextBold: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name:"Cera Pro Bold", size: 17)!,]
            
            attributedString.addAttributes(ForegroundColor, range: range1)
//            attributedString.addAttributes(TextBold, range: range1)
        }
                
      return attributedString
    }
    
    
    
    
    func uniqueElementsFrom(array: [String]) -> [String] {
      
      var set = Set<String>()
      let result = array.filter {
        guard !set.contains($0) else {
          return false
        }
        set.insert($0)
        return true
      }
      return result
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





extension QuizMainPageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Blank.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        self.QuizAnswer = (self.QuizAnswerCV.dequeueReusableCell(withReuseIdentifier: "QuizAnswerCC", for: indexPath) as! QuizAnswerCC)
        self.QuizAnswer.AnswerLbl.text = Blank[indexPath.row]
        self.QuizAnswer.AnswerVu.ViewShadow(5, color: UserDefaults.standard.color(forKey: "AppThemeColor")!)
        self.QuizAnswer.AnswerLbl.textColor = UserDefaults.standard.color(forKey: "AppThemeColor")
        
        if Answer.contains(Blank[indexPath.row]) {
            self.QuizAnswer.AnswerVu.backgroundColor = UserDefaults.standard.color(forKey: "AppThemeColor")!
            self.QuizAnswer.AnswerLbl.textColor = UIColor.white
        } else{
            self.QuizAnswer.AnswerVu.backgroundColor = UIColor.white
            self.QuizAnswer.AnswerLbl.textColor = UIColor.black
        }
        
        return self.QuizAnswer!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 36)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if AnswerKeyWords.count <= CurrentQuestion {
            AnswerKeyWords[CurrentQuestion] = Answer
        } else {
            Answer = AnswerKeyWords[CurrentQuestion]!
        }
        
        
        if !Answer.contains(Blank[indexPath.row]) {
            
            
            if let index = Answer.firstIndex(of: Blank[indexPath.row]) {
                Answer[index] = Blank[indexPath.row]
            } else if let index = Answer.firstIndex(of: " ________ ") {
                Answer[index] = Blank[indexPath.row]
            }
            else {
                Answer.append(Blank[indexPath.row])
            }
            
            if UserDefaults.standard.bool(forKey: "ToneSwitch") {
                QuizClickSound.shared.SelectMusic()
            }
            
            if UserDefaults.standard.bool(forKey: "VibSwitch") {
                Vibration.medium.vibrate()
            }
            
            if let range = self.questionShow.range(of:" ________ ") {
                self.questionShow = self.questionShow.replacingCharacters(in: range, with:Blank[indexPath.row])
            }
            self.QuestionTxt.attributedText = attributedTextBold(withString: self.questionShow, boldString: self.questionShow, font: UIFont(name:"Al Nile", size: 17)!, underlineValue: Blank)
            
            AnswerKeyWords[CurrentQuestion] = Answer
            
        } else {
            
            if UserDefaults.standard.bool(forKey: "VibSwitch") {
                Vibration.light.vibrate()
            }
            if UserDefaults.standard.bool(forKey: "ToneSwitch") {
                QuizClickSound.shared.DeSelectMusic()
            }
            
            
            if let range = self.questionShow.range(of:Blank[indexPath.row]) {
                self.questionShow = self.questionShow.replacingCharacters(in: range, with:" ________ ")
            }
            
            if let index = Answer.firstIndex(of: Blank[indexPath.row]) {
                //                Answer.remove(at: index)
                Answer[index] = " ________ "
            }
            AnswerKeyWords[CurrentQuestion] = Answer
            self.QuestionTxt.attributedText = attributedTextBold(withString: self.questionShow, boldString: self.questionShow, font: UIFont(name:"Al Nile", size: 17)!, underlineValue: Blank)
        }
        
        
        let comparedValue = Answer.filter () { Blank.contains($0) }
        if comparedValue.count >= 1 {
            self.PoceedBtn.isHidden = false
        } else {
            self.PoceedBtn.isHidden = true
        }
        
        self.QuizAnswerCV.reloadData()
    }
}


extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}



extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}



