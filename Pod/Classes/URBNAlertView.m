//
//  URBNAlertView.m
//  URBNAlertTest
//
//  Created by Ryan Garchinsky on 3/3/15.
//  Copyright (c) 2015 URBN. All rights reserved.
//

#import "URBNAlertView.h"
#import "URBNAlertController.h"

@interface URBNAlertView()

@property (nonatomic, strong) URBNAlertController *alertController;
@property (nonatomic, strong) NSArray *buttons;

@end

@implementation URBNAlertView

- (instancetype)initWithAlertController:(URBNAlertController *)controller {
    self = [super init];
    if (self) {
        self.alertController = controller;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        
        self.titleLabel = [UILabel new];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.font = self.alertController.titleFont ?: [UIFont boldSystemFontOfSize:14];
        self.titleLabel.text = self.alertController.title;
        
        self.messageLabel = [UILabel new];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.font = self.alertController.messageFont ?: [UIFont systemFontOfSize:12];
        self.messageLabel.text = self.alertController.message;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.messageLabel];
        
        // Add some buttons
        NSMutableArray *btns = [NSMutableArray new];
        UIView *buttonContainer = [UIView new];
        buttonContainer.translatesAutoresizingMaskIntoConstraints = NO;
        
        __weak typeof(self) weakSelf = self;
        [self.alertController.buttonTitles enumerateObjectsUsingBlock:^(NSString *buttonTitle, NSUInteger idx, BOOL *stop) {
            UIColor *bgColor = weakSelf.alertController.buttonBackgroundColor ?: [UIColor lightGrayColor];
            UIColor *bgDenialColor = weakSelf.alertController.buttonDenialBackgroundColor ?: [UIColor blueColor];
            UIColor *titleColor = weakSelf.alertController.buttonTitleColor ?: [UIColor whiteColor];

            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.translatesAutoresizingMaskIntoConstraints = NO;
            btn.backgroundColor = (idx == 0 && weakSelf.alertController.buttonTitles.count > 1) ? bgColor : bgDenialColor;
            btn.titleLabel.font = weakSelf.alertController.buttonFont ?: [UIFont boldSystemFontOfSize:14];
            btn.layer.cornerRadius = 4;
            btn.tag = idx ?: 0;

            [btn setTitle:buttonTitle forState:UIControlStateNormal];
            [btn setTitleColor:titleColor forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            [buttonContainer addSubview:btn];
            [btns addObject:btn];
        }];

        [self addSubview:buttonContainer];
        
        NSDictionary *metrics = @{@"sectionMargin" : @24, @"btnH" : @44, @"lblMargin" : @16, @"btnMargin" : @8};
        NSDictionary *views = NSDictionaryOfVariableBindings(_titleLabel, _messageLabel, buttonContainer);
        
        self.buttonsArray = [btns copy];
        if (self.buttonsArray.count == 1) {
            [buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[btnOne]|" options:0 metrics:metrics views:@{@"btnOne" : self.buttonsArray.firstObject}]];
            [buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btnOne(btnH)]|" options:0 metrics:metrics views:@{@"btnOne" : self.buttonsArray.firstObject}]];
        }
        else if (self.buttonsArray.count == 2) {
            [buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[btnOne]-[btnTwo(==btnOne)]|" options:0 metrics:nil views:@{@"btnOne" : self.buttonsArray.firstObject, @"btnTwo" : self.buttonsArray[1]}]];
            [buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btnOne(btnH)]|" options:0 metrics:metrics views:@{@"btnOne" : self.buttonsArray.firstObject}]];
            [buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btnTwo(btnH)]|" options:0 metrics:metrics views:@{@"btnTwo" : self.buttonsArray[1]}]];
        }
        
        for (UILabel *lbl in @[self.titleLabel, self.messageLabel]) {
            lbl.translatesAutoresizingMaskIntoConstraints = NO;
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-lblMargin-[lbl]-lblMargin-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(lbl)]];
        }
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-btnMargin-[buttonContainer]-btnMargin-|" options:0 metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_titleLabel]-sectionMargin-[_messageLabel]-sectionMargin-[buttonContainer]-btnMargin-|" options:0 metrics:metrics views:views]];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.messageLabel.preferredMaxLayoutWidth = self.messageLabel.frame.size.width;
    self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.frame.size.width;
}

#pragma mark - Actions
- (void)buttonTouch:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.buttonTouchedBlock) {
        self.buttonTouchedBlock(btn.tag);
    }
}

@end
