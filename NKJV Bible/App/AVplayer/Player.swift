//
//  Player.swift
//  Audio B
//
//  Created by Axeraan Technologies on 25/01/21.
//

import UIKit
import Alamofire
import AVFoundation
import MediaPlayer

@available(iOS 13.4, *)
extension ReaderViewController: AVplayerProtocol {
    
    
    func ViewInit() {
        self.changeStatus()
        self.AVswitch.value = 0
        self.AVTimeRemain.text = "0:0"
        self.AVstartTime.text = "0:0"
        self.AVswitch.maximumValue = 0.0
        self.playStatus = false
        self.currentTime = 1
        self.currentTimeacu = 0
        self.PlayPause(ImageName: "Play")
        self.AVTitleText.text = String(format: "\(self.BookTxt.text!)-%02i", self.Pageindex)
        progressConfig()
        App_Protocol.delegateAVplayerProtocol = self
    }
    
    func loadGif() {
        LoaderImg.isHidden = false
        AVPSlidervu.isHidden = true
    }
    
    
    func AVstartTimer() {
        let LocalFile = DownloadedFile.shared.DownloadedArray()
        let file_name = UserDefaults.standard.string(forKey: "Bookurl")!
        
        if self.AVTimeRemain.text == "0:0" && !(LocalFile.contains(file_name)) {
            loadGif()
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(playerTime),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    @objc func playerTime() {
        
        if AudioPlayerService.sharedInstance.player?.timeControlStatus ==  AVPlayer.TimeControlStatus.playing {
            self.PLayerInfo()
        }
    }
    
    
    func PLayerInfo() {
        if self.AVTimeRemain.text != "0:0" {
            LoaderImg.isHidden = true
            if self.imageView != nil { self.imageView.removeFromSuperview()}
            AVPSlidervu.isHidden = false
        }
        self.currentTime = Int(AudioPlayerService.sharedInstance.playerItem!.currentTime().seconds)%60
        self.currentTimeacu = AudioPlayerService.sharedInstance.playerItem!.currentTime().seconds
        let minutes:Int = Int(AudioPlayerService.sharedInstance.playerItem!.currentTime().seconds / 60) % 60
        self.AVswitch.maximumValue = Float(AudioPlayerService.sharedInstance.playerItem!.asset.duration.seconds)
        
        let Duration_in_Second = Int(AudioPlayerService.sharedInstance.playerItem!.asset.duration.seconds)%60
        let Duration_in_minute:Int = Int(AudioPlayerService.sharedInstance.playerItem!.asset.duration.seconds / 60) % 60
        self.AVTimeRemain.text = String(format: "%d:%02i",Duration_in_minute,Duration_in_Second)
        
        if SwitchStatus == "Play" {
            self.AVstartTime.text = String(format: "%d:%02i",minutes,self.currentTime+1)
            AVswitch.value = Float(self.currentTimeacu+1)
        }
        
        if Int(self.AVswitch.value) == Int(self.AVswitch.maximumValue) || Int(self.AVswitch.value) == Int(self.AVswitch.maximumValue) {
            timer?.invalidate()
            ViewInit()
            if UserDefaults.standard.string(forKey: "Shuffle")  == "true" {
                AVplayOn()
            } else if UserDefaults.standard.bool(forKey: "Autoplay") {
                self.AutoNext()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
                    if self.Pageindex != self.pagecount {
                        self.AVplayOn()
                    }
                }
            }
        }
    }
    
    

    
    
    // Button function
    
    @IBAction func AVplay(_ sender: Any) {
        self.PlayControl()
       }
    
    func PlayControl() {
        self.Playview.zoomIn()
        if playStatus == false { 
            
            let fileName = String(format: "%@_%@", UserDefaults.standard.string(forKey: "SelectedLanguage")!,UserDefaults.standard.string(forKey: "BookurlForAudio")!.replacingOccurrences(of: "/", with: ":"))
            
                if NetworkManager.sharedInstance.isConnectedToInternet() || DownloadedFile.shared.DownloadedArray().contains(fileName) {
                    self.PlayPause(ImageName: "pausePlayer")
                    AVplayOn()
                } else {
                    self.view.makeToast("No internet connection", duration: 2.0, position: .bottom)
                }
            } else {
                AVpause()
            }
    }
    
    
    @IBAction func AVRepeat(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "Shuffle") == "true" {
            UserDefaults.standard.set("false", forKey: "Shuffle")
            self.RepeatView.backgroundColor = UIColor.clear
            ImageTint.sharedInstance.imageTintcolorMethod(img: self.AVRepeat! , colorVu: .white)
        } else {
            UserDefaults.standard.set("true", forKey: "Shuffle")
            self.RepeatView.backgroundColor = .white
            ImageTint.sharedInstance.imageTintcolorMethod(img: self.AVRepeat! , colorVu: UserDefaults.standard.color(forKey: "AppThemeColor")!)
        }
    }
    
    
    
//
//    @IBAction func AutoPlayAction(_ sender: Any) {
//        if UserDefaults.standard.bool(forKey: "Autoplay") == false {
//            UserDefaults.standard.setValue(true, forKey: "Autoplay")
//            self.AutoPlayView.backgroundColor = UserDefaults.standard.color(forKey: "AppThemeColor")
//            ImageTint.sharedInstance.imageTintcolorMethod(img: self.AVAutoPlay! , colorVu: UIColor.white)
//        } else {
//            UserDefaults.standard.setValue(false, forKey: "Autoplay")
//            self.AutoPlayView.backgroundColor = UIColor.clear
//            ImageTint.sharedInstance.imageTintcolorMethod(img: self.AVAutoPlay! , colorVu: self.Themecolor!)
//        }
//    }
//
    
    

    
            
    func changeStatus() {
        self.CloudImage.image = UIImage(named: "")
        let fileName = String(format: "%@_%@", UserDefaults.standard.string(forKey: "SelectedLanguage")!,UserDefaults.standard.string(forKey: "BookurlForAudio")!.replacingOccurrences(of: "/", with: ":"))
        
        if DownloadedFile.shared.DownloadedArray().contains(fileName) {
            self.CloudImage.image = UIImage(named: "tick")
        } else {
            self.CloudImage.image = UIImage(named: "DownloadImg")
        }
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.CloudImage! , colorVu: .white)
    }

    
    @IBAction func AVprevious(_ sender: Any) {
        
        if self.Pageindex > 0 {
            self.PreviousView.zoomIn()
            self.PreviousPageMove()
        }
    }
    
    
    
    @IBAction func AVNextBtn(_ sender: Any) {
        self.AutoNext()
    }
    

    
    func AutoNext() {
        if self.Pageindex >= 0 {
            self.NextView.zoomIn()
            self.nextPreviousconfig()
            self.NextPageMove()
            BookURL.sharedInstance.bookURL(BookNo: String(self.Pageindex))
            self.changeStatus()
            self.StopAv()
        }
    }
    
    
    
    func NextPageMove() {
        
        print("self.pagecount :",self.pagecount)

        if self.Pageindex >= 0 && self.pagecount > self.Pageindex {
            self.playStatus = false
            self.Pageindex = self.Pageindex+1
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "BookChapter")+1, forKey: "BookChapter")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                App_Protocol.delegateReaderSource?.ReloadFont(ChapterNo:UserDefaults.standard.integer(forKey: "BookChapter"))
                App_Protocol.delegateReader?.mainContainer()
            }
            self.AVTitleText.text = String(format: "\(self.BookName)-\(self.Pageindex)")

        }
    }
    
    
    
    func PreviousPageMove() {
            if self.Pageindex > 1 && self.pagecount >= self.Pageindex {
                self.playStatus = false
                self.Pageindex = self.Pageindex-1
                self.AVTitleText.text = String(format: "\(self.BookName)-\(self.Pageindex)")
                BookURL.sharedInstance.bookURL(BookNo: String(self.Pageindex))
                UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "BookChapter")-1, forKey: "BookChapter")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                    App_Protocol.delegateReaderSource?.ReloadFont(ChapterNo:UserDefaults.standard.integer(forKey: "BookChapter"))
                    App_Protocol.delegateReader?.mainContainer()
                }
                self.changeStatus()
                self.StopAv()
            }
    }
    
    
    
    
    

    func nextPreviousconfig() {
        self.progressView.isHidden = true
        self.UrlFilter = UserDefaults.standard.string(forKey: "Bookurl")! // ?? "01001")!
    }
    
     

    @IBAction func AVForward(_ sender: Any) {
        self.ForwardView.zoomIn()
        
        let remain:Float = Float(self.AVTimeRemain.text!.replacingOccurrences(of: ":", with: "."))!
        let startTime:Float = Float(self.AVstartTime.text!.replacingOccurrences(of: ":", with: "."))!
            
        if startTime+0.11 < remain {
            AudioPlayerService.sharedInstance.seekForward(time: 10)
            self.PLayerInfo()
        }
    }
    
    @IBAction func AVBackward(_ sender: Any) {
        self.BackwardView.zoomIn()
        if AVswitch.value > 0.10 {
            AudioPlayerService.sharedInstance.seekBackward(time: 10)
            self.PLayerInfo()
        }
    }
 
    
    @IBAction func AVstop(_ sender: Any) {
        self.StopView.zoomIn()
        if self.DownloadesArray.count <= 0 {
            self.StopAv()
        }
    }
    
    
    func StopAv() {
        LoaderImg.isHidden = true
        AVPSlidervu.isHidden = false
        ViewInit()
        playStatus = false
        AudioPlayerService.sharedInstance.player?.seek(to: .zero)
        AudioPlayerService.sharedInstance.player?.pause()
    }
    
    
    @IBAction func Download(_ sender: Any) {
        self.Download_Mp3()
    }
    
    
    
    func Download_Mp3() {
        if NetworkManager.sharedInstance.isConnectedToInternet() {
            let playeritem = UserDefaults.standard.string(forKey: "BookurlForAudio")!

            let fileName = String(format: "%@_%@.mp3", UserDefaults.standard.string(forKey: "SelectedLanguage")!,playeritem.replacingOccurrences(of: "/", with: ":"))
            
            self.DownloadesArray.append(fileName)
            
           if self.DownloadesArray.count <= 1 {
               for items in DownloadesArray {
                   DispatchQueue.main.async {
                    self.Downloadfilename = self.AVTitleText.text!
                   self.progressView.isHidden = false
                   self.CloudImage.image = UIImage(named: "")
                     let fileUrl = String(format: "%@%@.mp3",API_MAIN, playeritem)
//                       App_Protocol.delegateReader?.CallInterstitialAd()
                       let semaphore = DispatchSemaphore(value: 1)
                   let destination: DownloadRequest.Destination = { _, _ in
                       let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                               let fileURL = documentsURL.appendingPathComponent(fileName)
                               return (fileURL, [.removePreviousFile])
                       }
                       AF.download( fileUrl, method: .get, to: destination)
                                   .downloadProgress{ Alamoprogress in
                                  DispatchQueue.main.async {
                                       self.progressView.value  = CGFloat(Alamoprogress.fractionCompleted * 100)
                                      
                                      }
                                   }
                                   .response { response in
                                       semaphore.signal()
                                    if self.AVTitleText.text == self.Downloadfilename {
                                        self.CloudImage.image = UIImage(named: "tick")
                                    }
                                      ImageTint.sharedInstance.imageTintcolorMethod(img: self.CloudImage! , colorVu: UserDefaults.standard.color(forKey: "AppThemeColor")!)
                                       self.progressView.isHidden = true
                                       self.progressView.value = 0.0
                                       DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
                                           if String(format: "010%02i",self.Pageindex) == items {
                                               self.DownloadesArray = self.DownloadesArray.filter { !DownloadedFile.shared.DownloadedArray().contains($0) }
                                           }
                                        if self.playStatus == true {
                                            self.view.makeToast("\(self.Downloadfilename) Audio Downloaded", duration: 2.0, position: .bottom)
                                            self.CloudImage.isHidden = false
                                            self.CloudImage.image = UIImage(named: "tick_white")
                                            self.AVplayOn()
                                        } else {
                                            
                                        }
                                        self.Downloadfilename = "" 
                                        self.DownloadesArray.removeAll() 
                           }
                       }
                   }
               }
          } else {
              self.view.makeToast("Downloading is in progress", duration: 2.0, position: .bottom)
          }
          
         } else {
          self.view.makeToast("No internet connection", duration: 2.0, position: .bottom)
        }
    }
    
    
    
    
    func alertfunc(Msgstr:String) {
        
        let alert = UIAlertController(title: nil, message: Msgstr, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    
    func alertfuncc(Msgstr:String) {
        let alert = UIAlertController(title: nil, message: Msgstr, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    

    
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    
    // Play pause function
    @objc func AVplayOn() {
        playStatus = true
        if self.currentTimeacu <= 1 || AudioPlayerService.sharedInstance.player?.allowsExternalPlayback == false {
            self.PlayPause(ImageName: "pausePlayer")
            self.LocalOROnline()
        } else {
            if NetworkManager.sharedInstance.isConnectedToInternet() && self.DownloadesArray.count == 0 {
                 AudioPlayerService.sharedInstance.player!.play()
                 self.LoaderImg.isHidden = false
                self.PlayPause(ImageName: "pausePlayer")
            } else {
                self.view.makeToast("No internet connection", duration: 2.0, position: .bottom)
            }
        }
        AVstartTimer()
    }
    
    func AVpause() {
        if AudioPlayerService.sharedInstance.player?.timeControlStatus ==  AVPlayer.TimeControlStatus.playing {
            AudioPlayerService.sharedInstance.player!.pause()
            self.PlayPause(ImageName: "Play")
            playStatus = false
        }   
    }
    
    func LocalOROnline() {
        let LocalFile = DownloadedFile.shared.DownloadedArray()
        let file_name = String(format: "%@_%@", UserDefaults.standard.string(forKey: "SelectedLanguage")!,UserDefaults.standard.string(forKey: "BookurlForAudio")!.replacingOccurrences(of: "/", with: ":"))
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(file_name).mp3")
        
        if (LocalFile.contains(file_name)) {
            let audioURL = NSURL(fileURLWithPath: audioFilename)
            AudioPlayerService.sharedInstance.startStreaming(url: audioURL as NSURL,name: self.BookTxt.text!, title: String(format: "%d", self.Pageindex))
            self.PlayPause(ImageName: "pausePlayer")
        } else {
            if self.DownloadesArray.count == 0 {
                Download_Mp3()
                self.PlayPause(ImageName: "pausePlayer")
            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
                    self.LoaderImg.isHidden = true
                    self.AVPSlidervu.isHidden = false
                    self.PlayPause(ImageName: "Play")
                }
            }
        }
    }
    
    
    
    func PlayPause(ImageName:String) {
        self.AVplayIcon.image = UIImage(named: ImageName)
        ImageTint.sharedInstance.imageTintcolorMethod(img: self.AVplayIcon! , colorVu: .white)
    }
    
    func progressConfig() {
        progressView.animationStyle = CAMediaTimingFunctionName.linear.rawValue
        progressView.font = UIFont.systemFont(ofSize: 10)
        progressView.delegate = self
        progressView.isUserInteractionEnabled  = true
        progressView.innerCircleWidth = 3
        progressView.innerCircleColor = UserDefaults.standard.color(forKey: "AppThemeColor")!
    }
    
    
    //MARK:- ProgressViewDelegate method -
    func finishedProgress(forCircle circle: ProgressView) {
        if circle == progressView{
        }
    }
    
    func startTheProgress() {
        self.progressView.animationStyle = CAMediaTimingFunctionName.linear.rawValue
    }
    
  
}
