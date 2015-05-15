//
//  URBNAlertButton.h
//  Pods
//
//  Created by Ryan Garchinsky on 3/10/15.
//
//

#import <Foundation/Foundation.h>

@class URBNAlertAction;

typedef NS_ENUM(NSInteger, URBNAlertActionType) {
    URBNAlertActionTypeNormal,
    URBNAlertActionTypeDestructive,
    URBNAlertActionTypeCancel,
    URBNAlertActionTypePassive
};

typedef void(^URBNAlertCompletion)(URBNAlertAction *action);

@interface URBNAlertAction : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL dismissOnCompletion;
@property (nonatomic, assign) URBNAlertActionType actionType;

@property (nonatomic, copy) URBNAlertCompletion completionBlock;
- (void)setCompletionBlock:(URBNAlertCompletion)completionBlock;

+ (URBNAlertAction *)actionWithTitle:(NSString *)title actionType:(URBNAlertActionType)actionType actionCompleted:(URBNAlertCompletion)completionBlock;

+ (URBNAlertAction *)actionWithTitle:(NSString *)title actionType:(URBNAlertActionType)actionType dismissOnActionComplete:(BOOL)dismiss actionCompleted:(URBNAlertCompletion)completionBlock;

- (BOOL)isButton;

@end
