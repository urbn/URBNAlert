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

@interface URBNAlertController ()

@property (nonatomic, strong) URBNAlertViewController *alertViewController;
@property (nonatomic, strong) UIWindow *window;
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
    NSAssert((buttonArray.count > 0), @"URBNAlertController: Active alerts require at least one button. Use a Passive alert if you want an alert that will dismiss after a period of time.");
    NSAssert(buttonTouchedBlock, @"URBNAlertController: You must implemented the buttonTouchedBlock so you can dismiss the alert somehow. Use a Passive alert if you want an alert that will dismiss after a period of time.");

    URBNAlertConfig *config = [URBNAlertConfig new];
    config.buttonTitles = buttonArray;
    config.title = title;
    config.message = message;
    config.hasInput = hasInput;
    config.isActiveAlert = YES;
    config.customView = nil;
    config.touchOutsideToDismiss = touchOutsideToDismiss;
    [config setButtonTouchedBlock:buttonTouchedBlock];
    
    [self showAlertWithConfig:config];
}

- (void)showActiveAlertWithView:(UIView *)view buttonTitles:(NSArray *)buttonArray touchOutsideToDismiss:(BOOL)touchOutsideToDismiss buttonTouchedBlock:(URBNAlertButtonTouched)buttonTouchedBlock {
    NSAssert((buttonArray.count <= 2), @"URBNAlertController: Active alerts only supports up to 2 buttons at the moment. Please create an issue if you want more!");
    NSAssert((buttonArray.count > 0), @"URBNAlertController: Active alerts require at least one button. Use a Passive alert if you want an alert that will dismiss after a period of time.");
    NSAssert(view, @"URBNAlertController: You need to pass a view to initActiveAlertWithView. C'mon bro.");
    
    URBNAlertConfig *config = [URBNAlertConfig new];
    config.buttonTitles = buttonArray;
    config.customView = view;
    config.isActiveAlert = YES;
    config.touchOutsideToDismiss = touchOutsideToDismiss;
    [config setButtonTouchedBlock:buttonTouchedBlock];

    [self showAlertWithConfig:config];
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
    
    [self showAlertWithConfig:config];
}

- (void)showPassiveAlertWithTitle:(NSString *)title message:(NSString *)message touchOutsideToDismiss:(BOOL)touchOutsideToDismiss alertDismissedBlock:(URBNAlertPassiveAlertDismissed)alertDismissedBlock {
    URBNAlertConfig *config = [URBNAlertConfig new];
    config.isActiveAlert = NO;
    config.title = title;
    config.message = message;
    config.duration = [self calculateDuration:config];
    config.touchOutsideToDismiss = touchOutsideToDismiss;
    [config setPassiveAlertDismissedBlock:alertDismissedBlock];
    
    [self showAlertWithConfig:config];
}

- (void)showPassiveAlertWithView:(UIView *)view touchOutsideToDismiss:(BOOL)touchOutsideToDismiss duration:(CGFloat)duration alertDismissedBlock:(URBNAlertPassiveAlertDismissed)alertDismissedBlock {
    NSAssert(view, @"URBNAlertController: You need to pass a view to initActiveAlertWithView. C'mon bro.");
    
    URBNAlertConfig *config = [URBNAlertConfig new];
    config.isActiveAlert = NO;
    config.duration = duration;
    config.customView = view;
    config.touchOutsideToDismiss = touchOutsideToDismiss;
    [config setPassiveAlertDismissedBlock:alertDismissedBlock];
    
    [self showAlertWithConfig:config];
}

#pragma mark - Setters
- (void)setAlertStyler:(URBNAlertStyle *)alertStyler {
    _alertStyler = alertStyler ?: [URBNAlertStyle new];
}

#pragma mark - Methods
- (void)showAlertWithConfig:(URBNAlertConfig *)config {
    if (!self.alertIsVisible) {
        config.backgroundViewSnapshot = self.backgroudViewSnapshot ?: [self takeSnapshotOfView:self.window.rootViewController.view];
        self.alertViewController = [[URBNAlertViewController alloc] initWithAlertConfig:config alertController:self];
        self.alertIsVisible = YES;

        __weak typeof(self) weakSelf = self;
        [self.alertViewController.alertView setButtonTouchedBlock:^(NSInteger index) {
            if (config.buttonTouchedBlock) {
                config.buttonTouchedBlock(weakSelf, index);
            }
        }];
        
        [self.alertViewController setTouchedOutsideBlock:^{
            weakSelf.alertIsVisible = NO;

            if (config.passiveAlertDismissedBlock) {
                config.passiveAlertDismissedBlock(weakSelf, NO);
            }
        }];
        
        [self.window.rootViewController addChildViewController:self.alertViewController];
        [self.window.rootViewController.view addSubview:self.alertViewController.view];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        if (!config.isActiveAlert) {
            [self performSelector:@selector(dismissAlert) withObject:nil afterDelay:config.duration];
        }
    }
    else {
        [self queueAlert:config];
    }
}

- (void)dismissAlert {
    [self.alertViewController dismissAlert:nil];
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

- (UIImage *)takeSnapshotOfView:(UIView *)view {
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Queueing
- (void)queueAlert:(URBNAlertConfig *)config {
    NSMutableArray *mutableQueue = self.queue.mutableCopy;
    if (!mutableQueue) {
        mutableQueue = [NSMutableArray new];
        self.backgroudViewSnapshot = [self takeSnapshotOfView:self.window.rootViewController.view];
    }
    
    [mutableQueue addObject:config];
    self.queue = mutableQueue.copy;
}

- (void)dequeueAlert {
    URBNAlertConfig *config = self.queue.firstObject;
    if (config) {
        NSMutableArray *mutableQueue = self.queue.mutableCopy;
        [mutableQueue removeObjectAtIndex:0];
        self.queue = mutableQueue.copy;
        [self showAlertWithConfig:config];
    }
}

@end