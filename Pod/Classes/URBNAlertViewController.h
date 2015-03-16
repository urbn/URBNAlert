//
//  URBNAlertViewController.h
//  URBNAlertTest
//
//  Created by Ryan Garchinsky on 3/3/15.
//  Copyright (c) 2015 URBN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URBNAlertView.h"
#import "URBNAlertStyle.h"
#import "URBNAlertConfig.h"

@class URBNAlertController;
@class URBNAlertViewController;
@class URBNAlertAction;

typedef void(^URBNAlertViewControllerTouchedOutside)();

@interface URBNAlertViewController : UIViewController

- (instancetype)initWithAlertConfig:(URBNAlertConfig *)config alertController:(URBNAlertController *)controller;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message view:(UIView *)view;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

@property (nonatomic, strong) URBNAlertView *alertView;
@property (nonatomic, strong) URBNAlertStyle *alertStyler;
@property (nonatomic, strong) URBNAlertConfig *alertConfig;
@property (nonatomic, weak) UITextField *textField;

- (void)show;
- (void)dismiss;
- (void)dismissAlert:(id)sender;
- (void)addAction:(URBNAlertAction *)button;
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;

// Blocks
@property (nonatomic, copy) URBNAlertViewControllerTouchedOutside touchedOutsideBlock;
- (void)setTouchedOutsideBlock:(URBNAlertViewControllerTouchedOutside)touchedOutsideBlock;


@end
