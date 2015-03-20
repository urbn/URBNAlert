//
//  URBNAlertStyle.h
//  Pods
//
//  Created by Ryan Garchinsky on 3/6/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface URBNAlertStyle : NSObject <NSCopying>
/**
 * Background color of the buttons for active alerts
 */
@property (nonatomic, strong) UIColor *buttonBackgroundColor;

/**
 * Background color of the denial button for an active alert (at position 0)
 */
@property (nonatomic, strong) UIColor *buttonDestructionBackgroundColor;

/**
 * Text color of the button titles
 */
@property (nonatomic, strong) UIColor *buttonTitleColor;

/**
 * Background color of alert view
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 * Text color of the alert's title
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 * Text color of the alert's message
 */
@property (nonatomic, strong) UIColor *messageColor;

/**
 * Font of the alert's title
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 * Font of the alert's message
 */
@property (nonatomic, strong) UIFont *messageFont;

/**
 * Font of the button's titles
 */
@property (nonatomic, strong) UIFont *buttonFont;

/**
 * Corner radius of the alert's buttons
 */
@property (nonatomic, strong) NSNumber *buttonCornerRadius;

/**
 * Corner radius of the alert view itself
 */
@property (nonatomic, strong) NSNumber *alertCornerRadius;

/**
 * Max input length for the text field when enabled
 */
@property (nonatomic, strong) NSNumber *textFieldMaxLength;

/**
 * Height of the alert's buttons
 */
@property (nonatomic, strong) NSNumber *buttonHeight;

/**
 * Margin between sections in the alert. ie margin between the title and the message; message and the buttons, etc.
 */
@property (nonatomic, strong) NSNumber *sectionVerticalMargin;

/**
 * Left & Right margins of the title & message labels
 */
@property (nonatomic, strong) NSNumber *labelHorizontalMargin;

/**
 * Left & Right margins of the alert's buttons
 */
@property (nonatomic, strong) NSNumber *buttonHorizontalMargin;

/**
 * Margin around the custom view if supplied
 */
@property (nonatomic, strong) NSNumber *customViewMargin;

/**
 * Duration of the presenting and dismissing of the alert view
 */
@property (nonatomic, strong) NSNumber *animationDuration;

/**
 * Opacity of the alert view's shadow
 */
@property (nonatomic, strong) NSNumber *alertViewShadowOpacity;

/**
 * Radius of the alert view's shadow
 */
@property (nonatomic, strong) NSNumber *alertViewShadowRadius;

/**
 * Color of the alert view's shadow
 */
@property (nonatomic, strong) UIColor *alertViewShadowColor;

/**
 * Offset of the alert view's shadow
 */
@property (nonatomic, assign) CGSize alertShadowOffset;

/**
 * Pass no to disable blurring in the background
 */
@property (nonatomic, strong) NSNumber *blurEnabled;

/**
 * Tint color of the blurred snapshot
 */
@property (nonatomic, strong) UIColor *blurTintColor;

/**
 * Radius of the blurred snapshot
 */
@property (nonatomic, strong) NSNumber *blurRadius;

/**
 * Saturation blur factor of the blurred snapshot. 1 is normal. < 1 removes color, > 1 adds color
 */
@property (nonatomic, strong) NSNumber *blurSaturationDelta;

@end
