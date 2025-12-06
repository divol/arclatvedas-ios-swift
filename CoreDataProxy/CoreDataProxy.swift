//
//  CoreDataProxy.swift
//  arclatvedas
//
//  Created by divol on 22/05/2015.
// from http://makeandbuild.com/blog/post/watchkit-with-shared-core-data

import CoreData





open class CoreDataProxy:NSObject{
    
    
    let sharedAppGroup:String = "group.com.jack.arclatvedas"
    
    open class var sharedInstance : CoreDataProxy {
        struct Static {
            static let instance : CoreDataProxy = CoreDataProxy()
        }
        
        return Static.instance
    }

    
    // MARK: - Core Data stack
    
    open lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.makeandbuild.ActivityBuilder" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] 
        }()
    
    

    
    
    open lazy var managedObjectModel: NSManagedObjectModel = {
        var proxyBundle = Bundle(identifier: "com.jack.CoreDataProxy")
        if proxyBundle == nil {
            proxyBundle = Bundle.main
        }
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = proxyBundle?.url(forResource: "arclatvedas", withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOf: modelURL!)!
        }()
    
    
    
   open lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        
        var sharedContainerURL: URL? = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.sharedAppGroup)
    var storeURL: URL?
    
        if let lsharedContainerURL = sharedContainerURL {
        
            storeURL = lsharedContainerURL.appendingPathComponent("arclatvedas.sqlite")
             NSLog((storeURL?.description)!)
        }else{
            storeURL = self.applicationDocumentsDirectory.appendingPathComponent("arclatvedas.sqlite")

        }
            var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            
            var error: NSError? = nil
            var failureReason = "There was an error creating or loading the application's saved data."
            //mOptions pour la mise a jour
            let mOptions = [NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true]
            
            do {
                try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: mOptions)
            } catch var error1 as NSError {
                error = error1
                coordinator = nil
                // Report any error we got.
                var dict = [String: AnyObject]()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
                dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
                dict[NSUnderlyingErrorKey] = error
                error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
                // Replace this with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
               // NSLog("Unresolved error \(error), \(error!.userInfo)")
                let errorDescription = (error as NSError?)?.localizedDescription ?? "Unknown error"
                let errorUserInfo = (error as NSError?)?.userInfo ?? [:]
                NSLog("Unresolved error: \(errorDescription), \(errorUserInfo)")
                
                
                abort()
            } catch {
                fatalError()
            }
            
            return coordinator
        
        }()

    
    
    open lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    open func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let errorDescription = (error as NSError?)?.localizedDescription ?? "Unknown error"
                    let errorUserInfo = (error as NSError?)?.userInfo ?? [:]
                    NSLog("Unresolved error: \(errorDescription), \(errorUserInfo)")
                    abort()
                }
            }
        }
    }
    

}
