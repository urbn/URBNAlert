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
#import <URBNConvenience/UIImage+URBN.h>
#import <URBNConvenience/UIView+URBNLayout.h>
#import <URBNConvenience/UIView+URBNAnimations.h>
#import "URBNAlertAction.h"

@interface URBNAlertViewController ()

@property (nonatomic, strong) URBNAlertController *alertController;
@property (nonatomic, strong) NSLayoutConstraint *yPosConstraint;
@property (nonatomic, strong) UIImageView *blurImageView;
@property (nonatomic, assign) BOOL visible;

@end

@implementation URBNAlertViewController
{
    CADisplayLink *_rotationLink;
}

#pragma mark - Initalizers
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message view:(UIView *)view {
    self = [super init];
    if (self) {
        self.alertConfig = [URBNAlertConfig new];
        self.alertConfig.title = title;
        self.alertConfig.message = message;
        self.customView = view;
        self.alertController = [URBNAlertController sharedInstance];
        self.alertStyler = [self.alertController.alertStyler copy];
        
        _rotationLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(addBlurScreenshot)];
        [_rotationLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        _rotationLink.paused = YES;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    return [self initWithTitle:title message:message view:nil];
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.alertStyler.blurEnabled.boolValue) {
        [self addBlurScreenshot];
    }
    else if (self.alertStyler.backgroundViewTintColor) {
        self.view.backgroundColor = self.alertStyler.backgroundViewTintColor;
    }
    
    [self.view addSubview:self.alertView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.alertConfig.touchOutsideViewToDismiss) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert:)];
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
- (void)addAction:(URBNAlertAction *)action {
    NSMutableArray *actions = [self.alertConfig.actions mutableCopy] ?: [NSMutableArray new];
    [actions addObject:action];
    
    NSAssert(actions.count <= 2, @"URBNAlertController: Active alerts only supports up to 2 buttons at the moment. Please create an issue if you want more!");
    
    self.alertConfig.actions = [actions copy];
    
    if (action.actionType != URBNAlertActionTypePassive) {
        self.alertConfig.isActiveAlert = YES;
    }
}

- (void)addBlurScreenshot {
    UIView *viewForScreenshot = self.alertConfig.presentationView ?: self.alertController.presentingWindow;
    UIImage *screenShot = [UIImage urbn_screenShotOfView:viewForScreenshot afterScreenUpdates:NO];
    UIImage *blurImage = [screenShot applyBlurWithRadius:self.alertStyler.blurRadius.floatValue tintColor:self.alertStyler.blurTintColor saturationDeltaFactor:self.alertStyler.blurSaturationDelta.floatValue maskImage:nil];
    if (!self.blurImageView) {
        self.blurImageView = [[UIImageView alloc] initWithFrame:viewForScreenshot.frame];
        self.blurImageView.contentMode = UIViewContentModeCenter;
        [self.blurImageView urbn_wrapInContainerViewWithView:self.view];
    }
    [self.view sendSubviewToBack:self.blurImageView];
    [self.blurImageView setImage:blurImage];
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler {
    NSAssert(!self.textField, @"URBNAlertController: Active alerts only supports up 1 input text field at the moment. Please create an issue if you want more!");
    
    UITextField *textField = [UITextField new];
    if (configurationHandler) {
        configurationHandler(textField);
    }
    
    self.textField = textField;
}

- (void)show {
    self.alertView = [[URBNAlertView alloc] initWithAlertConfig:self.alertConfig alertStyler:self.alertStyler customView:self.customView textField:self.textField];
    self.alertView.alpha = 0;
    self.alertView.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGFloat screenWdith;
    
    if (self.alertConfig.presentationView) {
        screenWdith = self.alertConfig.presentationView.frame.size.width;
    }
    else if ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]) {
        screenWdith = [UIScreen mainScreen].nativeBounds.size.width;
    }
    else {
        screenWdith = [UIScreen mainScreen].bounds.size.width;
    }
    
    CGFloat sideMargins = screenWdith * 0.05;
    
    NSDictionary *metrics = @{@"sideMargins" : @(sideMargins)};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideMargins-[_alertView]-sideMargins-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_alertView)]];
    
    self.yPosConstraint = [NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self.view addConstraint:self.yPosConstraint];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.alertController addAlertToQueueWithAlertViewController:self];
}

- (void)showInView:(UIView *)view {
    self.alertConfig.presentationView = view;
    [self show];
}

- (void)dismiss {
    [self dismissAlert:nil];
}

#pragma mark - Methods
- (void)setVisible:(BOOL)visible animated:(BOOL)animated completion:(void (^)(URBNAlertViewController *alertVC, BOOL finished))complete {
    self.visible = visible;
    
    CGFloat animationDuration = self.alertStyler.animationDuration.floatValue;
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

- (void)showInputError:(NSString *)errorText {
    [self.alertView setErrorLabelText:errorText];
}

- (void)startLoading {
    [self.alertView setLoadingState:YES];
}

- (void)stopLoading {
    [self.alertView setLoadingState:NO];
}

#pragma mark - Action
- (void)dismissAlert:(id)sender {
    [self.view endEditing:YES];
    [self.alertController dismissAlert];
    
    __weak typeof(self) weakSelf = self;
    [self setVisible:NO animated:YES completion:^(URBNAlertViewController *alertVC, BOOL finished) {
        // Must let the controller know if alert was dismissed via touching outside
        if (weakSelf.finishedDismissingBlock) {
            BOOL wasTouchedOutside = [sender isKindOfClass:[UITapGestureRecognizer class]];
            weakSelf.finishedDismissingBlock(wasTouchedOutside);
        }
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - Orientation Notifications
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    _rotationLink.paused = NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    _rotationLink.paused = YES;
}

#pragma mark - Keyboard Notifications
- (void)keyboardWillShow:(NSNotification *)sender {
    CGRect keyboardFrame = [sender.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat alertViewBottomYPos = self.alertView.frame.size.height + (self.alertView.frame.origin.y);
    
    CGFloat yOffset = -(alertViewBottomYPos - keyboardFrame.origin.y);
    
    if (yOffset < 0) {
        self.yPosConstraint.constant = yOffset - 30; // 30 more for so its not right up against the keyboard
        
        [UIView animateWithDuration:0.3f animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)sender {
    self.yPosConstraint.constant = 0;
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end