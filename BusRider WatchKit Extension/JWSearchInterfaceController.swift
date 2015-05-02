//
//  JWSearchInterfaceController.swift
//  BusRider
//
//  Created by John Wong on 5/2/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import WatchKit
import Foundation

class JWSearchInterfaceController: WKInterfaceController {

    struct Storyboard {
        static let interfaceControllerName = "JWCityInterfaceController"
        
        struct RowTypes {
            static let item = "JWSearchControllerRowType"
            static let noItem = "JWSearchControllerNoRowType"
        }
    }
    
    var searchRequest = JWSearchRequest()
    var searchItems = JWSearchListItem()
    
    @IBOutlet weak var interfaceTable: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let keyword = context as? String {
            loadData(keyword)
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func loadData(keyword: String) {
        searchRequest.keyWord = keyword
        searchRequest.loadWithCompletion { [unowned self](result, error) -> Void in
            if let result = result {
                self.searchItems = JWSearchListItem(dictionary: result as [NSObject : AnyObject])
                self.interfaceTable.setNumberOfRows(self.searchItems.lineList.count + self.searchItems.stopList.count, withRowType: Storyboard.RowTypes.item)
                for index in 0 ..< self.searchItems.lineList.count + self.searchItems.stopList.count {
                    self.configureRowControllerAtIndex(index)
                }
            }
        }
    }
    
    func configureRowControllerAtIndex(index: Int) {
        let itemRowController = interfaceTable.rowControllerAtIndex(index) as! JWSearchControllerRowType
        if index < self.searchItems.lineList.count {
            var item: JWSearchLineItem = self.searchItems.lineList[index] as! JWSearchLineItem
            itemRowController.setText(item.lineNumber)
        } else {
            var item: JWSearchStopItem = self.searchItems.stopList[index - self.searchItems.lineList.count] as! JWSearchStopItem
            itemRowController.setText(item.stopName)
        }
    }

}
