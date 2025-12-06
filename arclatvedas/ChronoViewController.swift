//
//  ChronoViewController.swift
//  arclatvedas
//
//  Created by Nicolas CHEVALIER on 4/11/16.
//  modified by divol on 01/06/2016.
//

import UIKit
import AVFoundation

class ChronoViewController: UIViewController,VPRangeSliderDelegate  {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePreference: UISwitch!
    @IBOutlet weak var centerview:UIView!
    @IBOutlet weak var rangeSlider:VPRangeSlider!
    @IBOutlet weak var startstopButton:UIButton!
    
    var timer = Timer()
    var mincount = 10
    var maxcount = 30
    var count = 10
    var tapRecognizer: UITapGestureRecognizer!
    let beep = URL(fileURLWithPath: Bundle.main.path(forResource: "bip", ofType: "wav")!)
    let doubleBeep = URL(fileURLWithPath: Bundle.main.path(forResource: "bip2", ofType: "wav")!)
    let tripleBeep = URL(fileURLWithPath: Bundle.main.path(forResource: "bip3", ofType: "wav")!)
    var audioPlayer =  AVAudioPlayer()
    
    
     func viewWillDisappear() {
         UIApplication.shared.isIdleTimerDisabled = false
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let app = UIApplication.shared
        
        if  let mainwindow = app.delegate?.window {
            let splitViewController = mainwindow!.rootViewController as! UISplitViewController
            
            
            
            splitViewController.presentsWithGesture = false // SplitView won't recognize right swipe
            splitViewController.preferredDisplayMode = UISplitViewController.DisplayMode.secondaryOnly
        }

        
        
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChronoViewController.manageTimer))
        self.view.addGestureRecognizer(tapRecognizer)
        self.initViewWithValue(mincount, andColor: UIColor.red.withAlphaComponent(0.70))
        
        timeLabel.font = UIFont(name: "DBLCDTempBlack", size: 60.0)
        
        timeLabel.textColor = UIColor.green.withAlphaComponent(0.70)
        timeLabel.backgroundColor = UIColor.black
        
        
        centerview.layer.cornerRadius = 10.0;
        centerview.layer.masksToBounds = true;
       
        
        self.updateLabel()
        
        
        
        self.rangeSlider.rangeDisplayLabelColor = UIColor.black
        
        self.rangeSlider.requireSegments = false
        self.rangeSlider.sliderSize = CGSize(width: 10, height: 10)
        self.rangeSlider.segmentSize = CGSize(width: 10, height: 10)
        
        self.rangeSlider.rangeSliderForegroundColor = UIColor.black
        self.rangeSlider.rangeSliderButtonImage = UIImage(named:"slider")
        self.rangeSlider.delegate=self
        
        
        let amax:CGFloat = self.timePreference.isOn ? 240.0 : 120.0
        
        
        
        self.rangeSlider.scrollStart(toStartRange: CGFloat(mincount) * 100.0 / amax,andEndRange: (amax-CGFloat(maxcount)) * 100.0 / amax)
        
        
        
        timePreference.addTarget(self, action: #selector(ChronoViewController.switchChanged(_:)), for: UIControl.Event.valueChanged)
        
        
        
        
        startstopButton.titleLabel?.text="DÉBUT"
    }
    
    func playSound(_ file: URL) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: file)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            audioPlayer.play()
        } catch {
            print(error)
        }
    }
    
    func updateLabel() {
        self.timeLabel.text = "\(self.count)"
    }
    
    func initViewWithValue(_ value: Int, andColor color: UIColor) {
        count = value
        self.view.backgroundColor = color
    }
    
    @objc func firstTimer() {
        count -= 1
        if (count <= 0) {count = 0}
        updateLabel()

        if (count == 0) {
            // Play sound
            playSound(doubleBeep)
            initViewWithValue(self.timePreference.isOn ? 240 : 120, andColor: UIColor.green.withAlphaComponent(0.70))
            updateLabel()
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChronoViewController.timerAction), userInfo: nil, repeats: true)
        }
    }
    
  @objc  func manageTimer() {
        
        if ("STOP".compare((self.startstopButton.titleLabel?.text)!)==ComparisonResult.orderedSame){
            self.startstopButton.setTitle("DÉBUT", for: UIControl.State())
        }else{
            self.startstopButton.setTitle("STOP", for: UIControl.State())
        }
        
        if (timer.isValid) {
            timer.invalidate()
            playSound(tripleBeep)
            initViewWithValue(mincount, andColor: UIColor.red.withAlphaComponent(0.70))
            updateLabel()
            timePreference.isEnabled=true
            rangeSlider.partialyHide(false)
            
        } else {
            // Play sound
            playSound(beep)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChronoViewController.firstTimer), userInfo: nil, repeats: true)
            timePreference.isEnabled=false
            rangeSlider.partialyHide(true)

        }
    }
    
@objc    func timerAction() {
        count -= 1
        if (count <= 0) {
            // Play sound
            playSound(tripleBeep)
            self.view.backgroundColor = UIColor.red.withAlphaComponent(0.70)
            timer.invalidate()
            initViewWithValue(mincount, andColor: UIColor.red.withAlphaComponent(0.70))
            self.startstopButton.setTitle("DÉBUT", for: UIControl.State())
            timePreference.isEnabled=true
            rangeSlider.partialyHide(false)


        } else if (count <= maxcount) {
            self.view.backgroundColor = UIColor.yellow.withAlphaComponent(0.70)
        } else {
            self.view.backgroundColor = UIColor.green.withAlphaComponent(0.70)
        }
        updateLabel()
    }
    
    
    //MARK: - VPRangeSliderDelegate
    // - (void)sliderScrolling:(VPRangeSlider *)slider withMinPercent:(CGFloat)minPercent andMaxPercent:(CGFloat)maxPercent
    func sliderScrolling(_ slider : VPRangeSlider, withMinPercent:CGFloat , andMaxPercent:CGFloat)
    {
        let amax:CGFloat = self.timePreference.isOn ? 240.0 : 120.0
        
        if ((withMinPercent * amax) / 100) < 1 {
            self.mincount=0
        }else {
            self.mincount = Int(round ((withMinPercent * amax) / 100) )
        }
        self.initViewWithValue(self.mincount, andColor: UIColor.red.withAlphaComponent(0.70))
        updateLabel()
        
        self.maxcount = Int(round(amax - ((andMaxPercent * amax / 100))))
        self.rangeSlider.minRangeText = String(self.mincount)
        self.rangeSlider.maxRangeText = String(self.maxcount)
    }
    
    
    
    
    
    //MARK: - switchChanged
@objc    func switchChanged(_ mySwitch: UISwitch) {
        let amax:CGFloat = self.timePreference.isOn ? 240.0 : 120.0
        if amax-CGFloat(maxcount) < 0 {
            maxcount = 30
        }
        self.rangeSlider.scrollStart(toStartRange: CGFloat(mincount) *  100.0 / amax,andEndRange: (amax-CGFloat(maxcount)) * 100.0 / amax)
        
        self.rangeSlider.slideRangeSliderButtonsIfNeeded();
    }
    
     //MARK: - startstop
    
    @IBAction func startStoppressed(_ sender: UIButton!){
       

        
        manageTimer()
    }
    
}
