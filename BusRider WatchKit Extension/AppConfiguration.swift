//
//  AppConfiguration.swift
//  BusRider
//
//  Created by John Wong on 4/7/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import Foundation

class AppConfiguration {
    class var host: String {
        return "api.chelaile.net.cn:7000"
//        return "localhost:7000"
    }
    
    struct Notifications {
        static let NotificationContextUpdate = "NotificationContextUpdate"
    }
    
    static let Debug = NSBundle.mainBundle().objectForInfoDictionaryKey("Debug") as? String == "YES"
    
    class var dataErrorDomain: String {
        return "JWDataError"
    }
}