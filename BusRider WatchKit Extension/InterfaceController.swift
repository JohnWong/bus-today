//
//  InterfaceController.swift
//  BusRider WatchKit Extension
//
//  Created by John Wong on 4/7/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    struct StoryBoard {
        struct Controllers {
            static let searchResult = "searchResult"
            static let selectCity = "selectCity"
        }
    }
    
    @IBOutlet weak var lineLabel: WKInterfaceLabel!
    @IBOutlet weak var stopLabel: WKInterfaceLabel!
    @IBOutlet weak var mainLabel: WKInterfaceLabel!
    @IBOutlet weak var unitLabel: WKInterfaceLabel!
    @IBOutlet weak var updateLabel: WKInterfaceLabel!
    @IBOutlet weak var fromLabel: WKInterfaceLabel!
    @IBOutlet weak var toLabel: WKInterfaceLabel!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    
    @IBOutlet weak var topGroup: WKInterfaceGroup!
    @IBOutlet weak var infoGroup: WKInterfaceGroup!
    @IBOutlet weak var cityButton: WKInterfaceButton!
    @IBOutlet weak var guideGroup: WKInterfaceGroup!
    
    var lineRequest = JWLineRequest()
    var busInfoItem = JWBusInfoItem()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if let cityItem = JWUserDefaultsUtil.cityItem() {
            if !cityItem.cityName.isEmpty {
                self.cityButton.setTitle(cityItem.cityName)
            }
        }
        if JWUserDefaultsUtil.pushSearchController() {
            self.search()
            JWUserDefaultsUtil.setPushSearchController(false)
        }
        
        self.loadData()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func search() {
        if let cityItem = JWUserDefaultsUtil.cityItem() {
            pushControllerWithName(StoryBoard.Controllers.searchResult, context: nil)
        } else {
            presentControllerWithName(StoryBoard.Controllers.selectCity, context: true)
        }
    }
    
    func showLoading() {
        self.lineLabel.setText("--")
        self.stopLabel.setText("")
        self.updateLabel.setText("--")
        self.mainLabel.setText("--")
        self.unitLabel.setText("")
        self.fromLabel.setText("--")
        self.toLabel.setText("--")
        self.timeLabel.setText("--")
    }
    
    func loadData() {
        self.showLoading()
        var todayLine = JWUserDefaultsUtil.todayBusLine()
        if let todayLine = todayLine {
            lineRequest.lineId = todayLine.lineId
            lineRequest.loadWithCompletion { [unowned self](result, error) -> Void in
                if let result = result {
                    self.busInfoItem = JWBusInfoItem(userStopOrder: todayLine.order, busInfo: result as [NSObject : AnyObject])
                    self.renderData()
                }
            }
            self.topGroup.setHidden(false)
            self.infoGroup.setHidden(false)
            self.guideGroup.setHidden(true)
        } else {
            self.topGroup.setHidden(true)
            self.infoGroup.setHidden(true)
            self.guideGroup.setHidden(false)
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
}
