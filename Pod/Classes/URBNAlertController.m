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

@interface URBNAlertController ()

@property (nonatomic, strong) URBNAlertViewController *alertViewController;
@property (nonatomic, strong) UIWindow *window;


@end

@implementation URBNAlertController

- (instancetype)initActiveAlertWithTitle:(NSString *)title message:(NSString *)message hasInput:(BOOL)hasInput buttons:(NSArray *)buttonArray {
    NSAssert((buttonArray.count <= 2), @"URBNAlertController: Active alerts only supports up to 2 buttons at the moment");
    NSAssert((buttonArray.count > 0), @"URBNAlertController: Active alerts require at least one button");

    self = [super init];
    if (self) {
        self.buttonTitles = buttonArray;
        self.title = title;
        self.message = message;
        self.hasInput = hasInput;
        self.window = [[UIApplication sharedApplication] windows][0];
    }
    return self;
}

- (void)showAlert {
    self.alertViewController = [[URBNAlertViewController alloc] initWithAlertController:self];
    
    __weak typeof(self) weakSelf = self;
    [self.alertViewController.alertView setButtonTouchedBlock:^(NSInteger index) {
        if (weakSelf.buttonTouchedBlock) {
            weakSelf.buttonTouchedBlock(weakSelf, index);
        }
    }];
    
    [self.window.rootViewController addChildViewController:self.alertViewController];
    [self.window.rootViewController.view addSubview:self.alertViewController.view];
}

- (void)dismissAlert {
    [self.alertViewController dismissAlert];
}

@end