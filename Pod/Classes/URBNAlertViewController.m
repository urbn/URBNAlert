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
#import "UIImage+ImageEffects.h"

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
    
    UIImage *blurImage = [self.alertConfig.backgroundViewSnapshot applyBlurWithRadius:self.alertController.alertStyler.blurRadius.floatValue tintColor:self.alertController.alertStyler.blurTintColor saturationDeltaFactor:self.alertController.alertStyler.blurSaturationDelta.floatValue maskImage:nil];
    UIImageView *blurImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [blurImageView setImage:blurImage];
    
    [self.view addSubview:blurImageView];
    [self.view addSubview:self.alertView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.alertConfig.touchOutsideToDismiss) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert:)];
        [self.view addGestureRecognizer:tapGesture];
    }
    
    // If passive alert, need call back when alert was touched
    if (!self.alertConfig.isActiveAlert) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passiveAlertViewTouched)];
        [self.alertView addGestureRecognizer:tapGesture];
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
    
    CGFloat animationDuration = self.alertController.alertStyler.animationDuration.floatValue;
    CGFloat scaler = 0.3f;
    if (visible) {
        self.alertView.alpha = 0.0;
        self.alertView.transform = CGAffineTransformMakeScale(scaler, scaler);
    }
    
    CGFloat alpha = visible ? 1.0 : 0.0;
    CGAffineTransform transform = visible ? CGAffineTransformIdentity : CGAffineTransformMakeScale(scaler, scaler);
    CGFloat initialSpringVelocity = visible ? 0 : -10;
    
    void (^bounceAnimation)() = ^(void) {
        self.alertView.transform = transform;
    };
    
    void (^fadeAnimation)() = ^(void) {
        self.alertView.alpha = alpha;
        self.view.alpha = alpha;
    };
    
    if (animated) {
        CGFloat doubleDuration = animationDuration * 2;
        [UIView animateWithDuration:doubleDuration delay:0 usingSpringWithDamping:doubleDuration initialSpringVelocity:initialSpringVelocity options:0 animations:bounceAnimation completion:^(BOOL finished) {
            if (complete) {
                complete(self, finished);
            }
        }];
        
        [UIView animateWithDuration:animationDuration animations:fadeAnimation completion:nil];
    }
    else {
        fadeAnimation();
        bounceAnimation();
        if (complete) {
            complete(self, YES);
        }
    }
}

- (void)dismissAlert:(id)sender {
    [self.view endEditing:YES];
    
    __weak typeof(self) weakSelf = self;
    [self setVisible:NO animated:YES completion:^(URBNAlertViewController *alertVC, BOOL finished) {
        // Must let the controller know if alert was dismissed via touching outside
        if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
            if (weakSelf.touchedOutsideBlock) {
                weakSelf.touchedOutsideBlock();
            }
        }
        
        [weakSelf.view removeFromSuperview];
    }];
}

- (void)passiveAlertViewTouched {
    __weak typeof(self) weakSelf = self;
    if (self.alertConfig.passiveAlertDismissedBlock) {
        weakSelf.alertConfig.passiveAlertDismissedBlock(weakSelf.alertController, YES);
    }
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