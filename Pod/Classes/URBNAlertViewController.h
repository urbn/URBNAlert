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
@class URBNAlertButton;

typedef void(^URBNAlertViewControllerTouchedOutside)();

@interface URBNAlertViewController : UIViewController

- (instancetype)initWithAlertConfig:(URBNAlertConfig *)config alertController:(URBNAlertController *)controller;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message touchOutsideToDismiss:(BOOL)touchOutsideToDismiss;

@property (nonatomic, strong) URBNAlertView *alertView;
@property (nonatomic, strong) UIImage *viewSnapShot;

- (void)dismissAlert:(id)sender;
- (void)addButton:(URBNAlertButton *)button;

// Blocks
@property (nonatomic, copy) URBNAlertViewButtonTouched buttonTouchedBlock;
- (void)setButtonTouchedBlock:(URBNAlertViewButtonTouched)buttonTouchedBlock;

@property (nonatomic, copy) URBNAlertViewControllerTouchedOutside touchedOutsideBlock;
- (void)setTouchedOutsideBlock:(URBNAlertViewControllerTouchedOutside)touchedOutsideBlock;

- (void)show;

@end
