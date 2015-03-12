//
//  URBNAlertButton.m
//  Pods
//
//  Created by Ryan Garchinsky on 3/10/15.
//
//

#import "URBNAlertAction.h"

@implementation URBNAlertAction

+ (URBNAlertAction *)buttonWithTitle:(NSString *)title actionType:(URBNAlertActionType)actionType buttonTouched:(URBNAlertCompletion)completionBlock {
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
