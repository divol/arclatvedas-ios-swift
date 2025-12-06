//
//  TirInterfaceController.swift
//  arclatvedas
//
//  Created by divol on 22/05/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import Foundation

import WatchKit
import CoreData

//import CoreDataProxy

//class TirInterfaceController: WKInterfaceController,NSUserActivityDelegate {
class TirInterfaceController: WKInterfaceController,DataSourceChangedDelegate {
    @IBOutlet weak var voleeNumero: WKInterfaceLabel!
    @IBOutlet weak var total: WKInterfaceLabel!
    @IBOutlet weak var scorevolee: WKInterfaceLabel!
    
    var curTir:Tir?

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        WatchSessionManager.sharedManager.addDataSourceChangedDelegate(self)
        let wutils:WatchUtils = WatchUtils()
        
        if let ti:AnyObject = wutils.getLastTir() {
            
            let titi:Tir  = ti as! Tir
            
            curTir=titi
            
             doRefresh()
            
        }

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let wutils:WatchUtils = WatchUtils()
        
        if let ti:AnyObject = wutils.getLastTir() {
            
            let titi:Tir  = ti as! Tir
            
            curTir=titi
            
            doRefresh()
            
        }
        
        
    }

    
    func doRefresh(){
        
        if let tir = curTir {
            // Create an NSUserActivity and update it (watchOS 5+ API)
            let activityType = "com.jack.arclatvedas.update"
            let activity = NSUserActivity(activityType: activityType)
            activity.userInfo = ["key1": ["yo": "dawg"]]
            activity.title = "Update"
            self.update(activity)

            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async { // 1
                DispatchQueue.main.async { // 2
                    
                    self.voleeNumero.setText("\(tir.volees.count)")
                    self.total.setText("\(tir.getTotal()) (0)")
                    if let vol:Volee = tir.volees.object(at: tir.volees.count-1) as? Volee {
                        self.scorevolee.setText(vol.description)
                        self.total.setText("\(tir.getTotal()) (\(vol.getTotal()))")
                    }

                }
            }

        }
        
    }
    
    @IBAction func doButtonX()
    {
        doButton(100)
    }
    @IBAction func doButton10()
    {
        doButton(10)
    }
    @IBAction func doButton9()
    {
        doButton(9)
    }
    @IBAction func doButton8()
    {
        doButton(8)
    }
    @IBAction func doButton7()
    {
         doButton(7)
    }
    @IBAction func doButton6()
    {
        doButton(6)
    }
    @IBAction func doButton5()
    {
        doButton(5)
    }
    @IBAction func doButton4()
    {
         doButton(4)
    }
    @IBAction func doButton3()
    {
         doButton(3)
    }
    @IBAction func doButton2()
    {
         doButton(2)
    }
    @IBAction func doButton1()
    {
        doButton(1)
    }
    @IBAction func doButton0()
    {
        doButton(0)
    }
    func doButton(_ what:Int)
    {
        
        if let tir = curTir {
            if let vol:Volee = tir.volees.object(at: tir.volees.count-1) as? Volee {
                
                vol.addScore(what, impact:CGPoint(x: 0,y: 0),zone:CGPoint(x: 0,y: 0))
            }
        }

        doRefresh()
         DataManager.saveManagedContext()
        
         WatchSessionManager.sharedManager.transferUserInfo(["addScore" : what as AnyObject])
    }

    

    
    
    
    @IBAction func doButtonMoins()
    {
        
         if let tir = curTir {
            if let vol:Volee = tir.volees.object(at: tir.volees.count-1) as? Volee {
                
                vol.deleteLast()
            }
        }
        doRefresh()
         DataManager.saveManagedContext()
        
         WatchSessionManager.sharedManager.transferUserInfo(["deleteScore" : 0 as AnyObject])
    }

    
    
    @IBAction func doMenuActionVoleeSuivante() {
        // Handle menu action.
        let wutils:WatchUtils = WatchUtils()
        if let tir = curTir {
            wutils.createEmptyVolee(tir)
            WatchSessionManager.sharedManager.transferUserInfo(["createEmptyVolee" : 0 as AnyObject])
        }
        doRefresh()
         DataManager.saveManagedContext()
    }
    

    
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    // MARK: - DataSourceChangedDelegate
    //DataSourceChangedDelegate
    func dataSourceDidUpdate(_ userInfo: [String : AnyObject]){
        
       // for (action, param) in userInfo {
            
           
            let wutils:WatchUtils = WatchUtils()
            
            if let ti:AnyObject = wutils.getLastTir() {
                
                let titi:Tir  = ti as! Tir
                
                curTir=titi
                
                doRefresh()
                
            }

            
        //}
        
    }
    
    
    
}

