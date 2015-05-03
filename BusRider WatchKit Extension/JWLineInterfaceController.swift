//
//  JWLineInterfaceController.swift
//  BusRider
//
//  Created by John Wong on 5/3/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import WatchKit
import Foundation


class JWLineInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var lineNumberLabel: WKInterfaceLabel!
    @IBOutlet weak var startLabel: WKInterfaceLabel!
    @IBOutlet weak var stopLabel: WKInterfaceLabel!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    
    struct Storyboard {
        struct RowTypes {
            static let item = "lineRow"
        }
    }

    @IBOutlet weak var interfaceTable: WKInterfaceTable!
    
    var lineId = ""
    var busLineItem = JWBusLineItem()
    let lineRequest = JWLineRequest()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let lineId = context as? String {
            self.lineId = lineId
        }
        loadData()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func configureRowControllerAtIndex(index: Int, text: String) {
        let itemRowController = interfaceTable.rowControllerAtIndex(index) as! JWLineRowType
        itemRowController.setNumber(index + 1, name: text)
    }
    
    func loadData() {
        self.lineNumberLabel.setText("--")
        self.startLabel.setText("--")
        self.stopLabel.setText("--")
        self.timeLabel.setText("--")
        self.lineRequest.lineId = lineId
        self.lineRequest.loadWithCompletion { [unowned self](result, error) -> Void in
            if let result = result {
                self.busLineItem = JWBusLineItem(dictionary: result as [NSObject : AnyObject])
                var lineItem = self.busLineItem.lineItem
                self.lineNumberLabel.setText("\(lineItem.lineNumber)")
                self.startLabel.setText("\(lineItem.from)")
                self.stopLabel.setText("\(lineItem.to)")
                self.timeLabel.setText("\(lineItem.firstTime)-\(lineItem.lastTime)")
                var stopItems = self.busLineItem.stopItems
                self.interfaceTable.setNumberOfRows(stopItems.count, withRowType: Storyboard.RowTypes.item)
                for index in 0 ..< stopItems.count {
                    var stopItem: JWStopItem = stopItems[index] as! JWStopItem
                    self.configureRowControllerAtIndex(index, text: stopItem.stopName)
                }
            } else {
                self.lineNumberLabel.setText("未找到线路")
                self.interfaceTable.setNumberOfRows(0, withRowType: Storyboard.RowTypes.item)
            }
        }
    }

}
