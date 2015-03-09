//
//  URBNAlertController.h
//  URBNAlertTest
//
//  Created by Ryan Garchinsky on 3/3/15.
//  Copyright (c) 2015 URBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "URBNAlertStyle.h"

@class URBNAlertController;

typedef void(^URBNAlertButtonTouched)(URBNAlertController *alertController, NSInteger index);
typedef void(^URBNAlertPassiveAlertDismissed)(URBNAlertController *alertController, BOOL alertWasTouched);

@interface URBNAlertController : NSObject

+ (instancetype)sharedInstance;

// Active Alert
- (void)showActiveAlertWithTitle:(NSString *)title message:(NSString *)message hasInput:(BOOL)hasInput buttons:(NSArray *)buttonArray touchOutsideToDismiss:(BOOL)touchOutsideToDismiss buttonTouchedBlock:(URBNAlertButtonTouched)buttonTouchedBlock;
- (void)showActiveAlertWithView:(UIView *)view buttons:(NSArray *)buttonArray touchOutsideToDismiss:(BOOL)touchOutsideToDismiss buttonTouchedBlock:(URBNAlertButtonTouched)buttonTouchedBlock;

// Passive Alert
- (void)showPassiveAlertWithTitle:(NSString *)title message:(NSString *)message touchOutsideToDismiss:(BOOL)touchOutsideToDismiss duration:(CGFloat)duration alertDismissedBlock:(URBNAlertPassiveAlertDismissed)alertDismissedBlock;
- (void)showPassiveAlertWithTitle:(NSString *)title message:(NSString *)message touchOutsideToDismiss:(BOOL)touchOutsideToDismiss alertDismissedBlock:(URBNAlertPassiveAlertDismissed)alertDismissedBlock;
- (void)showPassiveAlertWithView:(UIView *)view touchOutsideToDismiss:(BOOL)touchOutsideToDismiss duration:(CGFloat)duration alertDismissedBlock:(URBNAlertPassiveAlertDismissed)alertDismissedBlock;

- (void)dismissAlert;

@property (nonatomic, strong) URBNAlertStyle *alertStyler;

@end