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

typedef void(^URBNAlertButtonTouched)(URBNAlertController *alertController, NSInteger index);

@interface URBNAlertController : NSObject

// Active Alert inits
- (instancetype)initActiveAlertWithTitle:(NSString *)title message:(NSString *)message hasInput:(BOOL)hasInput buttons:(NSArray *)buttonArray;
- (instancetype)initActiveAlertWithView:(UIView *)view buttons:(NSArray *)buttonArray;

// Passive Alert Inits
- (instancetype)initPassiveAlertWithTitle:(NSString *)title message:(NSString *)message duration:(CGFloat)duration;
- (instancetype)initPassiveAlertView:(UIView *)view duration:(CGFloat)duration;

- (void)showAlert;
- (void)dismissAlert;

// Customizable Properties
@property (nonatomic, strong) UIView *customView;

@property (nonatomic, assign) BOOL touchOutsideToDismiss;
@property (nonatomic, assign) BOOL hasInput;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSArray *buttonTitles;

@property (nonatomic, strong) UIColor *buttonBackgroundColor;
@property (nonatomic, strong) UIColor *buttonDenialBackgroundColor;
@property (nonatomic, strong) UIColor *buttonTitleColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *messageColor;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *messageFont;
@property (nonatomic, strong) UIFont *buttonFont;

@property (nonatomic, assign) UIEdgeInsets contentInsets;

// Callback blocks
@property (nonatomic, copy) URBNAlertButtonTouched buttonTouchedBlock;
- (void)setButtonTouchedBlock:(URBNAlertButtonTouched)buttonTouchedBlock;

@end