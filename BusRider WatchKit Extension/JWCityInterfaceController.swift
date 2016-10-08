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
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let context = context as? Bool {
            isPushSearchController = context
        }
        self.interfaceTable.setNumberOfRows(1, withRowType: Storyboard.RowTypes.noItem)
        
        
        cityRequest.load { [weak self](result, error) -> Void in
            if let weakSelf = self {
                if let error = error {
                    weakSelf.interfaceTable.setNumberOfRows(1, withRowType: Storyboard.RowTypes.errorItem)
                    let itemRowController = weakSelf.interfaceTable.rowController(at: 0) as! JWCityControllerRowType
                    itemRowController.setText(error.localizedDescription);
                } else if let _ = result, let cityArray: NSArray = result?[kJWData]! as? NSArray {
                    weakSelf.cities = cityArray as! Array<JWCityItem>
                    weakSelf.interfaceTable.setNumberOfRows(weakSelf.cities.count, withRowType: Storyboard.RowTypes.item)
                    for index in 0 ..< weakSelf.cities.count {
                        weakSelf.configureRowControllerAtIndex(index)
                    }
                }
            }
        }
    }
    
    func configureRowControllerAtIndex(_ index: Int) {
        let itemRowController = interfaceTable.rowController(at: index) as! JWCityControllerRowType
        let item = cities[index]
        itemRowController.setText(item.cityName);
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let city = self.cities[rowIndex]
        JWUserDefaultsUtil.setCityItem(city)
        JWSessionManager.default().sync()
        if let isPushSearchController = isPushSearchController {
            JWUserDefaultsUtil.setPushSearchController(isPushSearchController)
        }
        self.dismiss()
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
