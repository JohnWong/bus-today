//
//  JWStopLineTableViewCell.h
//  BusRider
//
//  Created by John Wong on 1/14/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWStopLineTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightDetailLabel;

- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle rightDetail:(NSString *)rightDetail;

@end
