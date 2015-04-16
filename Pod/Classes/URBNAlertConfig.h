//
//  URBNAlertConfig.h
//  Pods
//
//  Created by Ryan Garchinsky on 3/6/15.
//
//

#import <Foundation/Foundation.h>

@interface URBNAlertConfig : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSArray *actions;
@property (nonatomic, weak) UIView *presentationView;
@property (nonatomic, assign) BOOL hasInput;
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
