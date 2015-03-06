//
//  URBNAlertController.h
//  URBNAlertTest
//
//  Created by Ryan Garchinsky on 3/3/15.
//  Copyright (c) 2015 URBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class URBNAlertController;
@class URBNAlertStyle;

typedef void(^URBNAlertButtonTouched)(URBNAlertController *alertController, NSInteger index);

@interface URBNAlertController : NSObject

+ (instancetype)sharedInstance;

// Active Alert inits
- (instancetype)initActiveAlertWithTitle:(NSString *)title message:(NSString *)message hasInput:(BOOL)hasInput buttons:(NSArray *)buttonArray;
- (instancetype)initActiveAlertWithView:(UIView *)view buttons:(NSArray *)buttonArray;

// Passive Alert Inits
- (instancetype)initPassiveAlertWithTitle:(NSString *)title message:(NSString *)message duration:(CGFloat)duration;
- (instancetype)initPassiveAlertView:(UIView *)view duration:(CGFloat)duration;

- (void)showAlert;
- (void)dismissAlert;

// Customizable Properties
@property (nonatomic, strong) URBNAlertStyle *alertStyle;

@property (nonatomic, strong) UIView *customView;

@property (nonatomic, assign) BOOL touchOutsideToDismiss;
@property (nonatomic, assign) BOOL hasInput;
@property (nonatomic, assign) BOOL isActiveAlert;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSArray *buttonTitles;

@property (nonatomic, assign) UIEdgeInsets contentInsets;

// Callback blocks
@property (nonatomic, copy) URBNAlertButtonTouched buttonTouchedBlock;
- (void)setButtonTouchedBlock:(URBNAlertButtonTouched)buttonTouchedBlock;

@end