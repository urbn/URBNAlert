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

@interface URBNAlertView()

@property (nonatomic, strong) URBNAlertConfig *alertConfig;
@property (nonatomic, strong) URBNAlertStyle *alertStyler;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, copy) NSArray *buttons;

@end

@implementation URBNAlertView 

- (instancetype)initWithAlertConfig:(URBNAlertConfig *)config alertStyler:(URBNAlertStyle *)alertStyler customView:(UIView *)customView textField:(UITextField *)textField {
    self = [super init];
    if (self) {
        self.alertConfig = config;
        self.alertStyler = alertStyler;
        self.textField = textField;
        
        if (!customView) {
            UIView *dummyView = [UIView new];
            dummyView.translatesAutoresizingMaskIntoConstraints = NO;
            self.customView = dummyView;
        }
        else {
            self.customView = customView;
        }
        
        self.backgroundColor = self.alertStyler.backgroundColor ?: [UIColor whiteColor];
        self.layer.cornerRadius = self.alertStyler.alertCornerRadius.floatValue;
    
        UIView *buttonContainer = [UIView new];
        NSDictionary *views;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.messageLabel];
        [self addSubview:self.customView];
        
        if (self.textField) {
            self.textField.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:self.textField];
            views = NSDictionaryOfVariableBindings(_customView, _titleLabel, _messageLabel, buttonContainer, _textField);
        }
        else {
            views = NSDictionaryOfVariableBindings(_customView, _titleLabel, _messageLabel, buttonContainer);
        }
        
        // Add some buttons
        NSMutableArray *btns = [NSMutableArray new];
        buttonContainer.translatesAutoresizingMaskIntoConstraints = NO;
        
        __weak typeof(self) weakSelf = self;
        [self.alertConfig.actions enumerateObjectsUsingBlock:^(URBNAlertAction *action, NSUInteger idx, BOOL *stop) {
            if (action.isButton) {
                UIButton *btn = [weakSelf createAlertViewButtonWithAction:action atIndex:idx];
                [buttonContainer addSubview:btn];
                [btns addObject:btn];
            }
        }];

        [self addSubview:buttonContainer];
        
        // Handle if no title or messages, give 0 margins
        NSNumber *titleMargin = self.alertConfig.title.length > 0 ? self.alertStyler.sectionVerticalMargin : @0;
        NSNumber *msgMargin = self.alertConfig.message.length > 0 ? self.alertStyler.sectionVerticalMargin : @0;

        NSDictionary *metrics = @{@"sectionMargin" : self.alertStyler.sectionVerticalMargin,
                                           @"btnH" : self.alertStyler.buttonHeight,
                                     @"lblHMargin" : self.alertStyler.labelHorizontalMargin,
                                   @"titleVMargin" : titleMargin,
                                     @"msgVMargin" : msgMargin,
                                      @"btnMargin" : self.alertStyler.buttonHorizontalMargin,
                                       @"cvMargin" : self.alertStyler.customViewMargin};
        
        for (UILabel *lbl in @[self.titleLabel, self.messageLabel]) {
            lbl.translatesAutoresizingMaskIntoConstraints = NO;
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-lblHMargin-[lbl]-lblHMargin-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(lbl)]];
        }
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-cvMargin-[_customView]-cvMargin-|" options:0 metrics:metrics views:views]];

        if (!self.textField) {
            if (self.alertConfig.isActiveAlert) {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-titleVMargin-[_titleLabel]-msgVMargin-[_messageLabel]-cvMargin-[_customView]-cvMargin-[buttonContainer]-btnMargin-|" options:0 metrics:metrics views:views]];
            }
            // Passive alert, dont added margins for buttonContainer
            else {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-titleVMargin-[_titleLabel]-msgVMargin-[_messageLabel]-cvMargin-[_customView]-cvMargin-|" options:0 metrics:metrics views:views]];
            }
        }
        else {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-lblHMargin-[_textField]-lblHMargin-|" options:0 metrics:metrics views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-titleVMargin-[_titleLabel]-msgVMargin-[_messageLabel]-cvMargin-[_customView]-cvMargin-[_textField]-btnMargin-[buttonContainer]-btnMargin-|" options:0 metrics:metrics views:views]];
        }
        
        // Button Constraints
        self.buttons = [btns copy];
        if (self.buttons.count == 1) {
            [buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[btnOne]|" options:0 metrics:metrics views:@{@"btnOne" : self.buttons.firstObject}]];
            [buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btnOne(btnH)]|" options:0 metrics:metrics views:@{@"btnOne" : self.buttons.firstObject}]];
        }
        else if (self.buttons.count == 2) {
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
    [super layoutSubviews];
    
    self.messageLabel.preferredMaxLayoutWidth = self.messageLabel.frame.size.width;
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
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.font = self.alertStyler.titleFont;
        _titleLabel.textColor = self.alertStyler.titleColor;
        _titleLabel.text = self.alertConfig.title;
    }
    
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = self.alertStyler.messageFont;
        _messageLabel.textColor = self.alertStyler.messageColor;
        _messageLabel.text = self.alertConfig.message;
    }
    
    return _messageLabel;
}

#pragma mark - Methods
- (UIButton *)createAlertViewButtonWithAction:(URBNAlertAction *)action atIndex:(NSInteger)index {
    UIColor *bgColor = self.alertStyler.buttonBackgroundColor;
    UIColor *bgDestructiveColor = self.alertStyler.buttonDestructionBackgroundColor;
    UIColor *titleColor = self.alertStyler.buttonTitleColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    btn.backgroundColor = (action.actionType == URBNAlertActionTypeDestructive) ? bgDestructiveColor : bgColor;
    btn.titleLabel.font = self.alertStyler.buttonFont;
    btn.layer.cornerRadius = self.alertStyler.buttonCornerRadius.floatValue;
    btn.tag = index;
    
    [btn setTitle:action.title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
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
