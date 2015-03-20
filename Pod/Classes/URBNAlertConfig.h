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

@property (nonatomic, assign) BOOL touchOutsideViewToDismiss;
@property (nonatomic, assign) BOOL hasInput;
@property (nonatomic, assign) BOOL isActiveAlert;

@property (nonatomic, assign) NSInteger duration;

@end
