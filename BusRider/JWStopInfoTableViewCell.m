//
//  JWStopInfoTableViewCell.m
//  BusRider
//
//  Created by John Wong on 12/10/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWStopInfoTableViewCell.h"
#import "JWBorderExtView.h"

@interface JWStopInfoTableViewCell()

@property (nonatomic, weak) IBOutlet JWBorderExtView *mainView;

@end

@implementation JWStopInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor grayColor];
    [self.mainView setCorner:0 radius:8.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
