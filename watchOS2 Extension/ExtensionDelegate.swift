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
        if let _ = applicationContext["city"] {
            let city = JWCityItem()
            city.setFromDictionary(applicationContext["city"] as! [NSObject : AnyObject])
            JWUserDefaultsUtil.setCityItem(city);
        }
        if let _ = applicationContext["today"] {
            let today = JWCollectItem()
            today.setFromDictionary(applicationContext["today"] as! [NSObject : AnyObject])
            JWUserDefaultsUtil.setTodayBusLine(today)
            NSNotificationCenter.defaultCenter().postNotificationName(AppConfiguration.Notifications.NotificationContextUpdate, object: nil)
        }
    }
}