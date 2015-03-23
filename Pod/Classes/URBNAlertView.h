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
@class URBNAlertConfig;
@class URBNAlertAction;
@class URBNAlertStyle;

typedef void(^URBNAlertViewButtonTouched)(URBNAlertAction *action);
typedef void(^URBNAlertViewTouched)(URBNAlertAction *action);

@interface URBNAlertView : UIView <UITextFieldDelegate>

- (instancetype)initWithAlertConfig:(URBNAlertConfig *)config alertStyler:(URBNAlertStyle *)alertStyler customView:(UIView *)customView textField:(UITextField *)textField;

// Blocks
@property (nonatomic, copy) URBNAlertViewButtonTouched buttonTouchedBlock;
- (void)setButtonTouchedBlock:(URBNAlertViewButtonTouched)buttonTouchedBlock;

@property (nonatomic, copy) URBNAlertViewTouched alertViewTouchedBlock;
- (void)setAlertViewTouchedBlock:(URBNAlertViewTouched)alertViewTouchedBlock;

@property (nonatomic, weak) UITextField *textField;

@end