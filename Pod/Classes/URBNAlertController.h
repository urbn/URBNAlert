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
@class URBNAlertConfig;
@class URBNAlertViewController;

typedef void(^URBNAlertButtonTouched)(URBNAlertController *alertController, NSInteger index);

@interface URBNAlertController : NSObject

+ (instancetype)sharedInstance;

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