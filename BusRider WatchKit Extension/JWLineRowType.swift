//
//  JWLineRowType.swift
//  BusRider
//
//  Created by John Wong on 5/3/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit
import WatchKit

class JWLineRowType: NSObject {
    
    @IBOutlet weak var numberLabel: WKInterfaceLabel!
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    
    func setNumber(number: Int, name: String) {
        numberLabel.setText("\(number)")
        nameLabel.setText("\(name)")
    }
}
