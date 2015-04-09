//
//  JWCityControllerRowType.swift
//  BusRider
//
//  Created by John Wong on 4/10/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import WatchKit
import Foundation

class JWCityControllerRowType: NSObject {
    
    @IBOutlet weak var textLabel: WKInterfaceLabel!
    
    func setText(text: String) {
        textLabel.setText(text)
    }
}