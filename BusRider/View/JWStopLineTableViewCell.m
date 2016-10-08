//
//  JWStopLineTableViewCell.m
//  BusRider
//
//  Created by John Wong on 1/14/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWStopLineTableViewCell.h"


@implementation JWStopLineTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle rightDetail:(NSString *)rightDetail
{
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
    self.rightDetailLabel.text = rightDetail;
}

@end
