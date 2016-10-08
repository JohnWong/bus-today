//
//  ExtensionDelegate.swift
//  BusRider
//
//  Created by John Wong on 11/10/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class ExtensionDelegate : NSObject, WKExtensionDelegate, WCSessionDelegate {
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(watchOS 2.2, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }

    
    func applicationDidBecomeActive() {
        
    }
    
    func applicationDidFinishLaunching() {
        JWSessionManager.default().activate()
    }
    
    func applicationWillResignActive() {
        
    }
    
}
