//
//  WatchSessionManager.swift
//  arclatvedas
//
//  Created by divol on 03/05/2016.
//  Copyright © 2016 jack. All rights reserved.
//

//
//  WatchSessionManager.swift
//  WCApplicationContextDemo
//
//  Created by Natasha Murashev on 9/22/15.
//  Copyright © 2015 NatashaTheRobot. All rights reserved.
//

import WatchConnectivity
import CoreData
import CoreDataProxy


protocol DataSourceChangedDelegate {
    func dataSourceDidUpdate(_ userInfo: [String : AnyObject])
}


//@available(iOS 9.0, *)
class WatchSessionManager: NSObject, WCSessionDelegate {
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    

    
    
    
    
    /** Called when all delegate callbacks for the previously selected watch has occurred. The session can be re-activated for the now selected watch using activateSession. */
    @available(iOS 9.3, *)
    public func sessionDidDeactivate(_ session: WCSession)
    
    {
        
    }
    
    @available(iOS 9.3, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    @available(iOS 9.3, *)
    public func sessionDidBecomeInactive(_ session: WCSession){
        
    }
    
    static let sharedManager = WatchSessionManager()
    fileprivate override init() {
        super.init()
    }
    fileprivate var dataSourceChangedDelegates = [DataSourceChangedDelegate]()
    fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    fileprivate var validSession: WCSession? {
        
        // paired - the user has to have their device paired to the watch
        // watchAppInstalled - the user must have your watch app installed
        
        // Note: if the device is paired, but your watch app is not installed
        // consider prompting the user to install it for a better experience
        
        if let session = session, session.isPaired && session.isWatchAppInstalled {
            return session
        }
        return nil
    }
    
    func startSession() {
        session?.delegate = self
        session?.activate()
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
//@available(iOS 9.0, *)
extension WatchSessionManager {
    
    // Sender
    func transferUserInfo(_ userInfo: [String : AnyObject]) -> WCSessionUserInfoTransfer? {
        return validSession?.transferUserInfo(userInfo)
    }
    
    // Receiver
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any])
    {
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
