//
//  AppDelegate.swift
//  arclatvedas
//
//  Created by divol on 23/04/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit
import CoreData
import CoreDataProxy

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 9.0, *) {
            WatchSessionManager.sharedManager.startSession()
        } else {
            // Fallback on earlier versions
        }
        
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        
        
        
//        splitViewController.presentsWithGesture = false // SplitView won't recognize right swipe
//        splitViewController.preferredDisplayMode = .PrimaryHidden

        
        
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self

       // let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
       // let controller = masterNavigationController.topViewController as! MasterViewController
      //  controller.managedObjectContext = self.managedObjectContext
        
        
        
        let spinloader = SpinCharteLoader()
        spinloader.bootCharte()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
        
         CoreDataProxy.sharedInstance.saveContext()
    }

    
    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool{
        
        
        let type =   userActivity.activityType
        let userInfo = userActivity.userInfo
        
        
        // Assume the app delegate has a text field to display the activity information
        NSLog("iphone User activity is of type %@, and user info %@", type, userInfo!);

        if let win = window {
            let navController = win.rootViewController as! UINavigationController
            let viewController = navController.topViewController! as UIViewController
            navController.popToRootViewController(animated: true)
            viewController.restoreUserActivityState(userActivity)
        }
        
        return true


    }
    
    
    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        if let secondaryAsNavController = secondaryViewController as? UINavigationController {
            if let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController {
                if topAsDetailController.detailItem == nil {
                    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
                    return true
                }
            }else if let topAsDetailController = secondaryAsNavController.topViewController as? TargetController {
                
                if topAsDetailController.detailItem == nil {
                    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
                    return true
                }
            }

        }
        return false
    }
//    // MARK: - Core Data stack
//
//    lazy var applicationDocumentsDirectory: NSURL = {
//        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.jack.arclatvedas" in the application's documents Application Support directory.
//        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        return urls[urls.count-1] as! NSURL
//    }()
//
//    lazy var managedObjectModel: NSManagedObjectModel = {
//        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
//        let modelURL = NSBundle.mainBundle().URLForResource("arclatvedas", withExtension: "momd")!
//        return NSManagedObjectModel(contentsOfURL: modelURL)!
//    }()
//
//    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
//        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
//        // Create the coordinator and store
//        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("arclatvedas.sqlite")
//        var error: NSError? = nil
//        var failureReason = "There was an error creating or loading the application's saved data."
//        //mOptions pour la mise a jour
//        let mOptions = [NSMigratePersistentStoresAutomaticallyOption: true,
//            NSInferMappingModelAutomaticallyOption: true]
//        
//        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: mOptions, error: &error) == nil {
//            coordinator = nil
//            // Report any error we got.
//            var dict = [String: AnyObject]()
//            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
//            dict[NSLocalizedFailureReasonKey] = failureReason
//            dict[NSUnderlyingErrorKey] = error
//            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
//            // Replace this with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog("Unresolved error \(error), \(error!.userInfo)")
//            abort()
//        }
//        
//        return coordinator
//    }()
//
//    lazy var managedObjectContext: NSManagedObjectContext? = {
//        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
//        let coordinator = self.persistentStoreCoordinator
//        if coordinator == nil {
//            return nil
//        }
//        var managedObjectContext = NSManagedObjectContext()
//        managedObjectContext.persistentStoreCoordinator = coordinator
//        return managedObjectContext
//    }()
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        if let moc = self.managedObjectContext {
//            var error: NSError? = nil
//            if moc.hasChanges && !moc.save(&error) {
//                // Replace this implementation with code to handle the error appropriately.
//                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                NSLog("Unresolved error \(error), \(error!.userInfo)")
//                abort()
//            }
//        }
//    }
//    
    
    

    // MARK: - WatchKit communication point
    
    
    func application(_ application: UIApplication,
        handleWatchKitExtensionRequest userInfo: [AnyHashable: Any]?,
        reply: (@escaping ([AnyHashable: Any]?) -> Void)) {
            
            // 1
            if let userInfo = userInfo, let request = userInfo["request"] as? String {
                if request == "refreshData" {
                    // 2
                    let hello = "hello, back"
                    
                    // 3 (modern archiving API with secure coding)
                    do {
                        let data = try NSKeyedArchiver.archivedData(withRootObject: hello, requiringSecureCoding: true)
                        reply(["response": data])
                    } catch {
                        // If archiving fails, fall back to sending the raw string
                        reply(["response": hello])
                    }
                    return
                }
            }
            
            // 4
            reply([:])
    }
    


}

