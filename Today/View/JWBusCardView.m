//
//  JWBusCardView.m
//  BusRider
//
//  Created by John Wong on 12/6/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWBusCardView.h"
#import "JWButtonWithAnimation.h"
#import "JWFormatter.h"


@interface JWBusCardView ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *stationLabel;
@property (nonatomic, weak) IBOutlet UILabel *mainLabel;
@property (nonatomic, weak) IBOutlet UILabel *updateLabel;
@property (nonatomic, weak) IBOutlet UILabel *fromLabel;
@property (nonatomic, weak) IBOutlet UILabel *toLabel;
@property (nonatomic, weak) IBOutlet UILabel *firstTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastTimeLabel;
@property (nonatomic, weak) IBOutlet JWButtonWithAnimation *refreshButton;

@end


@implementation JWBusCardView

#pragma mark callable
- (void)setLoadingView
{
    [self setPlaceHolder];
    [self.refreshButton startAnimation];
}

- (void)setErrorView:(NSString *)errorMessage
{
    [UIView animateWithDuration:0.3 animations:^{
        [self setToSubviews:^(UIView *view) {
            view.layer.transform = CATransform3DMakeRotation(- M_PI / 2, 1, 0, 0);
        }];
    } completion:^(BOOL finished) {
        [self setPlaceHolder];
        self.updateLabel.text = errorMessage;
        [UIView animateWithDuration:0.5 animations:^{
            [self setToSubviews:^(UIView *view) {
                view.layer.transform = CATransform3DMakeRotation(0, 1, 0, 0);
            }];
        } completion:^(BOOL finished) {
            [self.refreshButton stopAnimation];
        }];
    }];
}

- (void)setItem:(JWBusInfoItem *)item
{
    [UIView animateWithDuration:0.3 animations:^{
        [self setToSubviews:^(UIView *view) {
            view.layer.transform = CATransform3DMakeRotation(- M_PI / 2, 1, 0, 0);
        }];
    } completion:^(BOOL finished) {
        [self setItemInternal:item];
        [UIView animateWithDuration:0.5 animations:^{
            [self setToSubviews:^(UIView *view) {
                view.layer.transform = CATransform3DMakeRotation(0, 1, 0, 0);
            }];
        } completion:^(BOOL finished) {
            [self.refreshButton stopAnimation];
        }];
    }];
}

- (void)setPlaceHolder
{
    self.titleLabel.text = @"--";
    self.stationLabel.text = @"--";
    self.mainLabel.text = @"--";
    self.updateLabel.text = @"--";
    self.fromLabel.text = @"--";
    self.toLabel.text = @"--";
    self.firstTimeLabel.text = @"--";
    self.lastTimeLabel.text = @"--";
}

- (void)setItemInternal:(JWBusInfoItem *)item
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@", item.lineNumber];
    self.stationLabel.text = [NSString stringWithFormat:@"到达%@", item.currentStop];

    self.fromLabel.text = item.from;
    self.toLabel.text = item.to;
    self.firstTimeLabel.text = item.firstTime;
    self.lastTimeLabel.text = item.lastTime;

    NSArray *info = [item calulateInfo];
    NSAttributedString *main = info[0];
    NSString *update = info[1];

    self.mainLabel.attributedText = main;
    self.updateLabel.text = update;
}

- (void)setToSubviews:(void (^)(UIView *view))callback
{
    NSArray *subviews = @[ self.titleLabel,
                           self.stationLabel,
                           self.mainLabel,
                           self.updateLabel,
                           self.fromLabel,
                           self.toLabel,
                           self.firstTimeLabel,
                           self.lastTimeLabel ];
    for (UIView *view in subviews) {
        callback(view);
    }
}

@end
