//
//  URBNAlertButton.m
//  Pods
//
//  Created by Ryan Garchinsky on 3/10/15.
//
//

#import "URBNAlertAction.h"
#import "URBNAlertView.h"
#import "URBNAlertStyle.h"

@implementation URBNAlertAction

+ (URBNAlertAction *)actionWithTitle:(NSString *)title actionType:(URBNAlertActionType)actionType actionCompleted:(URBNAlertCompletion)completionBlock {
    return [self actionWithTitle:title actionType:actionType dismissOnActionComplete:YES actionCompleted:completionBlock];
}

+ (URBNAlertAction *)actionWithTitle:(NSString *)title actionType:(URBNAlertActionType)actionType dismissOnActionComplete:(BOOL)dismiss actionCompleted:(URBNAlertCompletion)completionBlock {
    URBNAlertAction *action = [URBNAlertAction new];
    [action setTitle:title];
    [action setActionType:actionType];
    [action setDismissOnCompletion:dismiss];
    [action setCompletionBlock:completionBlock];
    
    return action;
}

- (BOOL)isButton {
    return (self.actionType != URBNAlertActionTypePassive);
}

- (void)setEnabled:(BOOL)enabled {
    if (self.isButton && self.actionButton && self.actionType != URBNAlertActionTypeCancel) {
        [self.actionButton setEnabled:enabled];
        [self styleButton:self.actionButton isEnabled:enabled];
    }
}

- (void)styleButton:(URBNAlertActionButton *)actionButton isEnabled:(BOOL)enabled {
    UIColor *titleColor = [self.actionButton.alertStyler buttonTitleColorForActionType:actionButton.actionType isEnabled:enabled];
    UIColor *bgColor = [self.actionButton.alertStyler buttonBackgroundColorForActionType:actionButton.actionType isEnabled:enabled];
    
    [actionButton setTitleColor:titleColor forState:UIControlStateNormal];
    [actionButton setBackgroundColor:bgColor];
    actionButton.alpha = enabled ? 1.f : self.actionButton.alertStyler.disabledButtonAlpha.floatValue;
}

@end
