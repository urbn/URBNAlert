//
//  URBNAlertView.m
//  URBNAlertTest
//
//  Created by Ryan Garchinsky on 3/3/15.
//  Copyright (c) 2015 URBN. All rights reserved.
//

#import "URBNAlertView.h"
#import "URBNAlertController.h"
#import "URBNAlertConfig.h"
#import "URBNAlertAction.h"
#import <URBNConvenience/UITextField+URBNLoadingIndicator.h>
#import <URBNConvenience/UIView+URBNLayout.h>
#import <URBNConvenience/URBNMacros.h>

@implementation URBNAlertActionButton

@end

static NSInteger const kURBNAlertViewHeightPadding = 80.f;

@interface URBNAlertView()

@property (nonatomic, strong) URBNAlertConfig *alertConfig;
@property (nonatomic, strong) URBNAlertStyle *alertStyler;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *messageTextView;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, copy) NSArray *buttons;
@property (nonatomic, assign) NSInteger sectionCount;

@end

@implementation URBNAlertView

- (instancetype)initWithAlertConfig:(URBNAlertConfig *)config alertStyler:(URBNAlertStyle *)alertStyler customView:(UIView *)customView {
    self = [super init];
    if (self) {
        self.alertConfig = config;
        self.alertStyler = alertStyler;
        
        if (!customView) {
            // Give it a dummy view
            self.customView = [UIView new];
        }
        else {
            self.customView = customView;
            self.sectionCount++;
        }
        
        self.customView.translatesAutoresizingMaskIntoConstraints = NO;

        self.backgroundColor = self.alertStyler.backgroundColor ?: [UIColor whiteColor];
        self.layer.cornerRadius = self.alertStyler.alertCornerRadius.floatValue;
        
        UIView *buttonContainer = [UIView new];
        NSDictionary *views;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.messageTextView];
        [self addSubview:self.errorLabel];
        [self addSubview:self.customView];
        
        NSMutableDictionary *mutableViews = [NSMutableDictionary dictionaryWithDictionary:@{@"_customView" : _customView, @"_titleLabel" : _titleLabel, @"_messageTextView" : _messageTextView, @"buttonContainer" : buttonContainer, @"_errorLabel" : _errorLabel}];

        if (self.alertConfig.inputs && self.alertConfig.inputs.count > 0) {
            __weak typeof(self) weakSelf = self;
            
            [self.alertConfig.inputs enumerateObjectsUsingBlock:^(UITextField *tf, NSUInteger idx, BOOL *stop) {
                tf.translatesAutoresizingMaskIntoConstraints = NO;
                [mutableViews setObject:tf forKey:[NSString stringWithFormat:@"textField%ld", idx]];
                weakSelf.sectionCount++;
                [weakSelf addSubview:tf];
            }];
        }
        
        views = [mutableViews copy];
        
        // Add some buttons
        NSMutableArray *btns = [NSMutableArray new];
        buttonContainer.translatesAutoresizingMaskIntoConstraints = NO;
        
        __weak typeof(self) weakSelf = self;
        [self.alertConfig.actions enumerateObjectsUsingBlock:^(URBNAlertAction *action, NSUInteger idx, BOOL *stop) {
            if (action.isButton) {
                URBNAlertActionButton *btn = [weakSelf createAlertViewButtonWithAction:action atIndex:idx];
                [buttonContainer addSubview:btn];
                [btns addObject:btn];
                action.actionButton = btn;
            }
        }];
        
        [self addSubview:buttonContainer];
        
        // Handle if no title or messages, give 0 margins
        NSNumber *titleMargin = self.alertConfig.title.length > 0 ? self.alertStyler.sectionVerticalMargin : @0;
        NSNumber *msgMargin = self.alertConfig.message.length > 0 ? self.alertStyler.sectionVerticalMargin : @0;
        
        if (titleMargin.floatValue > 0) {
            self.sectionCount++;
        }
        
        if (msgMargin.floatValue > 0) {
            self.sectionCount++;
        }

        NSDictionary *metrics = @{@"sectionMargin" : self.alertStyler.sectionVerticalMargin,
                                  @"btnH" : self.alertStyler.buttonHeight,
                                  @"lblHMargin" : self.alertStyler.labelHorizontalMargin,
                                  @"titleVMargin" : titleMargin,
                                  @"msgVMargin" : msgMargin,
                                  @"btnMargin" : self.alertStyler.buttonHorizontalMargin,
                                  @"cvMargin" : self.alertStyler.customViewMargin,
                                  @"tfVMargin": self.alertStyler.textFieldVerticalMargin};
        
        for (UIView *lbl in @[self.titleLabel, self.messageTextView, self.errorLabel]) {
            lbl.translatesAutoresizingMaskIntoConstraints = NO;
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-lblHMargin-[lbl]-lblHMargin-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(lbl)]];
        }
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-cvMargin-[_customView]-cvMargin-|" options:0 metrics:metrics views:views]];
        
        if (!self.alertConfig.inputs && self.alertConfig.inputs.count == 0) {
            if (self.alertConfig.isActiveAlert) {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-titleVMargin-[_titleLabel]-msgVMargin-[_messageTextView]-cvMargin-[_customView]-5-[_errorLabel]-cvMargin-[buttonContainer]-btnMargin-|" options:0 metrics:metrics views:views]];
            }
            // Passive alert, dont added margins for buttonContainer
            else {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-titleVMargin-[_titleLabel]-msgVMargin-[_messageTextView]-cvMargin-[_customView]-cvMargin-|" options:0 metrics:metrics views:views]];
            }
        }
        else {
            NSMutableString *vertVfl = [NSMutableString stringWithString:@"V:|-titleVMargin-[_titleLabel]-msgVMargin-[_messageTextView]-cvMargin-[_customView]-cvMargin-"];
          
            [self.alertConfig.inputs enumerateObjectsUsingBlock:^(UITextField *tf, NSUInteger idx, BOOL *stop) {
                [vertVfl appendString:[NSString stringWithFormat:@"[textField%ld]-tfVMargin-", idx]];
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-lblHMargin-[textField%ld]-lblHMargin-|", idx] options:0 metrics:metrics views:views]];
            }];
            
            [vertVfl appendString:@"[_errorLabel]-btnMargin-[buttonContainer]-btnMargin-|"];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vertVfl options:0 metrics:metrics views:views]];
        }
        
        // Button Constraints
        self.buttons = [btns copy];
        if (self.buttons.count == 1) {
            self.sectionCount++;
            [buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[btnOne]|" options:0 metrics:metrics views:@{@"btnOne" : self.buttons.firstObject}]];
            [buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btnOne(btnH)]|" options:0 metrics:metrics views:@{@"btnOne" : self.buttons.firstObject}]];
        }
        else if (self.buttons.count == 2) {
            self.sectionCount++;
            [buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[btnOne]-[btnTwo(==btnOne)]|" options:0 metrics:nil views:@{@"btnOne" : self.buttons.firstObject, @"btnTwo" : self.buttons[1]}]];
            [buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btnOne(btnH)]|" options:0 metrics:metrics views:@{@"btnOne" : self.buttons.firstObject}]];
            [buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btnTwo(btnH)]|" options:0 metrics:metrics views:@{@"btnTwo" : self.buttons[1]}]];
        }
        // TODO: Handle 3+ buttons with a vertical layout
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-btnMargin-[buttonContainer]-btnMargin-|" options:0 metrics:metrics views:views]];
        
        // If passive alert & a passive action was added, need call back when alertview is touched
        if (!self.alertConfig.isActiveAlert && self.alertConfig.actions.count > 0) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passiveAlertViewTouched)];
            [self addGestureRecognizer:tapGesture];
        }
    }
    
    return self;
}

- (void)layoutSubviews {
    [self.messageTextView sizeToFit];
    [self.messageTextView layoutIfNeeded];
    
    CGFloat buttonHeight = self.buttons.count == 0 ? 0 : self.alertStyler.buttonHeight.floatValue;
    CGFloat screenHeight = SCREEN_HEIGHT;
    
    // Need this check because before iOS 8 screen.bounes.size is NOT orientation dependent
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if ((SYSTEM_VERSION_LESS_THAN(@"8.0")) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        screenHeight = screenSize.width;
    }
    
    CGFloat maxHeight = screenHeight - self.titleLabel.intrinsicContentSize.height - (self.alertStyler.sectionVerticalMargin.floatValue * self.sectionCount) - buttonHeight - kURBNAlertViewHeightPadding;
    
    if (!self.messageTextView.urbn_heightLayoutConstraint) {
        [self.messageTextView urbn_addHeightLayoutConstraintWithConstant:0];
    }
    
    if (self.messageTextView.text.length > 0) {
        if (self.messageTextView.contentSize.height > maxHeight) {
            self.messageTextView.urbn_heightLayoutConstraint.constant = maxHeight;
        }
        else {
            self.messageTextView.urbn_heightLayoutConstraint.constant = self.messageTextView.contentSize.height;
        }
    }
    // code above needs to be called before super. Crashes on iOS 7 if called after
    
    [super layoutSubviews];
    
    self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.frame.size.width;
    
    self.layer.shadowColor = self.alertStyler.alertViewShadowColor.CGColor;
    self.layer.shadowOffset = self.alertStyler.alertShadowOffset;
    self.layer.shadowOpacity = self.alertStyler.alertViewShadowOpacity.floatValue;
    self.layer.shadowRadius = self.alertStyler.alertViewShadowRadius.floatValue;
    [self.layer setActions:@{@"shadowPath" : [NSNull null]}];
}

#pragma mark - Getters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = self.alertStyler.titleAlignment;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.font = self.alertStyler.titleFont;
        _titleLabel.textColor = self.alertStyler.titleColor;
        _titleLabel.text = self.alertConfig.title;
    }
    
    return _titleLabel;
}

- (UITextView *)messageTextView {
    if (!_messageTextView) {
        _messageTextView = [UITextView new];
        _messageTextView.backgroundColor = [UIColor clearColor];
        _messageTextView.font = self.alertStyler.messageFont;
        _messageTextView.textColor = self.alertStyler.messageColor;
        _messageTextView.text = self.alertConfig.message;
        _messageTextView.textAlignment = self.alertStyler.messageAlignment;
        _messageTextView.scrollEnabled = YES;
        _messageTextView.editable = NO;
        [_messageTextView setContentInset:UIEdgeInsetsZero];
        [_messageTextView scrollRangeToVisible:NSMakeRange(0, 0)];
    }
    
    return _messageTextView;
}

- (UILabel *)errorLabel {
    if (!_errorLabel) {
        _errorLabel = [UILabel new];
        _errorLabel.numberOfLines = 0;
        _errorLabel.font = self.alertStyler.errorTextFont;
        _errorLabel.textColor = self.alertStyler.errorTextColor;
        _errorLabel.alpha = 0;
    }
    
    return _errorLabel;
}

#pragma mark - Methods
- (URBNAlertActionButton *)createAlertViewButtonWithAction:(URBNAlertAction *)action atIndex:(NSInteger)index {
    UIColor *bgColor = self.alertStyler.buttonBackgroundColor;
    UIColor *titleColor = self.alertStyler.buttonTitleColor;
    
    if (action.actionType == URBNAlertActionTypeDestructive) {
        titleColor = self.alertStyler.destructiveButtonTitleColor;
        bgColor = self.alertStyler.destructionButtonBackgroundColor;
    }
    else if (action.actionType == URBNAlertActionTypeCancel) {
        titleColor = self.alertStyler.cancelButtonTitleColor;
        bgColor = self.alertStyler.cancelButtonBackgroundColor;
    }
    
    URBNAlertActionButton *btn = [URBNAlertActionButton buttonWithType:UIButtonTypeCustom];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    btn.backgroundColor = bgColor;
    btn.titleLabel.font = self.alertStyler.buttonFont;
    btn.layer.cornerRadius = self.alertStyler.buttonCornerRadius.floatValue;
    btn.tag = index;
    btn.actionType = action.actionType;
    
    [btn setTitle:action.title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)setErrorLabelText:(NSString *)errorText {
    [UIView animateWithDuration:0.2 animations:^{
        self.errorLabel.text = errorText;
        self.errorLabel.alpha = 1;
    }];
}

- (void)setLoadingState:(BOOL)newState forTextFieldAtIndex:(NSUInteger)index {
    if (index < self.alertConfig.inputs.count) {
        UITextField *textField = [self.alertConfig.inputs objectAtIndex:index];
        
        if (newState) {
            // Disable buttons, show loading
            [self setButtonsEnabled:NO];
            
            [textField urbn_showLoading:YES animated:YES spinnerInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
        }
        else {
            [self setButtonsEnabled:YES];
            
            if (textField) {
                [textField urbn_showLoading:NO animated:YES];
            }
        }
    }
}

- (void)setButtonsEnabled:(BOOL)enabled {
    for (URBNAlertActionButton *btn in self.buttons) {
        if (btn.actionType != URBNAlertActionTypeCancel) {
            btn.enabled = enabled;
            btn.alpha = enabled ? 1.f : 0.5f;
        }
    }
}

#pragma mark - Actions
- (void)buttonTouch:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    if (self.buttonTouchedBlock) {
        self.buttonTouchedBlock([self.alertConfig.actions objectAtIndex:btn.tag]);
    }
}

- (void)passiveAlertViewTouched {
    if (self.alertViewTouchedBlock) {
        self.alertViewTouchedBlock(self.alertConfig.actions.firstObject);
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug
    if(range.length + range.location > textField.text.length) {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    return (newLength > self.alertStyler.textFieldMaxLength.integerValue) ? NO : YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return NO;
}

@end
