//
//  Volee.swift
//  
//
//  Created by divol on 29/04/2015.
//
// https://github.com/SwiftyJSON/SwiftyJSON

import Foundation
import CoreData
import CoreGraphics

@objc(Volee)

open class Volee: NSManagedObject {

    
   @NSManaged open var volee: String
   @NSManaged open var rang: NSNumber
   @NSManaged var impactes:  NSData
   @NSManaged var zones: NSData
   @NSManaged open var relationship: Tir

    let NOMBREMAX : Int = 6
    
open    var scores:NSMutableArray {
    
        get {
                if self.volee.isEmpty {
                    self.volee = "[]"
                }
            
            let json = (try? JSON(data: self.volee.data(using: .utf8)!)) ?? JSON([])
            //
            let toto = json.arrayObject
    
             let ascores = NSMutableArray(array: toto!)
            return ascores
             

        }
    }

    open var impacteArray:NSMutableArray{
        get {
            if self.impactes.length == 0 {
                let copyimpacteArray = NSMutableArray(capacity:0)
                self.impactes = NSKeyedArchiver.archivedData(withRootObject:copyimpacteArray) as NSData
            }
            //NSData* myData = [NSKeyedArchiver archivedDataWithRootObject:myMutableArray];
            let k:NSMutableArray =  (NSKeyedUnarchiver.unarchiveObject(with:self.impactes as Data) as? NSMutableArray)!
            
            
            return k
            
            
        }

    }
    
    open var zoneArray:NSMutableArray{
        get {
            if self.zones.length == 0 {
                let copyzoneArray = NSMutableArray(capacity:0)
                self.zones = NSKeyedArchiver.archivedData(withRootObject: copyzoneArray) as NSData
            }
            let k:NSMutableArray =  (NSKeyedUnarchiver.unarchiveObject(with: self.zones as Data) as? NSMutableArray)!
            
            
            return k
            
            
        }
        
    }

    
    
    
    open  override var description:String{
        get {
            var result = ""
            if self.volee.isEmpty {
                return "-"
            }else{
                let copyscore = scores
                var chunk = ""
                for i in 0  ..< copyscore.count  {
                    let num:NSNumber = copyscore.object(at: i) as! NSNumber
                    if  num.intValue == 100 {
                        chunk = "X"
                    }else if  num.intValue == 0 {
                         chunk = "M"
                    }else {
                        chunk = "\(num.intValue)"
                    }
                    
                    result += chunk
                    if i < copyscore.count-1 {
                        result += "-"
                    }
                }
                return result
            }
        }
    }
   
    
open    func getTotal() -> Int {
        var res:Int = 0
        let copyscore = scores
            
                 for i in 0  ..< copyscore.count  {
                     let num:NSNumber = copyscore.object(at: i) as! NSNumber
                    if  num.intValue == 100 {
                        res  = res + 10
                    }else {
                        res  = res + num.intValue
                    }
                 }
            
        
        return res
    }
    
    open func addScore (_ points : Int, impact:CGPoint, zone:CGPoint)->Bool {
        
        let copyscore = self.scores
        var done=false
        
        if copyscore.count < NOMBREMAX {
            copyscore.add(NSNumber(value: points as Int))
        }
        
        
        let data:Data =  try! JSONSerialization.data(withJSONObject: copyscore,options: JSONSerialization.WritingOptions(rawValue: 0))
        
        self.volee = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!.description
        
        

      //  NSString *pointToSavae = NSStringFromCGPoint(point); // Will store string {20,20}

        
        let copyimpacteArray = NSMutableArray(array:self.impacteArray);
        
        
        if copyscore.count < NOMBREMAX {
            copyimpacteArray.add(NSValue(cgPoint:impact))
            done=true
        }
        
        self.impactes = NSKeyedArchiver.archivedData(withRootObject: copyimpacteArray) as NSData
        
        
        let copyzoneArray = self.zoneArray
        if copyscore.count < NOMBREMAX {
            copyzoneArray.add(NSValue(cgPoint:zone))
        }
        
        self.zones = NSKeyedArchiver.archivedData(withRootObject: copyzoneArray) as NSData

        
        
        return done
    }
    
 open   func deleteLast()->Bool{
        var done=false
        let copyscore = scores

        if copyscore.count != 0 {
            copyscore.removeLastObject()
        }
        
        let data:Data =  try! JSONSerialization.data(withJSONObject: copyscore,options: JSONSerialization.WritingOptions(rawValue: 0))
        
        self.volee = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!.description
    
        let copyimpacteArray = self.impacteArray
        if copyimpacteArray.count != 0 {
            copyimpacteArray.removeLastObject()
            done=true
        }
    
        self.impactes = NSKeyedArchiver.archivedData(withRootObject: copyimpacteArray) as NSData
    
        let copyzoneArray = self.zoneArray
        if copyzoneArray.count != 0 {
            copyzoneArray.removeLastObject()
        }
    
        self.zones = NSKeyedArchiver.archivedData(withRootObject: copyzoneArray) as NSData

    
    
        return done
    }
    
  open  func getAt(_ fleche : Int) -> Int{
        var res:Int = -1
        let copyscore = scores
        
        if fleche < copyscore.count {
            let num:NSNumber = copyscore.object(at: fleche) as! NSNumber
            res = num.intValue
        }
        
        return res
    }
    
    open func getImpactAt(_ fleche:Int) ->CGPoint{
        
        let copyimpacteArray = self.impacteArray
        var point = CGPoint(x: 0,y: 0)
        if fleche < copyimpacteArray.count {
            let p:NSValue = copyimpacteArray.object(at: fleche) as! NSValue
          point = p.cgPointValue
        }
        
        return point
    }
    
    open func getZoneAt(_ fleche:Int) ->CGPoint{
        
        let copyzoneArray = self.zoneArray
        var point = CGPoint(x: 0,y: 0)
        if fleche < copyzoneArray.count {
            let p : NSValue = copyzoneArray.object(at: fleche) as! NSValue
            point = p.cgPointValue
        }
        
        return point
    }

    
    
 open   func getTaille()->Int{
         let copyscore = self.scores
        return copyscore.count
    }
    
}
