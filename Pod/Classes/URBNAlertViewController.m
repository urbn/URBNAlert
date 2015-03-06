//
//  URBNAlertViewController.m
//  URBNAlertTest
//
//  Created by Ryan Garchinsky on 3/3/15.
//  Copyright (c) 2015 URBN. All rights reserved.
//

#import "URBNAlertViewController.h"
#import "URBNAlertView.h"
#import "URBNAlertController.h"
#import "URBNAlertConfig.h"

@interface URBNAlertViewController ()

@property (nonatomic, strong) URBNAlertController *alertController;
@property (nonatomic, strong) URBNAlertConfig *alertConfig;
@property (nonatomic, assign) BOOL visible;

@end

@implementation URBNAlertViewController

#pragma mark - Initalizers
- (instancetype)initWithAlertConfig:(URBNAlertConfig *)config alertController:(URBNAlertController *)controller {
    self = [super init];
    if (self) {
        self.alertController = controller;
        self.alertConfig = config;
        
        self.alertView = [[URBNAlertView alloc] initWithAlertConfig:config alertController:controller];
        self.alertView.alpha = 0;
        self.alertView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_alertView(205)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_alertView)]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    }
    
    return self;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    [self.view addSubview:self.alertView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.alertConfig.touchOutsideToDismiss) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert)];
        [self.view addGestureRecognizer:tapGesture];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setVisible:YES animated:YES completion:nil];
}

#pragma mark - Methods
- (void)setVisible:(BOOL)visible animated:(BOOL)animated completion:(void (^)(URBNAlertViewController *alertVC, BOOL finished))complete {
    self.visible = visible;
    
    if (visible) {
        self.alertView.alpha = 0.0;
        self.alertView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    }
    
    CGFloat alpha = visible ? 1.0 : 0.0;
    CGAffineTransform transform = visible ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0.3, 0.3);
    CGFloat initialSpringVelocity = visible ? 0 : -10;
    
    void (^bounceAnimation)() = ^(void) {
        self.alertView.transform = transform;
    };
    
    void (^fadeAnimation)() = ^(void) {
        self.alertView.alpha = alpha;
        self.view.alpha = alpha;
    };
    
    if (animated) {
        [UIView animateWithDuration:(0.3 * 2) delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:initialSpringVelocity options:0 animations:bounceAnimation completion:^(BOOL finished) {
            if (complete) {
                complete(self, finished);
            }
        }];
        
        [UIView animateWithDuration:0.3 animations:fadeAnimation completion:nil];
    }
    else {
        fadeAnimation();
        bounceAnimation();
        if (complete) {
            complete(self, YES);
        }
    }
}

- (void)dismissAlert {
    __weak typeof(self) weakSelf = self;
    [self setVisible:NO animated:YES completion:^(URBNAlertViewController *alertVC, BOOL finished) {
        [weakSelf.view removeFromSuperview];
    }];
}

@end