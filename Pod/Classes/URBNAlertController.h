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
typedef void(^URBNAlertViewTouched)(URBNAlertController *alertController);

@interface URBNAlertController : NSObject

+ (instancetype)sharedInstance;

// Active Alert
- (void)showActiveAlertWithTitle:(NSString *)title message:(NSString *)message hasInput:(BOOL)hasInput buttons:(NSArray *)buttonArray buttonTouchedBlock:(URBNAlertButtonTouched)buttonTouchedBlock;
- (void)showActiveAlertWithView:(UIView *)view buttons:(NSArray *)buttonArray buttonTouchedBlock:(URBNAlertButtonTouched)buttonTouchedBlock;

// Passive Alert
- (void)showPassiveAlertWithTitle:(NSString *)title message:(NSString *)message duration:(CGFloat)duration buttonTouchedBlock:(URBNAlertButtonTouched)buttonTouchedBlock;
- (void)showPassiveAlertWithTitle:(NSString *)title message:(NSString *)message buttonTouchedBlock:(URBNAlertButtonTouched)buttonTouchedBlock;
- (void)showPassiveAlertWithView:(UIView *)view touchOutsideToDismiss:(BOOL)touchOutsideToDismiss duration:(CGFloat)duration viewTouchedBlock:(URBNAlertButtonTouched)viewTouchedBlock;
- (void)showPassiveAlertWithView:(UIView *)view touchOutsideToDismiss:(BOOL)touchOutsideToDismiss viewTouchedBlock:(URBNAlertButtonTouched)viewTouchedBlock;

- (void)dismissAlert;

@property (nonatomic, strong) URBNAlertStyle *alertStyler;

@end