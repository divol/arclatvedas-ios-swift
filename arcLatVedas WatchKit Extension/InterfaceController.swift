//
//  InterfaceController.swift
//  arcLatVedas WatchKit Extension
//
//  Created by divol on 21/05/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import WatchKit
import Foundation
import CoreData
//import CoreDataProxy

class InterfaceController: WKInterfaceController,DataSourceChangedDelegate {
    @IBOutlet weak var imageicone: WKInterfaceImage!
    @IBOutlet weak var location: WKInterfaceLabel!
    @IBOutlet weak var distance: WKInterfaceLabel!
    @IBOutlet weak var total: WKInterfaceLabel!
    @IBOutlet weak var date: WKInterfaceLabel!
    var curTir:Tir!
    
    
    override func awake(withContext context: Any?) {
        
       
        super.awake(withContext: context)
        WatchSessionManager.sharedManager.addDataSourceChangedDelegate(self)
        
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil)

        location.setText("")
        distance.setText("")
        total.setText("")
        date.setText("")
        
        let wutils:WatchUtils = WatchUtils()
        
        if let ti:AnyObject = wutils.getLastTir() {
            
            let titi:Tir  = ti as! Tir
            
            curTir=titi
            
        }
        

    }

    
    
    func updatenewtir(){
        let wutils:WatchUtils = WatchUtils()
        
        
        if let ti:AnyObject = wutils.getLastTir() {
        
            let titi:Tir  = ti as! Tir
        
            self.curTir=titi
        
        }
        
        updateScreen()
    }
    
    @IBAction func doButtonNouveauTir()
    {
        let wutils:WatchUtils = WatchUtils()
        
        wutils.insertNewTir()
        
        
        updatenewtir()
        WatchSessionManager.sharedManager.transferUserInfo(["insertNewTir" : 0 as AnyObject])
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        updateScreen()
        
        
    }

    
    func updateScreen(){
        
        DispatchQueue.global(qos:DispatchQoS.QoSClass.userInitiated).async { // 1
            DispatchQueue.main.async { // 2
                
                let dateFormat:DateFormatter = DateFormatter()
                dateFormat.dateStyle = DateFormatter.Style.short
                dateFormat.dateFormat="dd/MM/yy"
                
                 if let ti:Tir = self.curTir {
                    let dateString:String = dateFormat.string(from: ti.timeStamp)
                
                
                    self.location.setText(ti.location)
                    self.distance.setText(ti.distance)
                    self.total.setText("\(ti.getTotal())")
                    self.date.setText(dateString)
                }
                
            }
        }

    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    /// MARK:, // TODO: and // FIXME
    
    // MARK: - DataSourceChangedDelegate
    //DataSourceChangedDelegate
    func dataSourceDidUpdate(_ userInfo: [String : AnyObject]){
        
        updatenewtir()
        
    }
}



// Configure interface objects here.

//        var dico: Dictionary<String, String> = ["AAPL" : "Apple Inc", "GOOG" : "Google Inc", "AMZN" : "Amazon.com, Inc", "FB" : "Facebook Inc"]


//        InterfaceController.openParentApplication(["request": "refreshData"],
//            reply: { (replyInfo, error) -> Void in
//                // TODO: process reply data
//                NSLog("Reply: \(replyInfo)")
//
//
//                if let response = replyInfo["response"] as? NSData {
//                    if let str = NSKeyedUnarchiver.unarchiveObjectWithData(response) as? String {
//                            NSLog("response: \(str)")
//                    }
//                }
//
//        })
