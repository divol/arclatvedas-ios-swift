//
//  ViewController.swift
//  cropcircles
//
//  Created by divol on 26/05/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit
import CoreData
import CoreDataProxy

class TargetController: UIViewController,DCDMagnifyingGlassViewDelegate ,UIPickerViewDataSource,UIPickerViewDelegate,DataSourceChangedDelegate{
    var magnifyingView: DCDMagnifyingGlassView?
    var magnifyingViewVisible:Bool=false
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    var cv:BlasonView?
    var iv: ImpactView?
    
    
    let NOMBREMAX : Int = 6
    let faces = ["FITA","fita","Trispot"]

    var curVolee:Volee?
    var curCount:Int = -1
    
    
    @IBOutlet weak var totalLabel : UILabel!
    @IBOutlet weak var voleeLabel : UILabel!
    @IBOutlet weak var voleecompte : UILabel!
    @IBOutlet weak var facePicker : UIPickerView!

    var editPicker : UIPickerView!
    var detailItem: Tir? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    override func loadView() {
        super.loadView()
       // let r = self.view.frame
        
       
        
        
        let cote = min(self.view.frame.size.width,self.view.frame.size.height)
        let rect = CGRect(x: 25/2 ,y: 25/2 ,width: cote-25, height:cote-25)
        //cv = BlasonView(frame: rect)
        
        
        
        
        magnifyingViewVisible=false
        
        //Set up gesture recognizer
        
        tapGestureRecognizer.addTarget(self, action: #selector(TargetController.tapAction(_:)))
        tapGestureRecognizer.isEnabled = true
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
       // self.view.addSubview(cv!)
        
        self.iv = ImpactView(frame: rect)
        //        self.iv!.addPoint(CGPointMake(50,50))
        //        self.iv!.addPoint(CGPointMake(100,100))
        self.view.addSubview(self.iv!)
        
        
        
        DCDMagnifyingGlassView.setTargetView(self.view)
        DCDMagnifyingGlassView.setScale(2)
        DCDMagnifyingGlassView.setContentFrame(CGRect(x: 115,y: 90,width: 100,height: 100))
        DCDMagnifyingGlassView.setIndicatorColor(UIColor.green)
        DCDMagnifyingGlassView.setShadowColor(UIColor.red)
        DCDMagnifyingGlassView.sharedInstance.glassDelegate=self
        
        
        
    }
    
    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        
        magnifyingViewVisible = !magnifyingViewVisible
        var hauteur:CGFloat = 0.0
        let pt1:CGPoint = sender.location(ofTouch: 0,in: self.view)
        //let pt2:CGPoint = sender.locationOfTouch(0,inView: self.iv)
        
        if let myframe = self.iv?.frame {
            hauteur = myframe.origin.y + myframe.size.height + 20
        }
        //pour etre sous le doigt
        DCDMagnifyingGlassView.setContentFrame(CGRect(x: pt1.x-50,y: pt1.y-50,width: 100,height: 100))
        
        if  magnifyingViewVisible  {
            if pt1.y <=  hauteur && pt1.x <=  hauteur{
              //  on evite d'avoir la loupe sur les boutons
                DCDMagnifyingGlassView.show(true)
            }else{
                magnifyingViewVisible = false
                DCDMagnifyingGlassView.dismiss(true)
            }
            
        } else {
            DCDMagnifyingGlassView.dismiss(true)
        }
        
        
        
        
        
    }
    
    func managePanBegin(_ sender: UIPanGestureRecognizer){
        
    }
    func managePanEnd(_ sender: UIPanGestureRecognizer){
        
        let pt2 = DCDMagnifyingGlassView.sharedInstance.indicatorView.center
        
        let pt3 = self.iv?.convert(pt2, from: DCDMagnifyingGlassView.sharedInstance.indicatorView)
        let point = CGPoint(x: pt3!.x-25,y: pt3!.y-25)
       
        
        
        
        let score = cv!.getScoreForPoint(point)
        let azone = CGPoint(x: score.y,y: 0)

        
        if   curVolee!.addScore(Int(score.x), impact:point,zone:azone) {
            
            self.iv!.addPoint(point)

        }
        
        
        saveObject(self)
        WatchSessionManager.sharedManager.transferUserInfo(["addScore" : Int(score.x) as AnyObject])
        refreshVoleeLabel()
        DCDMagnifyingGlassView.dismiss(true)
        magnifyingViewVisible=false
    }
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func pressed(_ sender: UIButton!) {
        
        switch sender.tag {
        case 1000 :
            
            if curVolee!.deleteLast() {
                 self.iv!.removePoint()
            }
            
            saveObject(self)
             WatchSessionManager.sharedManager.transferUserInfo(["deleteScore" : 0 as AnyObject])
            DCDMagnifyingGlassView.dismiss(true)
            magnifyingViewVisible=false

            refreshVoleeLabel()
            break
            
            
        case 2000 :
            if let vol: Volee = self.curVolee {
                if ((vol.getTaille() == NOMBREMAX)  || (vol.getTaille() == 3)) {
                    
                    saveObject(self)
                    
                    curVolee = createEmptyVolee()
                    WatchSessionManager.sharedManager.transferUserInfo(["createEmptyVolee" : 0 as AnyObject])
                    saveObject(self)
                    
                    if let detail: Tir = self.detailItem {
                        
                        curCount =  detail.volees.count-1
                    }
                    
                }
            }
            if self.detailItem!.volees.count == 0 {
                curVolee = createEmptyVolee()
                WatchSessionManager.sharedManager.transferUserInfo(["createEmptyVolee" : 0 as AnyObject])
                saveObject(self)
                
                curCount=0
                
            }
            if let detail: Tir = self.detailItem {
             voleecompte?.text = "\(detail.volees.count)"
            }
            refreshVoleeLabel()
            
            
        default :
             saveObject(self)

        }
        
    }
    
    
    
    func createEmptyVolee() -> Volee {
        
        
        
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Volee", in: DataManager.getContext())
        
        let volee = Volee(entity: entityDescription!, insertInto: DataManager.getContext())
        
        volee.setValue("[]", forKey: "volee")
        volee.setValue(detailItem!, forKey: "relationship")
        volee.setValue(0 ,forKey: "rang")
        
        
        
        detailItem!.volees.add(volee)
        
        return volee
    }

    
    
    func refreshVoleeLabel(){
        voleeLabel?.text = ""
        var str = ""
        
        for i in 0 ..< NOMBREMAX{
            //une constante pour le 6 !!
            let points:Int = curVolee!.getAt(i)
            if points >= 0 {
                
                if points == 100 {
                    str += "X"
                }else  if points == 0 {
                    str += "M"
                    
                } else {
                    str += points.description
                }
                
                if i < NOMBREMAX-1 {
                    str += "-"
                }
                
            }else{
                 str += "*"
            }
            
            
            
        }
        voleeLabel?.text = str

        
    }
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Tir = self.detailItem {
            self.navigationItem.title = detail.location + ":" + detail.distance
            
            totalLabel?.text = detail.getTotal().description
            
            
            
            
            facePicker?.selectRow(detail.blasonType.intValue, inComponent:0, animated:false)
            changeFace(detail.blasonType.intValue)
            
            if let detail: Tir = self.detailItem {
                if detail.volees.count > 0 {
                    
                    
                    self.curVolee = detail.volees.lastObject as? Volee
                    curCount = detail.volees.count-1
                }else{
                    curVolee = createEmptyVolee()
                    WatchSessionManager.sharedManager.transferUserInfo(["createEmptyVolee" : 0 as AnyObject])
                    saveObject(self)
                    curCount = 0
                }
                 voleecompte?.text = "\(detail.volees.count)"
                refreshVoleeLabel()
                
            }
        }
    }
    
    @objc func editObject (_ sender: Any?) {
        if let detail: Tir = self.detailItem {
            let alert = UIAlertController(title: "Description", message: "", preferredStyle: UIAlertController.Style.alert)
            
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
                
                let texts = alert.textFields as [UITextField]?
                for i in 0 ..< texts!.count{
                    
                    let textField: UITextField = texts![i]
                    if textField.placeholder == "Localication:" {
                        
                        if let detail: Tir = self.detailItem {
                            
                            detail.setValue(textField.text, forKey: "location")
                        }
                        
                    }else {
                        detail.setValue(textField.text, forKey: "distance")
                        
                    }
                    
                }
                self.saveObject(self)
                self.navigationItem.title = detail.location + ":" + detail.distance
                
            }))
             let locastr=NSLocalizedString("Cancel", comment:"data")
            alert.addAction(UIAlertAction(title: locastr, style: UIAlertAction.Style.cancel, handler: nil))
            alert.addTextField(configurationHandler: {(textField: UITextField)  in
                textField.placeholder = "Localication:"
                textField.isSecureTextEntry = false
                if let detail: Tir = self.detailItem {
                    
                    textField.text = detail.location
                }
            })
            alert.addTextField(configurationHandler: {(textField: UITextField)  in
                textField.placeholder = "Distance:"
                textField.keyboardType = .decimalPad
                textField.isSecureTextEntry = false
                if let detail: Tir = self.detailItem {
                    
                    textField.text = detail.distance
                }
                
            })

            
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func saveObject(_ sender: AnyObject) {
        if let _: Tir = self.detailItem {
            
            
            self.view.resignFirstResponder()
            
            DataManager.saveManagedContext()
            
            if let detail: Tir = self.detailItem {
                totalLabel?.text = detail.getTotal().description
            }
            
        }
    }

    
    
    
    
      override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        WatchSessionManager.sharedManager.addDataSourceChangedDelegate(self)
        let app = UIApplication.shared
        
        if  let mainwindow = app.delegate?.window {
            let splitViewController = mainwindow!.rootViewController as! UISplitViewController
        
            // splitViewController.presentsWithGesture = false // removed on modern SDKs
            splitViewController.preferredDisplayMode = .secondaryOnly
        }
        
        
    //    var v = self.splitViewController
    //    var b = self.splitViewController?.collapsed
        
        
        self.navigationController!.navigationBar.isTranslucent = false;
        //self.edgesForExtendedLayout = UIRectEdgeNone;
        configureView()
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(TargetController.editObject(_:)))
        self.navigationItem.rightBarButtonItem = editButton
        
        
        
        if let detail: Tir = self.detailItem {
            if detail.volees.count > 0 {
                
                for i in 0 ..<  detail.volees.count{
                    let vol :Volee = detail.volees.object(at: i) as! Volee
                    
                    for j in 0 ..< NOMBREMAX{
                        //une constante pour le 6 !!
                        let points:Int = vol.getAt(j)
                    
                        if points >= 0 {
                            let coord = vol.getImpactAt(j)
                            
                            if coord.x != 0 || coord.y != 0 {
                                self.iv!.addPoint(coord)
                            }

                            
                            
                        }
                        
                        
                        
                    }

                    
                    
                    
                    
                }
            }
           
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: pickerView ds
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return faces[row]
    }

    
    func changeFace(_ blasontype:Int){
        
        DispatchQueue.main.async(execute: { () -> Void in
       
        
        self.iv?.removeFromSuperview()
        self.cv?.removeFromSuperview()
        self.cv=nil
        switch (blasontype) {
        case 0:
            
          //  let r = self.view.frame
            let cote = min(self.view.frame.size.width,self.view.frame.size.height)
            let rect = CGRect(x: 25/2 ,y: 25/2 ,width: cote-25, height:cote-25)
            self.cv = BlasonView(frame: rect)
            
            
            
            break;
        case 1:
          //  let r = self.view.frame
            let cote = min(self.view.frame.size.width,self.view.frame.size.height)
            let rect = CGRect(x: 25/2 ,y: 25/2 ,width: cote-25, height:cote-25)
            self.cv = FITAReduceView(frame: rect)
            
            break;
        case 2:
           // let r = self.view.frame
            let cote = min(self.view.frame.size.width,self.view.frame.size.height)
            let rect = CGRect(x: 25/2 ,y: 25/2 ,width: cote-25, height:cote-25)
            self.cv = TriSpotView(frame: rect)
            
            break;
            
        default:
            break;
            
        }
        self.view.addSubview(self.cv!)
        self.view.addSubview(self.iv!)
        
        self.view.setNeedsDisplay()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
            
             })

    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        changeFace(row)
        
        detailItem!.setValue(row, forKey: "blasonType")
        
        saveObject(self)

        
//
//        
//
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        let r = CGRect(x: self.view.frame.origin.x ,y: self.view.frame.origin.y ,width: size.width, height:size.height)

        self.view.frame = r
        self.view.backgroundColor = UIColor.white

        
        let cote = min(r.size.width,r.size.height)
        let rect = CGRect(x: 25/2 ,y: 25/2 ,width: cote-25, height:cote-25)

        
        self.iv!.frame = rect
        
        
        

        
        
        
        
        if let detail: Tir = self.detailItem {
            changeFace(detail.blasonType.intValue)
        }
        
        
//        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
//            println("landscape")
//        } else {
//            println("portraight")
//        }

        
    }

    
    
    func dataSourceDidUpdate(_ userInfo: [String : AnyObject]){
        
       // self.navigationController!.popViewControllerAnimated(true)
        
        DispatchQueue.global(qos:DispatchQoS.QoSClass.userInitiated).async { // 1
            DispatchQueue.main.async { // 2

                
                
            }
        }
        
        
        //updatenewtir()
        
    }
    
}

