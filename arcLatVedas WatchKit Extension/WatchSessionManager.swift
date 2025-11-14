//
//  WatchSessionManager.swift
//  arclatvedas
//
//  Created by divol on 03/05/2016.
//  Copyright © 2016 jack. All rights reserved.
//

//
//  WatchSessionManager.swift
//  WCUserInfoDemo
//
//  Created by Natasha Murashev on 10/12/15.
//  Copyright © 2015 NatashaTheRobot. All rights reserved.
//
import Foundation

import WatchConnectivity


import WatchKit
import CoreData

protocol DataSourceChangedDelegate {
    func dataSourceDidUpdate(_ userInfo: [String : AnyObject])
}

class WatchSessionManager: NSObject, WCSessionDelegate {
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(watchOS 2.2, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }

    
    static let sharedManager = WatchSessionManager()
    fileprivate override init() {
        super.init()
    }
    
    fileprivate let session: WCSession = WCSession.default()
    
    fileprivate var dataSourceChangedDelegates = [DataSourceChangedDelegate]()
    
    func startSession() {
        session.delegate = self
        session.activate()
    }
    
    func addDataSourceChangedDelegate<T>(_ delegate: T) where T: DataSourceChangedDelegate, T: Equatable {
        dataSourceChangedDelegates.append(delegate)
    }
    
    func removeDataSourceChangedDelegate<T>(_ delegate: T) where T: DataSourceChangedDelegate, T: Equatable {
        for (index, dataSourceDelegate) in dataSourceChangedDelegates.enumerated() {
            if let dataSourceDelegate = dataSourceDelegate as? T, dataSourceDelegate == delegate {
                dataSourceChangedDelegates.remove(at: index)
                break
            }
        }
    }
}

// MARK: User Info
// use when your app needs all the data
// FIFO queue
extension WatchSessionManager {
    
    
    // Sender
    func transferUserInfo(_ userInfo: [String : AnyObject]) -> WCSessionUserInfoTransfer? {
        return session.transferUserInfo(userInfo)
    }
    
    
    // Receiver
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any]) {
        // handle receiving user info
        
        DispatchQueue.main.async { [weak self] in
                let wutils:WatchUtils = WatchUtils()
                for (action, value) in userInfo {
                    
                    //print(action, " ",param)
                    let ti:AnyObject = wutils.getLastTir()
                    
                    
                    switch action {
                        case "insertNewTir":
                            wutils.insertNewTir()
                        break
                        
                        case "createEmptyVolee":
                            
                            
                            if let tir:Tir = ti as? Tir {
                                wutils.createEmptyVolee(tir)
                            }
                           

                            
                            
                        break
                        case "deleteScore":
                             if let tir:Tir = ti as? Tir {
                                if let vol:Volee = tir.volees.object(at: tir.volees.count-1) as? Volee {
                                    
                                    vol.deleteLast()
                                }
                            }

                        break
                        case "addScore":
                             if let tir:Tir = ti as? Tir {
                                if let vol:Volee = tir.volees.object(at: tir.volees.count-1) as? Volee {
                                    
                                    vol.addScore(value as! Int , impact:CGPoint(x: 0,y: 0),zone:CGPoint(x: 0,y: 0))
                                }
                            }
  
                        break
                        default: break
                        
                        
                    }
                     DataManager.saveManagedContext()
                    
                }

            
            
                self?.dataSourceChangedDelegates.forEach {
                    $0.dataSourceDidUpdate(userInfo as [String : AnyObject])
                
            }
        }
    }
    
}
