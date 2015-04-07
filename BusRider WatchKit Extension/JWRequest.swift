//
//  JWRequest.swift
//  BusRider
//
//  Created by John Wong on 4/7/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import Foundation

public class JWRequest: NSObject {
    var request:STHTTPRequest?
    
    internal override init() {
        super.init()
    }
    
    public func params() -> Dictionary<String, AnyObject> {
        return Dictionary()
    }
    
    public func actionName() -> String {
        return ""
    }
    
    internal func urlPath() -> NSString {
        var paramString = String()
        for (key, value) in self.params() {
            paramString = paramString.stringByAppendingFormat("&%@=%@", key, value.string)
        }
        var cityId = "";
        var cityItem = JWUserDefaultsUtil.cityItem()
        if  let cityItem = cityItem {
            cityId = String(format: "&cityId=%@", cityItem.cityId)
        }
        return String(format: "http://%@/%@/%@.action?s=IOS&v=2.9%@&sign=%@", AppConfiguration.host, self.isKindOfClass(NSClassFromString("JWCityRequest")) ? "wow" : "bus", self.actionName(), cityId, paramString)
    }
    
    public func loadWithCompletion(completion:(NSDictionary, NSError)) {
        request?.cancel();
        self.request = STHTTPRequest(URLString: self.urlPath())
    }
}