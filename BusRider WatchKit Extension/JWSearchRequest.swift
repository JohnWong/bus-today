//
//  JWSearchRequest.swift
//  BusRider
//
//  Created by John Wong on 5/2/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class JWSearchRequest: JWRequest {
   
    var keyword = ""
    
    override func params() -> Dictionary<String, AnyObject> {
        let encodedKeyword = self.keyword.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        return [
            "LsName": encodedKeyword
        ]
    }
    
    override func actionName() -> String {
        return "query!search"
    }
}
