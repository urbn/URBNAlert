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
#import <URBNConvenience/URBNTextField.h>
#import "URBNAlertAction.h"

@interface URBNAlertController(Private)

- (void)dismissingAlert;
- (void)addAlertToQueueWithAlertViewController:(URBNAlertViewController *)avc;
@property (nonatomic, strong, readonly) UIWindow *presentingWindow;

@end

@interface URBNAlertViewController ()

@property (nonatomic, strong) URBNAlertController *alertController;
@property (nonatomic, strong) NSLayoutConstraint *yPosConstraint;
@property (nonatomic, strong) UIImageView *blurImageView;
@property (nonatomic, assign) BOOL alertVisible;
@property (nonatomic, assign) BOOL viewControllerVisible;
@property (nonatomic, assign) NSUInteger indexOfLoadingTextField;
@property (nonatomic, readonly) UIView *viewForScreenshot;

@end

@implementation URBNAlertViewController

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
        self.blurImageView.alpha = 0.0;
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
    
    if (self.alertConfig.touchOutsideViewToDismiss && !self.viewControllerVisible) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert:)];
        [self.view addGestureRecognizer:tapGesture];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Added this check so if you presented a modal via a passive alert then
    //   dismissed that modal, another alert is not added to the view if the alert
    //   did not finish dismissing yet
    if (!self.viewControllerVisible) {
        [self setVisible:YES animated:YES completion:nil];
    }
    
    self.viewControllerVisible = YES;
    
    if (self.alertStyler.firstResponder) {
        [self.alertStyler.firstResponder becomeFirstResponder];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    self.viewControllerVisible = NO;
}

#pragma mark - Methods
- (void)addAction:(URBNAlertAction *)action {
    NSMutableArray *actions = [self.alertConfig.actions mutableCopy] ?: [NSMutableArray new];
    [actions addObject:action];
    
    self.alertConfig.actions = [actions copy];
    
    if (action.actionType != URBNAlertActionTypePassive) {
        self.alertConfig.isActiveAlert = YES;
    }
}

- (void)addBlurScreenshot {
    [self addBlurScreenshotOfSize:CGSizeZero];
}

- (void)addBlurScreenshotOfSize:(CGSize)size {
    CGRect rect = self.viewForScreenshot.bounds;
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        rect.size = size;
    }
    
    UIImage *screenShot = [UIImage urbn_screenShotOfView:self.viewForScreenshot afterScreenUpdates:YES];
    
    if (screenShot) {
        UIImage *blurImage = [screenShot applyBlurWithRadius:self.alertStyler.blurRadius.floatValue tintColor:self.alertStyler.blurTintColor saturationDeltaFactor:self.alertStyler.blurSaturationDelta.floatValue maskImage:nil];
        if (!self.blurImageView) {
            self.blurImageView = [[UIImageView alloc] initWithFrame:rect];
            self.blurImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
            [self.blurImageView urbn_wrapInContainerViewWithView:self.view];
        }
        [self.blurImageView setImage:blurImage];
    }
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler {
    NSMutableArray *inputs = [self.alertConfig.inputs mutableCopy] ?: [NSMutableArray new];
    
    UITextField *textField = [URBNTextField new];
    if (configurationHandler) {
        configurationHandler(textField);
    }
    
    [inputs addObject:textField];
    self.alertConfig.inputs = inputs;
}

- (void)show {
    self.alertView = [[URBNAlertView alloc] initWithAlertConfig:self.alertConfig alertStyler:self.alertStyler customView:self.customView];
    self.alertView.alpha = 0;
    self.alertView.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGFloat screenWidth;
    if (self.alertConfig.presentationView) {
        screenWidth = self.alertConfig.presentationView.frame.size.width;
    }
    else {
        screenWidth = [UIScreen mainScreen].bounds.size.width;
    }
    
    CGFloat sideMargins = screenWidth * 0.05;
    NSDictionary *metrics = @{@"sideMargins" : @(sideMargins)};

    if (self.alertStyler.alertMinWidth && self.alertStyler.alertMaxWidth) {
        CGFloat minWidth = self.alertStyler.alertMinWidth.floatValue;
        CGFloat maxWidthPossible = (screenWidth - (sideMargins * 2));
        if (minWidth > maxWidthPossible) {
            minWidth = maxWidthPossible;
        }
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:minWidth]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:self.alertStyler.alertMaxWidth.floatValue]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=sideMargins-[_alertView]->=sideMargins-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_alertView)]];
    }
    else {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideMargins-[_alertView]-sideMargins-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_alertView)]];
    }
    
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

- (void)setVisible:(BOOL)visible animated:(BOOL)animated completion:(void (^)(URBNAlertViewController *alertVC, BOOL finished))complete {
    self.alertVisible = visible;
    
    CGFloat scaler = 0.3f;
    if (visible) {
        self.alertView.alpha = 0.0;
        self.alertView.transform = CGAffineTransformMakeScale(scaler, scaler);
    }
    
    CGFloat alpha = visible ? 1.0 : 0.0;
    CGAffineTransform transform = visible ? CGAffineTransformIdentity : CGAffineTransformMakeScale(scaler, scaler);
    
    void (^bounceAnimation)() = ^(void) {
        self.alertView.transform = transform;
    };
    
    void (^fadeAnimation)() = ^(void) {
        self.alertView.alpha = alpha;
        self.view.alpha = alpha;
        if (self.alertStyler.blurEnabled.boolValue) {
            self.blurImageView.alpha = alpha;
        }
    };
    
    if (animated) {
        CGFloat duration = self.alertStyler.animationDuration.floatValue;
        CGFloat damping = self.alertStyler.animationDamping.floatValue;
        CGFloat initialVelocity = visible ? 0 : self.alertStyler.animationInitialVelocity.floatValue;

        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:damping initialSpringVelocity:initialVelocity options:0 animations:bounceAnimation completion:^(BOOL finished) {
            if (complete) {
                complete(self, finished);
            }
        }];
        
        [UIView animateWithDuration:(duration / 2.0) animations:fadeAnimation completion:nil];
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
    [self startLoadingTextFieldAtIndex:0];
}

- (void)startLoadingTextFieldAtIndex:(NSUInteger)index {
    self.indexOfLoadingTextField = index;
    [self.alertView setLoadingState:YES forTextFieldAtIndex:index];
}

- (void)stopLoading {
    [self.alertView setLoadingState:NO forTextFieldAtIndex:self.indexOfLoadingTextField];
}

- (UITextField *)textFieldAtIndex:(NSUInteger)index {
    if (index < self.alertConfig.inputs.count)  {
        return [self.alertConfig.inputs objectAtIndex:index];
    }
    
    return nil;
}

- (UITextField *)textField {
    return [self textFieldAtIndex:0];
}

- (UIView *)viewForScreenshot {
    return self.alertConfig.presentationView ?: self.alertController.presentingWindow;
}

#pragma mark - Action
- (void)dismissAlert:(id)sender {
    [self.view endEditing:YES];
    [self.alertController dismissingAlert];
    
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
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    if (self.alertStyler.blurEnabled.boolValue) {
        [self addBlurScreenshotOfSize:size];
        
        [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            [self addBlurScreenshot];
        }];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (self.alertStyler.blurEnabled.boolValue && ![UIViewController instancesRespondToSelector:@selector(viewWillTransitionToSize:withTransitionCoordinator:)]) {
        CGSize size = self.viewForScreenshot.bounds.size;
        size.height = size.width;
        size.width = self.viewForScreenshot.bounds.size.height;
        [self addBlurScreenshotOfSize:size];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    if (self.alertStyler.blurEnabled.boolValue && ![UIViewController instancesRespondToSelector:@selector(viewWillTransitionToSize:withTransitionCoordinator:)]) {
        [self addBlurScreenshot];
    }
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.alertController.presentingWindow.rootViewController.preferredStatusBarStyle;
}

@end
