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

class Distance: NSManagedObject {

    @NSManaged var comment: String
    @NSManaged var name: String
    @NSManaged var timeStamp: NSDate
    @NSManaged var unit: String
    @NSManaged var relationship: NSMutableSet
    
    
    
    func allHaussesDescription ()->String {
        
        var result = ""

        var nsarr = self.relationship.allObjects as! [Hausse]
        
       sort(&nsarr,{ (s1: Hausse, s2: Hausse) -> Bool in
            return s1.name.toInt() < s2.name.toInt()
        })
        
        
        for  hausse:Hausse in nsarr{

            result += "\(hausse.name)=\(hausse.hausse) "

        }
        return result
    }
    func getAllHaussesSorted () -> NSArray {
        
        var nsarray:[Hausse] = self.relationship.allObjects as! [Hausse]
        
        sort(&nsarray,{ (s1: Hausse, s2: Hausse) -> Bool in
            return s1.name.toInt() < s2.name.toInt()
        })
        return NSArray(array: nsarray)
    }
}