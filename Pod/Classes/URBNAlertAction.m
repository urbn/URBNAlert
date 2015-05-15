//
//  URBNAlertButton.m
//  Pods
//
//  Created by Ryan Garchinsky on 3/10/15.
//
//

#import "URBNAlertAction.h"
#import "URBNAlertView.h"

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
    return (self.actionType == URBNAlertActionTypeNormal || self.actionType == URBNAlertActionTypeDestructive || self.actionType == URBNAlertActionTypeCancel);
}

- (void)setEnabled:(BOOL)enabled {
    if (self.isButton && self.actionButton) {
        [self.actionButton setEnabled:enabled];
        self.actionButton.alpha = enabled ? 1.f : 0.5f;
    }
}

@end
