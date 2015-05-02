//
//  InterfaceController.swift
//  BusRider WatchKit Extension
//
//  Created by John Wong on 4/7/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    struct StoryBoard {
        struct Controllers {
            static let searchResult = "searchResult"
            static let selectCity = "selectCity"
        }
    }
    
    @IBOutlet weak var cityButton: WKInterfaceButton!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if let cityItem = JWUserDefaultsUtil.cityItem() {
            if !cityItem.cityName.isEmpty {
                self.cityButton.setTitle(cityItem.cityName)
            }
        }
        if JWUserDefaultsUtil.pushSearchController() {
            self.search()
            JWUserDefaultsUtil.setPushSearchController(false)
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func search() {
        if let cityItem = JWUserDefaultsUtil.cityItem() {
            pushControllerWithName(StoryBoard.Controllers.searchResult, context: nil)
        } else {
            presentControllerWithName(StoryBoard.Controllers.selectCity, context: true)
        }
    }
}
