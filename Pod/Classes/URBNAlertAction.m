//
//  URBNAlertButton.m
//  Pods
//
//  Created by Ryan Garchinsky on 3/10/15.
//
//

#import "URBNAlertAction.h"

@implementation URBNAlertAction

+ (URBNAlertAction *)actionWithTitle:(NSString *)title actionType:(URBNAlertActionType)actionType actionCompleted:(URBNAlertCompletion)completionBlock {
    URBNAlertAction *action = [URBNAlertAction new];
    [action setTitle:title];
    [action setActionType:actionType];
    [action setCompletionBlock:completionBlock];
    return action;
}

- (BOOL)isButton {
    return (self.actionType == URBNAlertActionTypeNormal || self.actionType == URBNAlertActionTypeDestructive);
}

@end
