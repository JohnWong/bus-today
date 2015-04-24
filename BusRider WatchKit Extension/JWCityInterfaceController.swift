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
        }
    }
    
    @IBOutlet weak var interfaceTable: WKInterfaceTable!
    
    var cities = Array<JWCityItem>()
    let cityRequest = JWCityRequest()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.interfaceTable.setNumberOfRows(1, withRowType: Storyboard.RowTypes.noItem)
        
        cityRequest.loadWithCompletion { (result, error) -> Void in
            if let result = result {
                if let cities = result["cities"]! as? NSArray {
                    self.cities.removeAll(keepCapacity: true)
                    for dict in cities {
                        self.cities.append(JWCityItem(dictionary: dict as! [NSObject : AnyObject]))
                    }
                    self.interfaceTable.setNumberOfRows(cities.count, withRowType: Storyboard.RowTypes.item)
                    print(cities)
                    for index in 0..<cities.count {
                        self.configureRowControllerAtIndex(index)
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
