//
//  JWRequest.swift
//  BusRider
//
//  Created by John Wong on 4/7/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import Foundation

class JWRequest: NSObject {
    var request:STHTTPRequest?
    
    internal override init() {
        super.init()
    }
    
    func params() -> Dictionary<String, AnyObject> {
        return Dictionary()
    }
    
    func actionName() -> String {
        return ""
    }
    
    internal func urlPath() -> String {
        var paramString = String()
        for (key, value) in self.params() {
            paramString = paramString.stringByAppendingString("&\(key)=\(value)")
        }
        var cityId = "";
        let cityItem = JWUserDefaultsUtil.cityItem()
        if  let cityItem = cityItem {
            cityId = String(format: "&cityId=%@", cityItem.cityId)
        }
        return String(format: "http://%@/%@/%@.action?s=IOS&v=2.9%@&sign=%@", AppConfiguration.host, self.isKindOfClass(JWCityRequest) ? "wow" : "bus", self.actionName(), cityId, paramString)
    }
    
    func loadWithCompletion(completion:(NSDictionary?, NSError?) -> Void) {
        request?.cancel();
        self.request = STHTTPRequest(URLString: self.urlPath())
        self.request?.completionBlock = {
            (headers: Dictionary!, body: String!) in
            let correctString = body as NSString
            let jsonString = correctString.stringByReplacingOccurrencesOfString("**YGKJ", withString: "").stringByReplacingOccurrencesOfString("YGKJ##", withString: "", options: NSStringCompareOptions(), range: nil)
            let jsonObject: AnyObject
            do {
                let data: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!;
                jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                let dict = jsonObject as! NSDictionary
                let jsonr: NSDictionary = dict["jsonr"] as! NSDictionary
                let infoDict: NSDictionary = jsonr["data"] as! NSDictionary
                if infoDict.count > 0 {
                    completion(infoDict, nil);
                } else {
                    let error = NSError(
                        domain: AppConfiguration.dataErrorDomain,
                        code: 301,
                        userInfo: [
                            NSLocalizedDescriptionKey: jsonr
                        ])
                    completion(nil, error)
                }
            } catch let error as NSError {
                completion(nil, error);
            }
        }
        self.request?.errorBlock = {
            (error: NSError?) in
            if error?.code == 1 {
                return
            }
            completion(nil, error)
        }
        self.request?.startAsynchronous()
    }
}