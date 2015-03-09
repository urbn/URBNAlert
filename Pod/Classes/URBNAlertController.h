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

/**
 *  Show an active alert with a title, message, and up to 2 buttons
 *
 *  @param title
 *  @param message
 *  @param hasInput
 *  @param buttonTitles
 *  @param touchOutsideToDismiss
 *  @param buttonTouchedBlock
 */
- (void)showActiveAlertWithTitle:(NSString *)title message:(NSString *)message hasInput:(BOOL)hasInput buttonTitles:(NSArray *)buttonArray touchOutsideToDismiss:(BOOL)touchOutsideToDismiss buttonTouchedBlock:(URBNAlertButtonTouched)buttonTouchedBlock;

/**
 *  Show an active alert with a custom view, and up to 2 buttons
 *
 *  @param view
 *  @param buttonTitles
 *  @param touchOutsideToDismiss
 *  @param buttonTouchedBlock
 */
- (void)showActiveAlertWithView:(UIView *)view buttonTitles:(NSArray *)buttonArray touchOutsideToDismiss:(BOOL)touchOutsideToDismiss buttonTouchedBlock:(URBNAlertButtonTouched)buttonTouchedBlock;

/**
 *  Show a passive alert with a title & message
 *
 *  @param title
 *  @param message
 *  @param touchOutsideToDismiss
 *  @param duration
 *  @param alertDismissedBlock
 */
- (void)showPassiveAlertWithTitle:(NSString *)title message:(NSString *)message touchOutsideToDismiss:(BOOL)touchOutsideToDismiss duration:(CGFloat)duration alertDismissedBlock:(URBNAlertPassiveAlertDismissed)alertDismissedBlock;\

/**
 *  Show a passive alert with a title & message. Duration is calculated based on the number of words in the title & message
 *
 *  @param title
 *  @param message
 *  @param touchOutsideToDismiss
 *  @param alertDismissedBlock
 */
- (void)showPassiveAlertWithTitle:(NSString *)title message:(NSString *)message touchOutsideToDismiss:(BOOL)touchOutsideToDismiss alertDismissedBlock:(URBNAlertPassiveAlertDismissed)alertDismissedBlock;

/**
 *  Show a passive alert with a custom view
 *
 *  @param title
 *  @param message
 *  @param touchOutsideToDismiss
 *  @param duration
 *  @param alertDismissedBlock
 */
- (void)showPassiveAlertWithView:(UIView *)view touchOutsideToDismiss:(BOOL)touchOutsideToDismiss duration:(CGFloat)duration alertDismissedBlock:(URBNAlertPassiveAlertDismissed)alertDismissedBlock;

/**
 *  Dismisses the alert currently visible
 */
- (void)dismissAlert;

/**
 *  Create & set this property if you wish to customize various properties of the alert view.
 *  If none is passed, default values are used. See URBNAlertStyle for properties you can configue & default values.
 */
@property (nonatomic, strong) URBNAlertStyle *alertStyler;

@end