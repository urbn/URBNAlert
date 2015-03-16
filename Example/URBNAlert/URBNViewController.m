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
    URBNAlertStyle *style = [URBNAlertStyle new];
    style.buttonBackgroundColor = [UIColor blueColor];
    style.buttonDenialBackgroundColor = [UIColor greenColor];
    [self.alertController setAlertStyler:style];
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
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"The Title of my message can be up to 2 lines long. It wraps and centers." message:@"And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text."];
    
    [uac addAction:[URBNAlertAction buttonWithTitle:@"Done" actionType:URBNAlertActionTypeNormal buttonTouched:^(URBNAlertAction *action) {
        [uac dismiss];
    }]];
    
    [uac show];
}

- (IBAction)activeAlertTwoButtonTouch:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"The Title" message:@"And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text."];
    [uac addAction:[URBNAlertAction buttonWithTitle:@"#1" actionType:URBNAlertActionTypeNormal buttonTouched:^(URBNAlertAction *action) {
        [uac dismiss];
    }]];
    
    [uac addAction:[URBNAlertAction buttonWithTitle:@"Button Two" actionType:URBNAlertActionTypeDestructive buttonTouched:^(URBNAlertAction *action) {
        [uac dismiss];
    }]];
    
    [uac addAction:[URBNAlertAction buttonWithTitle:@"Button Two" actionType:URBNAlertActionTypeDestructive buttonTouched:^(URBNAlertAction *action) {
        [uac dismiss];
    }]];
    
    [uac show];
}

- (IBAction)activeAlertColoredTouch:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"Custom Styled Alert" message:@"You can change the fonts, colors, button size, corner radius, and much more."];
    uac.alertStyler.buttonBackgroundColor = [UIColor yellowColor];
    uac.alertStyler.buttonDenialBackgroundColor = [UIColor purpleColor];
    uac.alertStyler.backgroundColor = [UIColor orangeColor];
    uac.alertStyler.buttonTitleColor = [UIColor blackColor];
    uac.alertStyler.titleColor = [UIColor purpleColor];
    uac.alertStyler.titleFont = [UIFont fontWithName:@"Chalkduster" size:30];
    uac.alertStyler.messageColor = [UIColor blackColor];
    uac.alertStyler.buttonCornerRadius = @0;
    uac.alertStyler.alertCornerRadius = @20;
    uac.alertStyler.buttonHeight = @30;
    uac.alertStyler.animationDuration = @0.2f;
    uac.alertStyler.alertShadowOffset = CGSizeMake(6, 6);
    uac.alertStyler.alertViewShadowColor = [UIColor greenColor];
    uac.alertStyler.blurTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    [uac addAction:[URBNAlertAction buttonWithTitle:@"Close" actionType:URBNAlertActionTypeDestructive buttonTouched:^(URBNAlertAction *action) {
        [uac dismiss];
    }]];
    
    [uac show];
}

- (IBAction)activeAlertCustomViewTouch:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:nil message:nil view:self.customView];
    
    [uac addAction:[URBNAlertAction buttonWithTitle:@"Done" actionType:URBNAlertActionTypeNormal buttonTouched:^(URBNAlertAction *action) {
        [uac dismiss];
    }]];
    
    [uac show];
}

- (IBAction)activeAlertMultipleAlertsTouch:(id)sender {
    [self activeAlertTouch:nil];
    [self activeAlertTouch:nil];
    [self activeAlertTouch:nil];

    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"The Title" message:@"And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text."];
    [uac addAction:[URBNAlertAction buttonWithTitle:@"Done" actionType:URBNAlertActionTypeNormal buttonTouched:^(URBNAlertAction *action) {
        [uac dismiss];
    }]];
    
    [uac addAction:[URBNAlertAction buttonWithTitle:@"Start Over" actionType:URBNAlertActionTypeDestructive buttonTouched:^(URBNAlertAction *action) {
        [uac dismiss];
        [self activeAlertMultipleAlertsTouch:nil];
    }]];
    
    [uac show];
}

- (IBAction)activeAlertInputTouch:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"Input Alert" message:@"Message and message and message and going on forever and ever. Message and message and message and going on forever and ever. Message and message and message and going on forever and ever. Message and message and message and going on forever and ever. and message and message and going on forever and ever." view:nil];
    
    [uac addAction:[URBNAlertAction buttonWithTitle:@"Done" actionType:URBNAlertActionTypeNormal buttonTouched:^(URBNAlertAction *action) {
        [uac dismiss];
        NSLog(@"input: %@", uac.textField.text);
    }]];
    
    [uac addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = @"e-mail";
        textField.returnKeyType = UIReturnKeyDone;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }];
    
    [uac show];
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
