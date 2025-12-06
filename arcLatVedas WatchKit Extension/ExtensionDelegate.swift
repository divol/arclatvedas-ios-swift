//
//  ExtensionDelegate.swift
//  arclatvedas
//
//  Created by divol on 03/05/2016.
//  Copyright © 2016 jack. All rights reserved.
//


import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    func applicationDidFinishLaunching() {
        WatchSessionManager.sharedManager.startSession()
    }
    
    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    // New in place of deprecated WKInterfaceController.handleUserActivity(_:)
    func handleUserActivity(_ userInfo: [AnyHashable : Any]?) {
        // Route the activity to the current controller if needed.
        // Example: you could inspect userInfo and update UI or navigate.
        // If you need to reach a specific controller:
        // WKInterfaceController.reloadRootControllers(withNames: ["TirInterfaceController"], contexts: [userInfo as Any])
    }
}
