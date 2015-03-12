//
//  URBNViewController.m
//  URBNAlert
//
//  Created by Ryan Garchinsky on 03/04/2015.
//  Copyright (c) 2014 Ryan Garchinsky. All rights reserved.
//

#import "URBNViewController.h"
#import <URBNAlert/URBNAlertController.h>
#import <URBNAlert/URBNAlertViewController.h>
#import <URBNConvenience/UIView+URBNLayout.h>
#import <URBNAlert/URBNAlertStyle.h>
#import <URBNAlert/URBNAlertAction.h>

@interface URBNViewController ()

@property (nonatomic, strong) URBNAlertController *alertController;
@property (nonatomic, strong) UIView *customView;

@end

@implementation URBNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.alertController = [URBNAlertController sharedInstance];
}

#pragma mark - Getters
- (UIView *)customView {
    if (!_customView) {
        _customView = [[UIView alloc] init];
        _customView.translatesAutoresizingMaskIntoConstraints = NO;
        _customView.backgroundColor = [UIColor greenColor];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beagle"]];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.translatesAutoresizingMaskIntoConstraints = NO;
        imgView.backgroundColor = [UIColor redColor];
        [_customView addSubview:imgView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(imgView);
        [_customView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[imgView]-|" options:0 metrics:nil views:views]];
        [_customView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[imgView]-|" options:0 metrics:nil views:views]];
    }
    
    return _customView;
}

#pragma mark - Active Alert Touches
- (IBAction)activeAlertTouch:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"The Title" message:@"And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text." view:nil];
    
    [uac addAction:[URBNAlertAction buttonWithTitle:@"Testing" actionType:URBNAlertActionTypeNormal buttonTouched:^{
        NSLog(@"testing");
    }]];
    
    [uac addAction:[URBNAlertAction buttonWithTitle:@"Button Two" actionType:URBNAlertActionTypeDestructive buttonTouched:^{
        NSLog(@"btn2");
    }]];
    
    [uac show];
//    [self.alertController setAlertStyler:nil];
//    
//    [self.alertController showActiveAlertWithTitle:@"My Alert Title that could be 2 lines but no more than 2" message:@"Message and message and message and going on forever and ever. You can also touch outside to dismiss this alert." hasInput:NO buttonTitles:@[@"Yes"] touchOutsideToDismiss:YES buttonTouchedBlock:^(URBNAlertController *alertController, NSInteger index) {
//        [alertController dismissAlert];
//    }];
}

- (IBAction)activeAlertTwoButtonTouch:(id)sender {
    [self.alertController setAlertStyler:nil];
    
    [self.alertController showActiveAlertWithTitle:@"My Alert Title that could be 2 lines but no more than 2" message:@"Message and message and message and going on forever and ever." hasInput:NO buttonTitles:@[@"Yes", @"No"] touchOutsideToDismiss:NO buttonTouchedBlock:^(URBNAlertController *alertController, NSInteger index) {
        [alertController dismissAlert];
    }];
}

- (IBAction)activeAlertColoredTouch:(id)sender {
    URBNAlertStyle *alertStyle = [URBNAlertStyle new];
    alertStyle.buttonBackgroundColor = [UIColor yellowColor];
    alertStyle.buttonDenialBackgroundColor = [UIColor greenColor];
    alertStyle.backgroundColor = [UIColor orangeColor];
    alertStyle.buttonTitleColor = [UIColor blackColor];
    alertStyle.titleColor = [UIColor purpleColor];
    alertStyle.messageColor = [UIColor blackColor];
    alertStyle.buttonCornerRadius = @0;
    alertStyle.alertCornerRadius = @20;
    alertStyle.buttonHeight = @30;
    alertStyle.animationDuration = @0.2f;
    alertStyle.alertShadowOffset = CGSizeMake(6, 6);
    alertStyle.alertViewShadowColor = [UIColor greenColor];
    alertStyle.blurTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.alertController setAlertStyler:alertStyle];
    
    [self.alertController showActiveAlertWithTitle:@"Customized Alert" message:@"You can change the fonts, colors, button size, corner radius, and much more." hasInput:NO buttonTitles:@[@"Yes", @"No"] touchOutsideToDismiss:NO buttonTouchedBlock:^(URBNAlertController *alertController, NSInteger index) {
        [alertController dismissAlert];
    }];
}

- (IBAction)activeAlertCustomViewTouch:(id)sender {
    [self.alertController setAlertStyler:nil];
    
    [self.alertController showActiveAlertWithView:self.customView buttonTitles:@[@"Dismiss"] touchOutsideToDismiss:YES buttonTouchedBlock:^(URBNAlertController *alertController, NSInteger index) {
        [alertController dismissAlert];
    }];
}

- (IBAction)activeAlertMultipleAlertsTouch:(id)sender {
    [self.alertController setAlertStyler:nil];

    [self.alertController showActiveAlertWithTitle:@"The First Alert" message:@"Message and message and message and going on forever and ever." hasInput:NO buttonTitles:@[@"Next"] touchOutsideToDismiss:NO buttonTouchedBlock:^(URBNAlertController *alertController, NSInteger index) {
        [alertController dismissAlert];
    }];
    
    [self.alertController showActiveAlertWithTitle:@"#2" message:@"Message and message and message and going on forever and ever." hasInput:NO buttonTitles:@[@"Next"] touchOutsideToDismiss:NO buttonTouchedBlock:^(URBNAlertController *alertController, NSInteger index) {
        [alertController dismissAlert];
    }];
    
    __weak typeof(self) weakSelf = self;
    [self.alertController showActiveAlertWithTitle:@"#3" message:@"The third and final alert" hasInput:NO buttonTitles:@[@"Done", @"Do it again!"] touchOutsideToDismiss:NO buttonTouchedBlock:^(URBNAlertController *alertController, NSInteger index) {
        switch (index) {
            case 1:
                [weakSelf activeAlertMultipleAlertsTouch:nil];
            default:
                [alertController dismissAlert];
                break;
        }
    }];
}

- (IBAction)activeAlertInputTouch:(id)sender {
    URBNAlertStyle *alertStyle = [URBNAlertStyle new];
    alertStyle.inputReturnKeyType = UIReturnKeyDone;
    alertStyle.inputKeyboardType = UIKeyboardTypeEmailAddress;
    [self.alertController setAlertStyler:alertStyle];
    
    [self.alertController showActiveAlertWithTitle:@"My Alert Title that could be 2 lines but no more than 2" message:@"Message and message and message and going on forever and ever. Message and message and message and going on forever and ever. Message and message and message and going on forever and ever. Message and message and message and going on forever and ever. and message and message and going on forever and ever." hasInput:YES buttonTitles:@[@"Yes"] touchOutsideToDismiss:NO buttonTouchedBlock:^(URBNAlertController *alertController, NSInteger index) {
        [alertController dismissAlert];
    }];
}

#pragma mark - Passive Alert Touches
- (IBAction)passiveAlertSimpleTouch:(id)sender {
    [self.alertController setAlertStyler:nil];

    [self.alertController showPassiveAlertWithTitle:@"Passive alerts!" message:@"Hopefully you can read all of this text before the alert dismisses. If no duration is supplied than it is calculated based on the number of words in the message & title. If you are an extremely slow reader.. sorry bro.\n\nThe 2nd paragraph starts here for this passive alert with a long message. It keeps on going and going. You can always touch outside the alert, or on the alert to dismiss." touchOutsideToDismiss:YES alertDismissedBlock:^(URBNAlertController *alertController, BOOL alertWasTouched) {
        [alertController dismissAlert];
    }];
}

- (IBAction)passiveAlertsSimleTouchShort:(id)sender {
    [self.alertController setAlertStyler:nil];
    
    [self.alertController showPassiveAlertWithTitle:@"Passive alerts!" message:@"Very short alert. Minimum 2 second duration." touchOutsideToDismiss:NO alertDismissedBlock:nil];
}

- (IBAction)passiveAlertCustomViewTouch:(id)sender {
    URBNAlertStyle *alertStyle = [URBNAlertStyle new];
    alertStyle.customViewMargin = @0;
    [self.alertController setAlertStyler:alertStyle];

    [self.alertController showPassiveAlertWithView:self.customView touchOutsideToDismiss:YES duration:2.f alertDismissedBlock:^(URBNAlertController *alertController, BOOL alertWasTouched) {
        [alertController dismissAlert];
    }];
}

- (IBAction)passiveAlertQueuedTouched:(id)sender {
    [self.alertController setAlertStyler:nil];

    [self.alertController showPassiveAlertWithTitle:@"#1" message:@"Hopefully you can read all of this text before the alert dismisses. If no duration is supplied than it is calculated based on the number of words in the message & title. If you are an extremely slow reader.. sorry bro.\n\nThe 2nd paragraph starts here for this passive alert with a long message. It keeps on going and going. You can always touch outside the alert, or on the alert to dismiss." touchOutsideToDismiss:YES alertDismissedBlock:^(URBNAlertController *alertController, BOOL alertWasTouched) {
        [alertController dismissAlert];
    }];
    
    [self.alertController showPassiveAlertWithTitle:@"#2" message:@"Very short alert. Minimum 2 second duration." touchOutsideToDismiss:NO alertDismissedBlock:nil];

    [self.alertController showPassiveAlertWithView:self.customView touchOutsideToDismiss:YES duration:2.f alertDismissedBlock:^(URBNAlertController *alertController, BOOL alertWasTouched) {
        [alertController dismissAlert];
    }];
}

@end
