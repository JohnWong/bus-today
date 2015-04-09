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
    
    struct Storyboard {
        static let interfaceControllerName = "JWCityInterfaceController"
        
        struct RowTypes {
            static let item = "JWCityControllerRowType"
//            static let noItems = "ListControllerNoItemsRowType"
        }
    }
    
    @IBOutlet weak var interfaceTable: WKInterfaceTable!
    
    let cityRequest = JWCityRequest()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        cityRequest.loadWithCompletion { (result, error) -> Void in
            if let result = result {
                if let cities = result["cities"]! as? NSArray {
                    self.interfaceTable.setNumberOfRows(cities.count, withRowType: Storyboard.RowTypes.item)
                    print(cities)
                }
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
