//
//  Distance.swift
//  
//
//  Created by divol on 29/04/2015.
//
//

import Foundation
import CoreData

//http://stackoverflow.com/questions/26613971/swift-coredata-warning-unable-to-load-class-named

@objc(Distance)

open class Distance: NSManagedObject {

    @NSManaged open var comment: String
    @NSManaged open var name: String
    @NSManaged open var timeStamp: Date
    @NSManaged open var unit: String
    @NSManaged open var relationship: NSMutableSet
    
    
    
  open  func allHaussesDescription ()->String {
        
        var result = ""

        var nsarr = self.relationship.allObjects as! [Hausse]
        
       nsarr.sort(by: { (s1: Hausse, s2: Hausse) -> Bool in
            return Int(s1.name) < Int(s2.name)
        })
        
        
        for  hausse:Hausse in nsarr{

            result += "\(hausse.name)=\(hausse.hausse) "

        }
        return result
    }
  open  func getAllHaussesSorted () -> NSArray {
        
        var nsarray:[Hausse] = self.relationship.allObjects as! [Hausse]
        
        nsarray.sort(by: { (s1: Hausse, s2: Hausse) -> Bool in
            return Int(s1.name) < Int(s2.name)
        })
        return NSArray(array: nsarray)
    }
}
