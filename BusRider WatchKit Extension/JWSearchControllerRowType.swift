//
//  JWSearchControllerRowType.swift
//  BusRider
//
//  Created by John Wong on 5/2/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import WatchKit

class JWSearchControllerRowType: NSObject {
    @IBOutlet weak var textLabel: WKInterfaceLabel!
    
    func setText(text: String) {
        textLabel.setText(text)
    }
}
