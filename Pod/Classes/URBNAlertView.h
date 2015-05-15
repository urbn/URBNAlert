//
//  URBNAlertView.h
//  URBNAlertTest
//
//  Created by Ryan Garchinsky on 3/3/15.
//  Copyright (c) 2015 URBN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URBNAlertAction.h"

@class URBNAlertController;
@class URBNAlertView;
@class URBNAlertConfig;
@class URBNAlertStyle;

typedef void(^URBNAlertViewButtonTouched)(URBNAlertAction *action);
typedef void(^URBNAlertViewTouched)(URBNAlertAction *action);

@interface URBNAlertView : UIView <UITextFieldDelegate>

- (instancetype)initWithAlertConfig:(URBNAlertConfig *)config alertStyler:(URBNAlertStyle *)alertStyler customView:(UIView *)customView;

- (void)setErrorLabelText:(NSString *)errorText;
- (void)setLoadingState:(BOOL)newState forTextFieldAtIndex:(NSUInteger)index;

// Blocks
@property (nonatomic, copy) URBNAlertViewButtonTouched buttonTouchedBlock;
- (void)setButtonTouchedBlock:(URBNAlertViewButtonTouched)buttonTouchedBlock;

@property (nonatomic, copy) URBNAlertViewTouched alertViewTouchedBlock;
- (void)setAlertViewTouchedBlock:(URBNAlertViewTouched)alertViewTouchedBlock;

@end

// URBNAlertActionButton
@interface URBNAlertActionButton : UIButton

@property (nonatomic, assign) URBNAlertActionType actionType;
@property (nonatomic, weak) URBNAlertStyle *alertStyler;

@end

