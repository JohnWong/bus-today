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
    
    override func params() -> Dictionary<NSObject, AnyObject> {
        let encodedKeyword: String = self.keyword.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet())!
        return [
            "LsName": encodedKeyword
        ]
    }
    
    override func actionName() -> String {
        return "query!search"
    }
}
