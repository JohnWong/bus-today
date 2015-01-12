//
//  JWStopNameButton.h
//  BusRider
//
//  Created by John Wong on 12/13/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWStopNameButton : UIView

@property (nonatomic, weak) IBOutlet UIButton *titleButton;

- (void)setIndex:(NSInteger)index title:(NSString *)title last:(BOOL)isLast today:(BOOL)isToday selected:(BOOL)isSelected ;
- (void)setIsToday:(BOOL)isToday;

@end
