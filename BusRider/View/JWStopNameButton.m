//
//  JWStopNameButton.m
//  BusRider
//
//  Created by John Wong on 12/13/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWStopNameButton.h"
#import "JWViewUtil.h"

@interface JWStopNameButton()

@property (nonatomic, weak) IBOutlet UIView *separator;
@property (nonatomic, weak) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayButton;

@end

@implementation JWStopNameButton

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class)  owner:self options:nil][0])) {
        [self setFrame:frame];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.titleButton setBackgroundImage:[JWViewUtil resizableImageWithColor:HEXCOLORA(0x333333, 0.3)] forState:UIControlStateHighlighted];
    }
    return self;
}


#pragma mark action
- (void)setIndex:(NSInteger)index title:(NSString *)title last:(BOOL)isLast today:(BOOL)isToday{
    if (isLast) {
        self.separator.hidden = YES;
    } else {
        self.separator.hidden = NO;
    }
    self.indexLabel.text = [NSString stringWithFormat:@"%ld", index];;
    [self.titleButton setTitle:title forState:UIControlStateNormal];
    
    if (isToday) {
        self.todayButton.hidden = NO;
    } else {
        self.todayButton.hidden = YES;
    }
}

@end
