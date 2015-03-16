//
//  URBNAlertController.m
//  URBNAlertTest
//
//  Created by Ryan Garchinsky on 3/3/15.
//  Copyright (c) 2015 URBN. All rights reserved.
//

#import "URBNAlertController.h"
#import "URBNAlertViewController.h"
#import "URBNAlertView.h"
#import "URBNAlertConfig.h"
#import "URBNAlertAction.h"

@interface URBNAlertController ()

@property (nonatomic, strong) UIImage *backgroudViewSnapshot;
@property (nonatomic, assign) BOOL alertIsVisible;
@property (nonatomic, copy) NSArray *queue;

@end

@implementation URBNAlertController

#pragma mark - Initilization
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static URBNAlertController *instance;
    dispatch_once(&onceToken, ^{
        instance = [[URBNAlertController alloc] init];
        [instance setAlertStyler:[URBNAlertStyle new]];
        instance.window = [[UIApplication sharedApplication] windows][0];
    });
    
    return instance;
}

#pragma mark - Acive Alerts
- (void)showActiveAlertWithTitle:(NSString *)title message:(NSString *)message hasInput:(BOOL)hasInput buttonTitles:(NSArray *)buttonArray touchOutsideToDismiss:(BOOL)touchOutsideToDismiss buttonTouchedBlock:(URBNAlertButtonTouched)buttonTouchedBlock {
    NSAssert((buttonArray.count <= 2), @"URBNAlertController: Active alerts only supports up to 2 buttons at the moment. Please create an issue if you want more!");
    NSAssert((buttonArray && buttonArray.count > 0), @"URBNAlertController: Active alerts require at least one button. Use a Passive alert if you want an alert that will dismiss after a period of time.");
    NSAssert(buttonTouchedBlock, @"URBNAlertController: You must implemented the buttonTouchedBlock so you can dismiss the alert somehow. Use a Passive alert if you want an alert that will dismiss after a period of time.");

    URBNAlertConfig *config = [URBNAlertConfig new];
    config.actions = buttonArray;
    config.title = title;
    config.message = message;
    config.hasInput = hasInput;
    config.isActiveAlert = YES;
    config.customView = nil;
    config.touchOutsideToDismiss = touchOutsideToDismiss;
    [config setButtonTouchedBlock:buttonTouchedBlock];
    
    //[self showAlertWithConfig:config];
}

- (void)showActiveAlertWithView:(UIView *)view buttonTitles:(NSArray *)buttonArray touchOutsideToDismiss:(BOOL)touchOutsideToDismiss buttonTouchedBlock:(URBNAlertButtonTouched)buttonTouchedBlock {
    NSAssert((buttonArray.count <= 2), @"URBNAlertController: Active alerts only supports up to 2 buttons at the moment. Please create an issue if you want more!");
    NSAssert((buttonArray.count > 0), @"URBNAlertController: Active alerts require at least one button. Use a Passive alert if you want an alert that will dismiss after a period of time.");
    NSAssert(view, @"URBNAlertController: You need to pass a view to initActiveAlertWithView. C'mon bro.");
    
    URBNAlertConfig *config = [URBNAlertConfig new];
    config.actions = buttonArray;
    config.customView = view;
    config.isActiveAlert = YES;
    config.touchOutsideToDismiss = touchOutsideToDismiss;
    [config setButtonTouchedBlock:buttonTouchedBlock];

   // [self showAlertWithConfig:config];
}

#pragma mark - Passive Alerts
- (void)showPassiveAlertWithTitle:(NSString *)title message:(NSString *)message touchOutsideToDismiss:(BOOL)touchOutsideToDismiss duration:(CGFloat)duration alertDismissedBlock:(URBNAlertPassiveAlertDismissed)alertDismissedBlock {
    URBNAlertConfig *config = [URBNAlertConfig new];
    config.isActiveAlert = NO;
    config.duration = duration;
    config.title = title;
    config.message = message;
    config.touchOutsideToDismiss = touchOutsideToDismiss;
    [config setPassiveAlertDismissedBlock:alertDismissedBlock];
    
   // [self showAlertWithConfig:config];
}

- (void)showPassiveAlertWithTitle:(NSString *)title message:(NSString *)message touchOutsideToDismiss:(BOOL)touchOutsideToDismiss alertDismissedBlock:(URBNAlertPassiveAlertDismissed)alertDismissedBlock {
    URBNAlertConfig *config = [URBNAlertConfig new];
    config.isActiveAlert = NO;
    config.title = title;
    config.message = message;
    config.duration = [self calculateDuration:config];
    config.touchOutsideToDismiss = touchOutsideToDismiss;
    [config setPassiveAlertDismissedBlock:alertDismissedBlock];
    
   // [self showAlertWithConfig:config];
}

- (void)showPassiveAlertWithView:(UIView *)view touchOutsideToDismiss:(BOOL)touchOutsideToDismiss duration:(CGFloat)duration alertDismissedBlock:(URBNAlertPassiveAlertDismissed)alertDismissedBlock {
    NSAssert(view, @"URBNAlertController: You need to pass a view to initActiveAlertWithView. C'mon bro.");
    
    URBNAlertConfig *config = [URBNAlertConfig new];
    config.isActiveAlert = NO;
    config.duration = duration;
    config.customView = view;
    config.touchOutsideToDismiss = touchOutsideToDismiss;
    [config setPassiveAlertDismissedBlock:alertDismissedBlock];
    
    //[self showAlertWithConfig:config];
}

#pragma mark - Setters
- (void)setAlertStyler:(URBNAlertStyle *)alertStyler {
    _alertStyler = alertStyler ?: [URBNAlertStyle new];
}

#pragma mark - Methods
- (void)showAlertWithAlertViewController:(URBNAlertViewController *)alertVC {
    if (!self.alertIsVisible) {
        self.alertIsVisible = YES;

        __weak typeof(self) weakSelf = self;
        __weak typeof(alertVC) weakAlertVC = alertVC;
        [alertVC.alertView setButtonTouchedBlock:^(URBNAlertAction *action) {
            if (action.completionBlock) {
                action.completionBlock(weakAlertVC);
            }
        }];
        
        [alertVC setTouchedOutsideBlock:^{
            weakSelf.alertIsVisible = NO;

            if (weakAlertVC.alertConfig.passiveAlertDismissedBlock) {
                weakAlertVC.alertConfig.passiveAlertDismissedBlock(weakSelf, NO);
            }
        }];
        
        [self.window.rootViewController addChildViewController:alertVC];
        [self.window.rootViewController.view addSubview:alertVC.view];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        if (!alertVC.alertConfig.isActiveAlert) {
            [self performSelector:@selector(dismissAlert) withObject:nil afterDelay:alertVC.alertConfig.duration];
        }
    }
    else {
        [self queueAlert:alertVC];
    }
}

- (void)show {
    
}

- (void)dismissAlert {
    self.alertIsVisible = NO;
    
    [self dequeueAlert];
}

- (CGFloat)calculateDuration:(URBNAlertConfig *)config {
    // The average number of words a person can read for minute is 250 - 300
    NSInteger wordCount = [[config.title componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] count];
    wordCount += [[config.message componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] count];
    
    NSInteger wordsPerSecond = 300 / 60;
    CGFloat calculatedDuration = ((wordCount / wordsPerSecond) < 2.f) ? 2.f : (wordCount / wordsPerSecond);
    
    return calculatedDuration;
}

#pragma mark - Queueing
- (void)queueAlert:(URBNAlertViewController *)avc {
    NSMutableArray *mutableQueue = self.queue.mutableCopy;
    if (!mutableQueue) {
        mutableQueue = [NSMutableArray new];
        //self.backgroudViewSnapshot = [self takeSnapshotOfView:self.window.rootViewController.view];
    }
    
    [mutableQueue addObject:avc];
    self.queue = mutableQueue.copy;
}

- (void)dequeueAlert {
    URBNAlertViewController *avc = self.queue.firstObject;
    if (avc) {
        NSMutableArray *mutableQueue = self.queue.mutableCopy;
        [mutableQueue removeObjectAtIndex:0];
        self.queue = mutableQueue.copy;
        [self showAlertWithAlertViewController:avc];
    }
}

@end