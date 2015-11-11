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
    
    func applicationDidBecomeActive() {
        
    }
    
    func applicationDidFinishLaunching() {
        WCSession.defaultSession().delegate = self
        WCSession.defaultSession().activateSession()
    }
    
    func applicationWillResignActive() {
        
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        
    }
    
}