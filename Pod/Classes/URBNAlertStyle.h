//
//  URBNAlertStyle.h
//  Pods
//
//  Created by Ryan Garchinsky on 3/6/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "URBNAlertAction.h"

@interface URBNAlertStyle : NSObject <NSCopying>
/**
 * Background color of the buttons for active alerts
 */
@property (nonatomic, strong) UIColor *buttonBackgroundColor;

/**
 * Background color of the denial button for an active alert (at position 0)
 */
@property (nonatomic, strong) UIColor *destructionButtonBackgroundColor;

/**
 * Text color of destructive button colors
 */
@property (nonatomic, strong) UIColor *destructiveButtonTitleColor;

/**
 * Background color of the cancel button for an active alert
 */
@property (nonatomic, strong) UIColor *cancelButtonBackgroundColor;

/**
 * Text color of cancel button colors
 */
@property (nonatomic, strong) UIColor *cancelButtonTitleColor;

/**
 * Background color of a disabled button for an active alert
 */
@property (nonatomic, strong) UIColor *disabledButtonBackgroundColor;

/**
 * Text color of a disabled button
 */
@property (nonatomic, strong) UIColor *disabledButtonTitleColor;

/**
 * Alpha value of a disabled button
 */
@property (nonatomic, strong) NSNumber *disabledButtonAlpha;

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
 * Alignment of the titles's message
 */
@property (nonatomic, assign) NSTextAlignment titleAlignment;

/**
 * Font of the alert's message
 */
@property (nonatomic, strong) UIFont *messageFont;

/**
 * Alignment of the alert's message
 */
@property (nonatomic, assign) NSTextAlignment messageAlignment;

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
 *  Minimum width the alert view can be. Note if using, alertMaxWidth must also be set
 */
@property (nonatomic, strong) NSNumber *alertMinWidth;

/**
 *  Maximum width the alert view can be. Note if using, alertMinWidth must also be set
 */
@property (nonatomic, strong) NSNumber *alertMaxWidth;

/**
 * Max input length for the text field when enabled
 */
@property (nonatomic, strong) NSNumber *textFieldMaxLength;

/**
 *  Vertical margin between textfields
 */
@property (nonatomic, strong) NSNumber *textFieldVerticalMargin;

/**
 *  Text Insets for input text fields on alerts
 */
@property (nonatomic, assign) UIEdgeInsets textFieldEdgeInsets;

/**
 *  Height of separator between buttons (as in native UIAlertController). Default is nil for compatibility
 */
@property (nonatomic, strong) NSNumber *separatorHeight;

/**
 * Color of the separator between buttons. Default is buttonTitleColor
 */
@property (nonatomic, strong) UIColor *separatorColor;

/**
 *  Boolean flag if to use vertical layout for 2 buttons (for 3+ always vertical being used). Default is nil for compatibility
 */
@property (nonatomic, strong) NSNumber *useVerticalLayoutForTwoButtons;

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
 * UIEdgeInsets used at the margins for the buttons of the alert's buttons
 */
@property (nonatomic, assign) UIEdgeInsets buttonMarginEdgeInsets;

/**
 * !!! DO NOT USE! Use buttonMarginEdgeInsets instead. This is depricated but left for backwards compabaility !!!
 * Left & Right margins of the alert's buttons. Also used for top & bottom margins (poor naming, but dont use it)
 *
 */
@property (nonatomic, strong) NSNumber *buttonHorizontalMargin __attribute__((deprecated("Replaced by buttonMarginEdgeInsets")));

/**
 * Opacity of the alert's button's shadows
 */
@property (nonatomic, strong) NSNumber *buttonShadowOpacity;

/**
 * Radius of the alert's button's shadows
 */
@property (nonatomic, strong) NSNumber *buttonShadowRadius;

/**
 * Color of the alert's button's shadows
 */
@property (nonatomic, strong) UIColor *buttonShadowColor;

/**
 * Offset of the alert's button's shadows
 */
@property (nonatomic, assign) CGSize buttonShadowOffset;

/**
 * Margin around the custom view if supplied
 */
@property (nonatomic, strong) NSNumber *customViewMargin;

/**
 * Duration of the presenting and dismissing of the alert view
 */
@property (nonatomic, strong) NSNumber *animationDuration;

/**
 *  Spring damping for the presenting and dismissing of the alert view
 */
@property (nonatomic, strong) NSNumber *animationDamping;

/**
 *  Spring initial velocity for the presenting and dismissing of the alert view
 */
@property (nonatomic, strong) NSNumber *animationInitialVelocity;

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
 * Tint color of the view behind the Alert. Blur must be disabled
 */
@property (nonatomic, strong) UIColor *backgroundViewTintColor;

/**
 * Radius of the blurred snapshot
 */
@property (nonatomic, strong) NSNumber *blurRadius;

/**
 * Saturation blur factor of the blurred snapshot. 1 is normal. < 1 removes color, > 1 adds color
 */
@property (nonatomic, strong) NSNumber *blurSaturationDelta;

/**
 * Text color of the error label text
 */
@property (nonatomic, strong) UIColor *errorTextColor;

/**
 * Text color of the error label text
 */
@property (nonatomic, strong) UIFont *errorTextFont;

/**
 * The view you want to become the first responder when the alert view is finished presenting
 * The alert position will adjust for the keyboard when using this property
 */
@property (nonatomic, weak) UIView *firstResponder;

/**
 *  Returns the correct background color for given an actionType
 *
 *  @param actionType Action type associated with the button
 *
 *  @return
 */
- (UIColor *)buttonTitleColorForActionType:(URBNAlertActionType)actionType isEnabled:(BOOL)enabled;

/**
 *  Returns the correct title color for given an actionType
 *
 *  @param actionType Action type associated with the button
 *
 *  @return
 */
- (UIColor *)buttonBackgroundColorForActionType:(URBNAlertActionType)actionType isEnabled:(BOOL)enabled;

@end
