//
//  JWCityInterfaceController.swift
//  BusRider
//
//  Created by John Wong on 4/7/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import WatchKit
import Foundation

class JWCityInterfaceController: WKInterfaceController {
    
    internal let cityRequest = JWCityRequest()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        cityRequest.loadWithCompletion { (result, error) -> Void in
            if let result = result {
                print(result["cities"])
            }
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
