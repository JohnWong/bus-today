//
//  JWBusCardView.m
//  BusRider
//
//  Created by John Wong on 12/6/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWBusCardView.h"

@interface JWBusCardView()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *stationLabel;
@property (nonatomic, weak) IBOutlet UILabel *mainLabel;
@property (nonatomic, weak) IBOutlet UILabel *subLabel;
@property (nonatomic, weak) IBOutlet UILabel *updateLabel;

@property (nonatomic, weak) IBOutlet UILabel *fromLabel;
@property (nonatomic, weak) IBOutlet UILabel *toLabel;

@property (nonatomic, weak) IBOutlet UILabel *firstTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastTimeLabel;

@end

@implementation JWBusCardView

#pragma mark callable
- (void)setItem:(JWBusInfoItem *)item {
    self.titleLabel.text = [NSString stringWithFormat:@"%@路", item.lineNumber];
    self.stationLabel.text = [NSString stringWithFormat:@"距%@", item.currentStop];
    
    self.fromLabel.text = item.from;
    self.toLabel.text = item.to;
    self.firstTimeLabel.text = item.firstTime;
    self.lastTimeLabel.text = item.lastTime;
    
    switch (item.state) {
        case JWBusStateNotStarted:
            self.mainLabel.text = @"尚未发车";
            self.mainLabel.font = [UIFont systemFontOfSize:32];
            self.subLabel.text = @"";
            self.updateLabel.text = [NSString stringWithFormat:@"上一辆车发出%ld分钟", item.pastTime];
            return;
        case JWBusStateNotFound:
            self.mainLabel.text = @"暂无数据";
            self.mainLabel.font = [UIFont systemFontOfSize:32];
            self.subLabel.text = @"";
            return;
        case JWBusStateNear:
            self.mainLabel.text = [NSString stringWithFormat:@"%ld", item.distance];
            self.subLabel.text = @"米";
            break;
        case JWBusStateFar:
            if (item.remains < 1000) {
                self.mainLabel.text = [NSString stringWithFormat:@"%ld", item.remains];
                self.subLabel.text = @"站";
            } else {
                self.mainLabel.text = [NSString stringWithFormat:@"%.1f", item.remains / 1000.0];
                self.subLabel.text = @"千米";
            }
            break;
    }
    
    
    if (item.updateTime < 60) {
        self.updateLabel.text = [NSString stringWithFormat:@"%ld秒前更新", item.updateTime];
    } else {
        self.updateLabel.text = [NSString stringWithFormat:@"%ld分前更新", item.updateTime / 60];
    }
}

@end
