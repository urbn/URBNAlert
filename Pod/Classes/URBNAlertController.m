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
@property (nonatomic, assign) BOOL alertIsVisible;
@property (nonatomic, strong) NSMutableArray *queue;

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
- (void)showActiveAlertWithTitle:(NSString *)title message:(NSString *)message hasInput:(BOOL)hasInput buttons:(NSArray *)buttonArray buttonTouchedBlock:(URBNAlertButtonTouched)buttonTouchedBlock {
    NSAssert((buttonArray.count <= 2), @"URBNAlertController: Active alerts only supports up to 2 buttons at the moment");
    NSAssert((buttonArray.count > 0), @"URBNAlertController: Active alerts require at least one button");
    NSAssert(buttonTouchedBlock, @"URBNAlertController: You must implemented the buttonTouchedBlock so you can dismiss the alert somehow. Use a Passive alert if you want an alert that will dismiss after a period of time.");

    URBNAlertConfig *config = [URBNAlertConfig new];
    config.buttonTitles = buttonArray;
    config.title = title;
    config.message = message;
    config.hasInput = hasInput;
    config.isActiveAlert = YES;
    config.customView = nil;
    [config setButtonTouchedBlock:buttonTouchedBlock];
    
    [self showAlertWithConfig:config];
}

- (void)showActiveAlertWithView:(UIView *)view buttons:(NSArray *)buttonArray buttonTouchedBlock:(URBNAlertButtonTouched)buttonTouchedBlock {
    NSAssert((buttonArray.count <= 2), @"URBNAlertController: Active alerts only supports up to 2 buttons at the moment");
    NSAssert((buttonArray.count > 0), @"URBNAlertController: Active alerts require at least one button");
    NSAssert(view, @"URBNAlertController: You need to pass a view to initActiveAlertWithView. C'mon bro.");
    
    URBNAlertConfig *config = [URBNAlertConfig new];
    config.buttonTitles = buttonArray;
    config.customView = view;
    config.isActiveAlert = YES;
    [config setButtonTouchedBlock:buttonTouchedBlock];

    [self showAlertWithConfig:config];
}

#pragma mark - Passive Alerts
- (void)showPassiveAlertWithTitle:(NSString *)title message:(NSString *)message duration:(CGFloat)duration viewTouchedBlock:(URBNAlertPassiveViewTouched)viewTouchedBlock {
    URBNAlertConfig *config = [URBNAlertConfig new];
    config.isActiveAlert = NO;
    config.duration = duration;
    config.title = title;
    config.message = message;
    [config setPassiveViewTouched:viewTouchedBlock];
}

- (void)showPassiveAlertWithTitle:(NSString *)title message:(NSString *)message viewTouchedBlock:(URBNAlertPassiveViewTouched)viewTouchedBlock {
    URBNAlertConfig *config = [URBNAlertConfig new];
    config.isActiveAlert = NO;
    config.title = title;
    config.message = message;

}

- (void)showPassiveAlertWithView:(UIView *)view touchOutsideToDismiss:(BOOL)touchOutsideToDismiss duration:(CGFloat)duration viewTouchedBlock:(URBNAlertPassiveViewTouched)viewTouchedBlock {
    NSAssert(view, @"URBNAlertController: You need to pass a view to initActiveAlertWithView. C'mon bro.");
    
    URBNAlertConfig *config = [URBNAlertConfig new];
    config.isActiveAlert = NO;
    config.duration = duration;
    config.customView = view;
    [config setPassiveViewTouched:viewTouchedBlock];

}

- (void)showPassiveAlertWithView:(UIView *)view touchOutsideToDismiss:(BOOL)touchOutsideToDismiss viewTouchedBlock:(URBNAlertPassiveViewTouched)viewTouchedBlock {
    NSAssert(view, @"URBNAlertController: You need to pass a view to initActiveAlertWithView. C'mon bro.");
    
    URBNAlertConfig *config = [URBNAlertConfig new];
    config.isActiveAlert = NO;
    config.customView = view;
    [config setPassiveViewTouched:viewTouchedBlock];

}

#pragma mark - Setters
- (void)setAlertStyler:(URBNAlertStyle *)alertStyler {
    if (!alertStyler) {
        _alertStyler = [URBNAlertStyle new];
    }
    else {
        _alertStyler = alertStyler;
    }
}

#pragma mark - Methods
- (void)showAlertWithConfig:(URBNAlertConfig *)config {
    if (!self.alertIsVisible) {
        self.alertViewController = [[URBNAlertViewController alloc] initWithAlertConfig:config alertController:self];
        self.alertIsVisible = YES;

        __weak typeof(self) weakSelf = self;
        [self.alertViewController.alertView setButtonTouchedBlock:^(NSInteger index) {
            if (config.buttonTouchedBlock) {
                config.buttonTouchedBlock(weakSelf, index);
            }
        }];
        
        [self.window.rootViewController addChildViewController:self.alertViewController];
        [self.window.rootViewController.view addSubview:self.alertViewController.view];
    }
    else {
        [self queueAlert:config];
    }
}

- (void)dismissAlert {
    [self.alertViewController dismissAlert];
    self.alertIsVisible = NO;
    
    [self dequeueAlert];
}

#pragma mark - Queueing
- (void)queueAlert:(URBNAlertConfig *)config {
    if (!self.queue) {
        self.queue = [[NSMutableArray alloc] init];
    }
    
    [self.queue addObject:config];
}

- (void)dequeueAlert {
    URBNAlertConfig *config = self.queue.firstObject;
    if (config) {
        [self.queue removeObjectAtIndex:0];
        [self showAlertWithConfig:config];
    }
}

@end