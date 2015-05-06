//
//  JWDetailInterfaceController.swift
//  BusRider
//
//  Created by John Wong on 5/5/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import WatchKit
import Foundation


class JWDetailInterfaceController: WKInterfaceController {

    var lineId = ""
    var order = 0
    var lineRequest = JWLineRequest()
    var busInfoItem = JWBusInfoItem()
    
    
    @IBOutlet weak var lineLabel: WKInterfaceLabel!
    @IBOutlet weak var stopLabel: WKInterfaceLabel!
    @IBOutlet weak var mainLabel: WKInterfaceLabel!
    @IBOutlet weak var unitLabel: WKInterfaceLabel!
    @IBOutlet weak var updateLabel: WKInterfaceLabel!
    @IBOutlet weak var fromLabel: WKInterfaceLabel!
    @IBOutlet weak var toLabel: WKInterfaceLabel!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let dict = context as? NSDictionary {
            lineId = dict["lineId"] as! String
            order = dict["order"] as! Int
            loadData()
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

    @IBAction func loadData() {
        self.lineLabel.setText("--")
        self.stopLabel.setText("")
        self.updateLabel.setText("--")
        self.mainLabel.setText("--")
        self.unitLabel.setText("")
        self.fromLabel.setText("--")
        self.toLabel.setText("--")
        self.timeLabel.setText("--")
        lineRequest.lineId = self.lineId
        lineRequest.loadWithCompletion { [unowned self](result, error) -> Void in
            if let result = result {
                self.busInfoItem = JWBusInfoItem(userStopOrder: self.order, busInfo: result as [NSObject : AnyObject])
                self.renderData()
            }
        }
    }
    
    func renderData() {
        var mainText = ""
        var unitText = ""
        var updateText = ""
        switch (self.busInfoItem.state) {
        case JWBusState.NotStarted:
            mainText = "--"
            updateText = self.busInfoItem.pastTime < 0 ? "上一辆车发出时间不详" : "上一辆车发出\(self.busInfoItem.pastTime)分钟"
            break
        case JWBusState.NotFound:
            mainText = "--"
            updateText = self.busInfoItem.noBusTip
            break
        case JWBusState.Near:
            if (self.busInfoItem.distance < 1000) {
                mainText = "\(self.busInfoItem.distance)"
                unitText = "米"
            } else {
                mainText = NSString(format: "%.1f", Double(self.busInfoItem.distance) / 1000.0) as String
                unitText = "千米"
            }
            updateText = "\(JWFormatter.formatedTime(self.busInfoItem.updateTime))前报告位置"
            break
        case JWBusState.Far:
            mainText = "\(self.busInfoItem.remains)"
            unitText = "站"
            updateText = "\(JWFormatter.formatedTime(self.busInfoItem.updateTime))前报告位置"
            break
        }
    
        self.lineLabel.setText(self.busInfoItem.lineNumber)
        self.stopLabel.setText("距\(self.busInfoItem.currentStop)")
        self.updateLabel.setText(updateText)
        self.mainLabel.setText(mainText)
        self.unitLabel.setText(unitText)
        self.fromLabel.setText(self.busInfoItem.from)
        self.toLabel.setText(self.busInfoItem.to)
        self.timeLabel.setText("\(self.busInfoItem.firstTime)-\(self.busInfoItem.lastTime)")
    }
    
    @IBAction func sendToGlance() {
        var todayItem = JWCollectItem(lineId: self.lineId, lineNumber: self.busInfoItem.lineNumber, from: nil, to: nil, stopName: nil, order: self.order)
        JWUserDefaultsUtil.setTodayBusLine(todayItem)
    }
}
