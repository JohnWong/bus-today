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
    var busInfoItem: JWBusInfoItem!
    
    
    @IBOutlet weak var lineLabel: WKInterfaceLabel!
    @IBOutlet weak var stopLabel: WKInterfaceLabel!
    @IBOutlet weak var mainLabel: WKInterfaceLabel!
    @IBOutlet weak var updateLabel: WKInterfaceLabel!
    @IBOutlet weak var fromLabel: WKInterfaceLabel!
    @IBOutlet weak var toLabel: WKInterfaceLabel!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    @IBOutlet weak var sendButton: WKInterfaceButton!
    
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
        self.fromLabel.setText("--")
        self.toLabel.setText("--")
        self.timeLabel.setText("--")
        lineRequest.lineId = self.lineId
        lineRequest.targetOrder = self.order;
        lineRequest.loadWithCompletion { [weak self](result, error) -> Void in
            if let weakSelf = self {
                if let _ = error {
                    
                } else if let result = result {
                    weakSelf.busInfoItem = JWBusInfoItem(userStopOrder: weakSelf.order, busInfo: result as [NSObject : AnyObject])
                    weakSelf.renderData()
                }
            }
        }
    }
    
    func renderData() {
        let info = self.busInfoItem.calulateInfo()
        let mainText = info[0] as! NSAttributedString
        let updateText = info[1] as! String
    
        self.lineLabel.setText(self.busInfoItem.lineNumber)
        self.updateLabel.setText(updateText)
        self.stopLabel.setText("到达\(self.busInfoItem.currentStop)")
        self.mainLabel.setAttributedText(mainText)
        self.fromLabel.setText(self.busInfoItem.from)
        self.toLabel.setText(self.busInfoItem.to)
        self.timeLabel.setText("\(self.busInfoItem.firstTime)-\(self.busInfoItem.lastTime)")
    }
    
    @IBAction func sendToGlance() {
        let todayItem = JWCollectItem(lineId: self.lineId, lineNumber: self.busInfoItem.lineNumber, from: nil, to: nil, stopName: nil, order: self.order)
        JWUserDefaultsUtil.setTodayBusLine(todayItem)
        JWSessionManager.defaultManager().sync()
        sendButton.setTitle("已发送")
        self.popToRootController();
    }
}
