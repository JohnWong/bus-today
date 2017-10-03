//
//  JWStopNameButton.m
//  BusRider
//
//  Created by John Wong on 12/13/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWStopNameButton.h"
#import "JWViewUtil.h"


@interface JWStopNameButton ()

@property (nonatomic, weak) IBOutlet UIView *separator;
@property (nonatomic, weak) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayButton;

@end


@implementation JWStopNameButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil][0];
    if (self) {
        self.frame = frame;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.titleButton setBackgroundImage:[JWViewUtil resizableImageWithColor:HEXCOLORA(0x333333, 0.3)] forState:UIControlStateHighlighted];
    }
    return self;
}

#pragma mark action
- (void)setIndex:(NSInteger)index title:(NSString *)title last:(BOOL)isLast today:(BOOL)isToday selected:(BOOL)isSelected
{
    if (isLast) {
        self.separator.hidden = YES;
    } else {
        self.separator.hidden = NO;
    }
    self.indexLabel.text = [NSString stringWithFormat:@"%ld", (long)index];
    ;
    [self.titleButton setTitle:title forState:UIControlStateNormal];

    [self setIsToday:isToday];

    if (isSelected) {
        self.titleButton.selected = YES;
        self.indexLabel.backgroundColor = self.tintColor;
    } else {
        self.titleButton.selected = NO;
        self.indexLabel.backgroundColor = HEXCOLOR(0xADADAD);
    }
}

- (void)setIsToday:(BOOL)isToday
{
    if (isToday) {
        self.todayButton.hidden = NO;
    } else {
        self.todayButton.hidden = YES;
    }
}

@end
