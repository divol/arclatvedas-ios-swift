//
//  WatchUtils.swift
//  arclatvedas
//
//  Created by divol on 21/05/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import Foundation
import CoreData

open class WatchUtils : NSObject,NSFetchedResultsControllerDelegate{

//var managedObjectContext: NSManagedObjectContext? = nil

// MARK: - Fetched results controller

var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
    if _fetchedResultsController != nil {
        return _fetchedResultsController!
    }
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
    // Edit the entity name as appropriate.
    let entity = NSEntityDescription.entity(forEntityName: self.tablename, in: DataManager.getContext())
    fetchRequest.entity = entity
    
    // Set the batch size to a suitable number.
    fetchRequest.fetchBatchSize = 20
    
    // Edit the sort key as appropriate.
    let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
   // let sortDescriptors = [sortDescriptor]
    
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.getContext(), sectionNameKeyPath: nil, cacheName: nil) //"Master"
    aFetchedResultsController.delegate = self
    _fetchedResultsController = aFetchedResultsController
    
    var error: NSError? = nil
    do {
        try _fetchedResultsController!.performFetch()
    } catch let error1 as NSError {
        error = error1
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        if let error = error {
            print("Unresolved error \(error), \(error.userInfo)")
        } else {
            print("Unresolved error (unknown NSError)")
        }
        abort()
    }
    
    return _fetchedResultsController!
}
var _fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? = nil

    
    
    var tablename:String = "[Unnamed]" {
        didSet {
            // Update the view.
        }
    }

    
    
 open  func getLastTir( ) ->AnyObject!{
        
    
     NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil)
    
    _fetchedResultsController=nil
       var object:Tir?
        tablename = "Tir";
    let ff: NSFetchedResultsController<NSFetchRequestResult> = self.fetchedResultsController
    
    let cocos: [Tir] = (ff.fetchedObjects as? [Tir]) ?? []
        
        if  cocos.count > 0 {
            
             object = cocos[0]
        }
//        else{
//            insertNewTir()
//            return getLastTir( )
//            
//        }
    
        return object
    

    }
    
    
    open func createEmptyVolee(_ tir:Tir){
        
        
        
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Volee", in: DataManager.getContext())
        
        let volee = Volee(entity: entityDescription!, insertInto: DataManager.getContext())
        
        volee.setValue("[]", forKey: "volee")
        volee.setValue(tir, forKey: "relationship")
        volee.setValue(0 ,forKey: "rang")
        
        
        
        tir.volees.add(volee)
        
    }
    
    
    
    
    func insertNewTirObject(_ newManagedObject: Tir) {
        
        newManagedObject.setValue(Date(), forKey: "timeStamp")
        newManagedObject.setValue("Au club", forKey: "location")
        newManagedObject.setValue("70", forKey: "distance")
        newManagedObject.setValue("", forKey: "comment")
        
        // test
        let entityDescription = NSEntityDescription.entity(forEntityName: "Volee", in: DataManager.getContext())
        
        let volee = Volee(entity: entityDescription!, insertInto: DataManager.getContext())
        
        volee.volee = "[]"
        volee.rang = 1
        
        volee.relationship = newManagedObject
        
        
        
        newManagedObject.volees.add(volee)
        
        
    }

    
    
    
   open func insertNewTir() {
        let context = DataManager.getContext()
        let entityDescription = NSEntityDescription.entity(forEntityName: "Tir", in: context)
        
        let tir = Tir(entity: entityDescription!, insertInto: DataManager.getContext())

         insertNewTirObject(tir)
        
        
        
        
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        // Save the context.
        var error: NSError? = nil
        do {
            try context.save()
        } catch let error1 as NSError {
            error = error1
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            if let error = error {
                print("Unresolved error \(error), \(error.userInfo)")
            } else {
                print("Unresolved error (unknown NSError)")
            }
            abort()
        }
        
    }

    
    

}
