//
//  URBNAlertConfig.h
//  Pods
//
//  Created by Ryan Garchinsky on 3/6/15.
//
//

#import <UIKit/UIKit.h>

@interface URBNAlertConfig : NSObject

/**
 *  Title text for the alert
 */
@property (nonatomic, copy) NSString *title;

/**
 *  Message text for the alert
 */
@property (nonatomic, copy) NSString *message;

/**
 *  Array of actions added to the alert
 */
@property (nonatomic, copy) NSArray *actions;

/**
 *  Array of UITextFields added to the array
 */
@property (nonatomic, copy) NSArray *inputs;

/**
 *  The view to present from when using showInView:
 */
@property (nonatomic, weak) UIView *presentationView;

/**
 *  Flag if the alert is active. False = a passive alert
 */
@property (nonatomic, assign) BOOL isActiveAlert;

/**
 *  Duration of a passive alert (no buttons added)
 */
@property (nonatomic, assign) NSInteger duration;

/**
 *  When set to YES, you can touch outside of an alert to dismiss it
 */
@property (nonatomic, assign) BOOL touchOutsideViewToDismiss;

@end
