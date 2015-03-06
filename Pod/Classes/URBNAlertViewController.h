//
//  URBNAlertViewController.h
//  URBNAlertTest
//
//  Created by Ryan Garchinsky on 3/3/15.
//  Copyright (c) 2015 URBN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URBNAlertView.h"

@class URBNAlertController;
@class URBNAlertViewController;

@interface URBNAlertViewController : UIViewController

- (instancetype)initWithAlertConfig:(URBNAlertConfig *)config alertController:(URBNAlertController *)controller;

@property (nonatomic, strong) URBNAlertView *alertView;

- (void)dismissAlert;

// Blocks
@property (nonatomic, copy) URBNAlertViewButtonTouched buttonTouchedBlock;
- (void)setButtonTouchedBlock:(URBNAlertViewButtonTouched)buttonTouchedBlock;

@end
