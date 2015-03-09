//
//  URBNAlertStyle.h
//  Pods
//
//  Created by Ryan Garchinsky on 3/6/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface URBNAlertStyle : NSObject

@property (nonatomic, strong) UIColor *buttonBackgroundColor;
@property (nonatomic, strong) UIColor *buttonDenialBackgroundColor;
@property (nonatomic, strong) UIColor *buttonTitleColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *messageColor;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *messageFont;
@property (nonatomic, strong) UIFont *buttonFont;

@property (nonatomic, strong) NSNumber *buttonCornerRadius;
@property (nonatomic, strong) NSNumber *alertCornerRadius;
@property (nonatomic, strong) NSNumber *textFieldMaxLength;

@property (nonatomic, assign) UIKeyboardType inputKeyboardType;
@property (nonatomic, assign) UIReturnKeyType inputReturnKeyType;

@property (nonatomic, assign) UIEdgeInsets buttonInsets;
@property (nonatomic, assign) UIEdgeInsets titleInsets;
@property (nonatomic, assign) UIEdgeInsets messageInsets;
@property (nonatomic, assign) UIEdgeInsets viewInsets;

@end
