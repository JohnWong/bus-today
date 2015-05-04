//
//  JWArrivingLineRowType.swift
//  BusRider
//
//  Created by John Wong on 5/5/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import WatchKit

class JWArrivingLineRowType: NSObject {
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    
    func setName(name: String) {
        nameLabel.setText("\(name)")
    }
}
