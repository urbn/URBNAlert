//
//  URBNAlertButton.h
//  Pods
//
//  Created by Ryan Garchinsky on 3/10/15.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, URBNAlertActionType) {
    URBNAlertActionTypeNormal,
    URBNAlertActionTypeDestructive,
    URBNAlertActionTypePassive
};

typedef void(^URBNAlertCompletion)();

@interface URBNAlertAction : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) URBNAlertActionType actionType;

@property (nonatomic, copy) URBNAlertCompletion completionBlock;
- (void)setCompletionBlock:(URBNAlertCompletion)completionBlock;

+ (URBNAlertAction *)buttonWithTitle:(NSString *)title actionType:(URBNAlertActionType)actionType buttonTouched:(URBNAlertCompletion)completionBlock;

- (BOOL)isButton;

@end
