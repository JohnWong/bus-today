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
    @IBOutlet weak var updateLabel: WKInterfaceLabel!
    @IBOutlet weak var fromLabel: WKInterfaceLabel!
    @IBOutlet weak var toLabel: WKInterfaceLabel!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    
    @IBOutlet weak var topGroup: WKInterfaceGroup!
    @IBOutlet weak var infoGroup: WKInterfaceGroup!
    @IBOutlet weak var cityButton: WKInterfaceButton!
    @IBOutlet weak var guideGroup: WKInterfaceGroup!
    
    var lineRequest = JWLineRequest()
    var busInfoItem: JWBusInfoItem!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        NotificationCenter.default.addObserver(self, selector: #selector(InterfaceController.reload), name: NSNotification.Name(rawValue: kNotificationContextUpdate), object: nil)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        self.reload()
        if JWUserDefaultsUtil.pushSearchController() {
            self.search()
            JWUserDefaultsUtil.setPushSearchController(false)
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func search() {
        if let _ = JWUserDefaultsUtil.cityItem() {
            pushController(withName: StoryBoard.Controllers.searchResult, context: nil)
        } else {
            presentController(withName: StoryBoard.Controllers.selectCity, context: true)
        }
    }
    
    @objc func reload() {
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
    
    func showLoading() {
        self.lineLabel.setText("--")
        self.stopLabel.setText("")
        self.updateLabel.setText("--")
        self.mainLabel.setText("--")
        self.fromLabel.setText("--")
        self.toLabel.setText("--")
        self.timeLabel.setText("--")
    }
    
    func loadData() {
        self.showLoading()
        let todayLine = JWUserDefaultsUtil.todayBusLine()
        if let todayLine = todayLine {
            lineRequest.lineId = todayLine.lineId
            lineRequest.targetOrder = todayLine.order;
            lineRequest.load { [weak self](result, error) -> Void in
                if let weakSelf = self {
                    if let _ = error {
                        
                    } else if let result = result {
                        weakSelf.busInfoItem = JWBusInfoItem(userStopOrder: todayLine.order, busInfo: result as [AnyHashable: Any])
                        weakSelf.renderData()
                    }
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
        var info = self.busInfoItem.calulateInfo()
        let mainText = info?[0] as! NSAttributedString
        let updateText = info?[1] as! String
        
        self.lineLabel.setText(self.busInfoItem.lineNumber)
        self.stopLabel.setText("到达\(String(describing: self.busInfoItem.currentStop!))")
        self.updateLabel.setText(updateText)
        self.mainLabel.setAttributedText(mainText)
        
        self.fromLabel.setText(self.busInfoItem.from)
        self.toLabel.setText(self.busInfoItem.to)
        self.timeLabel.setText("\(String(describing: self.busInfoItem.firstTime!))-\(String(describing: self.busInfoItem.lastTime!))")
    }
    
}
