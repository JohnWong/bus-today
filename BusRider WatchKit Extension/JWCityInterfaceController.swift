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
            static let noItem = "JWCityControllerNoRowType"
            static let errorItem = "JWCityControllerErrorRowType"
        }
        
        struct Controllers {
            static let searchResult = "searchResult"
        }
    }
    
    @IBOutlet weak var interfaceTable: WKInterfaceTable!
    
    var cities = Array<JWCityItem>()
    let cityRequest = JWCityRequest()
    var isPushSearchController: Bool?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let context = context as? Bool {
            isPushSearchController = context
        }
        self.interfaceTable.setNumberOfRows(1, withRowType: Storyboard.RowTypes.noItem)
        
        
        cityRequest.loadWithCompletion { [weak self](result, error) -> Void in
            if let weakSelf = self {
                if let _ = error {
                    weakSelf.interfaceTable.setNumberOfRows(1, withRowType: Storyboard.RowTypes.errorItem)
                    let itemRowController = weakSelf.interfaceTable.rowControllerAtIndex(0) as! JWCityControllerRowType
                    itemRowController.setText(error.localizedDescription);
                } else if let _ = result, cityArray: NSArray = result[kJWData]! as? NSArray {
                    weakSelf.cities = cityArray as! Array<JWCityItem>
                    weakSelf.interfaceTable.setNumberOfRows(weakSelf.cities.count, withRowType: Storyboard.RowTypes.item)
                    for index in 0 ..< weakSelf.cities.count {
                        weakSelf.configureRowControllerAtIndex(index)
                    }
                }
            }
        }
    }
    
    func configureRowControllerAtIndex(index: Int) {
        let itemRowController = interfaceTable.rowControllerAtIndex(index) as! JWCityControllerRowType
        let item = cities[index]
        itemRowController.setText(item.cityName);
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let city = self.cities[rowIndex]
        JWUserDefaultsUtil.setCityItem(city)
        JWSessionManager.defaultManager().sync()
        if let isPushSearchController = isPushSearchController {
            JWUserDefaultsUtil.setPushSearchController(isPushSearchController)
        }
        self.dismissController()
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
