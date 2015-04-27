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
            let searchResult = "searchResult"
        }
    }

    @IBOutlet weak var cityButton: WKInterfaceButton!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if let cityItem = JWUserDefaultsUtil.cityItem() {
            if !cityItem.cityName.isEmpty {
                self.cityButton.setTitle(cityItem.cityName)
            }
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
//    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
//        println("\(sender)")
//    }

    @IBAction func openInputController() {
        #if DEBUG
            pushControllerWithName(StoryBoard.Controllers.searchResult, context: "311")
        #endif
        
        // TODO 收藏的路线
        let initialPhrases = [
            "311",
            "211",
            "59"
        ]
        self.presentTextInputControllerWithSuggestions(initialPhrases, allowedInputMode: WKTextInputMode.Plain) {
            (results) -> Void in
            if let results = results {
                if results.count > 0 {
                    let aResult = results[0] as! String;
                    
                }
            } else {
                // Nothing was selected.
            }
        }
    }
}
