//
//  JWLineRequest.swift
//  BusRider
//
//  Created by John Wong on 5/3/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class JWLineRequest: JWRequest {
    
    var lineId = ""
    
    
    override func params() -> Dictionary<NSObject, AnyObject> {
        return [
            "lineId": self.lineId
        ]
    }
    
    override func actionName() -> String {
        return "line!map2"
    }
}
