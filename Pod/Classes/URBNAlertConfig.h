//
//  URBNAlertConfig.h
//  Pods
//
//  Created by Ryan Garchinsky on 3/6/15.
//
//

#import <Foundation/Foundation.h>
#import "URBNAlertController.h"

@interface URBNAlertConfig : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSArray *buttonTitles;
@property (nonatomic, strong) UIView *customView;

@property (nonatomic, assign) BOOL touchOutsideToDismiss;
@property (nonatomic, assign) BOOL hasInput;
@property (nonatomic, assign) BOOL isActiveAlert;

@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, copy) URBNAlertButtonTouched buttonTouchedBlock;
- (void)setButtonTouchedBlock:(URBNAlertButtonTouched)buttonTouchedBlock;

@property (nonatomic, copy) URBNAlertPassiveViewTouched passiveViewTouched;
- (void)setPassiveViewTouched:(URBNAlertPassiveViewTouched)passiveViewTouched;

@end
