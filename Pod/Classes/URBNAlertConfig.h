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

<<<<<<< HEAD
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSArray *buttonTitles;
=======
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSArray *buttonTitles;
>>>>>>> 0595b69b1e0e728619d0b7928588c04166baecce
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
