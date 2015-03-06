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

static NSMutableArray *queue;

@interface URBNAlertController ()

@property (nonatomic, strong) URBNAlertViewController *alertViewController;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) BOOL alertIsVisible;

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

- (void)showActiveAlertWithTitle:(NSString *)title message:(NSString *)message hasInput:(BOOL)hasInput buttons:(NSArray *)buttonArray buttonTouchedBlock:(URBNAlertButtonTouched)buttonTouchedBlock {
    NSAssert((buttonArray.count <= 2), @"URBNAlertController: Active alerts only supports up to 2 buttons at the moment");
    NSAssert((buttonArray.count > 0), @"URBNAlertController: Active alerts require at least one button");

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
    if (!queue) {
        queue = [[NSMutableArray alloc] init];
    }
    
    [queue addObject:config];
}

- (void)dequeueAlert {
    URBNAlertConfig *config = queue.firstObject;
    if (config) {
        [queue removeObjectAtIndex:0];
        [self showAlertWithConfig:config];
    }
}

@end