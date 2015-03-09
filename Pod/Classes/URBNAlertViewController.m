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
#import <URBNConvenience/URBNMacros.h>

@interface URBNAlertViewController ()

@property (nonatomic, strong) URBNAlertController *alertController;
@property (nonatomic, strong) URBNAlertConfig *alertConfig;
@property (nonatomic, strong) NSLayoutConstraint *yPosConstraint;
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
        
        CGFloat screenWdith = [UIScreen mainScreen].nativeBounds.size.width;
        CGFloat sideMargins = IS_IPHONE_6P ? screenWdith * 0.1 : screenWdith * 0.05;

        NSDictionary *metrics = @{@"sideMargins" : @(sideMargins)};
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideMargins-[_alertView]-sideMargins-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_alertView)]];
        
        self.yPosConstraint = [NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [self.view addConstraint:self.yPosConstraint];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    }
    
    return self;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    [self.view addSubview:self.alertView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];;
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
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
    [self.view endEditing:YES];
    
    __weak typeof(self) weakSelf = self;
    [self setVisible:NO animated:YES completion:^(URBNAlertViewController *alertVC, BOOL finished) {
        [weakSelf.view removeFromSuperview];
    }];
}

#pragma mark - Keyboard Notifications
- (void)keyboardWillShow:(NSNotification *)sender {
    CGRect keyboardFrame = [sender.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat alertViewBottomYPos = self.alertView.frame.size.height + (self.alertView.frame.origin.y);
    
    self.yPosConstraint.constant = -(alertViewBottomYPos - keyboardFrame.origin.y);
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)sender {
    self.yPosConstraint.constant = 0;
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end