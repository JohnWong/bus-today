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
            static let arrivingItem = "arrivingRow"
        }
        
        struct Controllers {
            static let detailInterface = "detailInterface"
        }
    }

    @IBOutlet weak var interfaceTable: WKInterfaceTable!
    
    var lineId = ""
    var busLineItem = JWBusLineItem()
    let lineRequest = JWLineRequest()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let lineId = context as? String {
            self.lineId = lineId
        } else {
            // TODO mock
            self.lineId = "0571-0428-0"
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
    
    func configureRowControllerAtIndex(_ index: Int, text: String) {
        let rowController: AnyObject? = interfaceTable.rowController(at: index) as AnyObject?
        if let itemRowController = rowController as? JWLineRowType {
            itemRowController.setNumber(index + 1, name: text)
        } else if let itemRowController = rowController as? JWArrivingLineRowType {
            itemRowController.setName(text)
        }
    }
    
    @IBAction func loadData() {
        self.lineNumberLabel.setText("--")
        self.startLabel.setText("--")
        self.stopLabel.setText("--")
        self.timeLabel.setText("--")
        self.interfaceTable.setNumberOfRows(0, withRowType: Storyboard.RowTypes.item)
        self.lineRequest.lineId = lineId
        self.lineRequest.load { [weak self](result, error) -> Void in
            if let weakSelf = self {
                if let _ = error {
                    weakSelf.lineNumberLabel.setText("未找到线路")
                    weakSelf.interfaceTable.setNumberOfRows(0, withRowType: Storyboard.RowTypes.item)
                } else if let _ = result {
                    weakSelf.busLineItem = JWBusLineItem(dictionary: result! as [AnyHashable: Any])
                    let lineItem = weakSelf.busLineItem?.lineItem
                    weakSelf.lineNumberLabel.setText("\(lineItem?.lineNumber ?? "")")
                    weakSelf.startLabel.setText("\(lineItem?.from ?? "")")
                    weakSelf.stopLabel.setText("\(lineItem?.to ?? "")")
                    weakSelf.timeLabel.setText("\(lineItem?.firstTime ?? "")-\(lineItem?.lastTime  ?? "")")
                    var stopItems = weakSelf.busLineItem?.stopItems
                    var stopIds = Set<Int>()
                    for item in (weakSelf.busLineItem?.busItems)! {
                        if let busItem = item as? JWBusItem {
                            stopIds.insert(busItem.order)
                        }
                    }
                    
                    var rowTypes = Array<String>(repeating: Storyboard.RowTypes.item, count: (stopItems?.count)!)
                    for index in  0 ..< stopItems!.count {
                        if let stopItem = stopItems![index] as? JWStopItem {
                            if stopIds.contains(stopItem.order) {
                                rowTypes[index] = Storyboard.RowTypes.arrivingItem
                            }
                        }
                    }
                    
                    weakSelf.interfaceTable.setRowTypes(rowTypes)
                    
                    for index in 0 ..< stopItems!.count {
                        if let stopItem: JWStopItem = stopItems![index] as? JWStopItem {
                            weakSelf.configureRowControllerAtIndex(index, text: stopItem.stopName)
                        }
                    }
                }
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        if let stopItem = self.busLineItem?.stopItems[rowIndex] as? JWStopItem {
            self.pushController(withName: "detailInterface", context: [
                "order": stopItem.order,
                "lineId": self.busLineItem?.lineItem.lineId ?? ""])
        }
    }

    @IBAction func reverseDirection() {
        if let _ = self.busLineItem?.lineItem , (self.busLineItem?.lineItem.otherLineId.lengthOfBytes(using: String.Encoding.utf8))! > 0 {
            self.lineId = (self.busLineItem?.lineItem.otherLineId)!
            self.loadData()
        }
    }
}
