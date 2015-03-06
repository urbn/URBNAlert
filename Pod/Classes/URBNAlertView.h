//
//  URBNAlertView.h
//  URBNAlertTest
//
//  Created by Ryan Garchinsky on 3/3/15.
//  Copyright (c) 2015 URBN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class URBNAlertController;
@class URBNAlertView;

typedef void(^URBNAlertViewButtonTouched)(NSInteger index);

@interface URBNAlertView : UIView

- (instancetype)initWithAlertController:(URBNAlertController *)controller;

// Blocks
@property (nonatomic, copy) URBNAlertViewButtonTouched buttonTouchedBlock;
- (void)setButtonTouchedBlock:(URBNAlertViewButtonTouched)buttonTouchedBlock;

@end
