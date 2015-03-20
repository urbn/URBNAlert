//
//  URBNViewController.m
//  URBNAlert
//
//  Created by Ryan Garchinsky on 03/04/2015.
//  Copyright (c) 2014 Ryan Garchinsky. All rights reserved.
//

#import "URBNViewController.h"
#import <URBNAlert/URBNAlert.h>

@interface URBNViewController ()

@property (nonatomic, strong) URBNAlertController *alertController;
@property (nonatomic, strong) UIView *customView;

@end

@implementation URBNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set global stlying. This can be done sometime during app launch. You can change style options per alert as well.
    self.alertController = [URBNAlertController sharedInstance];
    self.alertController.alertStyler.buttonBackgroundColor = [UIColor blueColor];
    self.alertController.alertStyler.buttonDestructionBackgroundColor = [UIColor greenColor];
}




#pragma mark - Active Alert Touches
- (IBAction)activeAlertTouch:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"The Title of my message can be up to 2 lines long. It wraps and centers." message:@"And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text."];
    
    [uac addAction:[URBNAlertAction actionWithTitle:@"Done" actionType:URBNAlertActionTypeNormal actionCompleted:^(URBNAlertAction *action) {
          // Do something
    }]];
    
    [uac show];
}




- (IBAction)activeAlertTwoButtonTouch:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"The Title" message:@"And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text."];
    [uac addAction:[URBNAlertAction actionWithTitle:@"#1" actionType:URBNAlertActionTypeNormal actionCompleted:^(URBNAlertAction *action) {
           // Do something
    }]];
    
    [uac addAction:[URBNAlertAction actionWithTitle:@"Button Two" actionType:URBNAlertActionTypeDestructive actionCompleted:^(URBNAlertAction *action) {
          // Do something
    }]];
    
    [uac show];
}




- (IBAction)activeAlertColoredTouch:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"Custom Styled Alert" message:@"You can change the fonts, colors, button size, corner radius, and much more."];
    uac.alertStyler.buttonBackgroundColor = [UIColor yellowColor];
    uac.alertStyler.buttonDestructionBackgroundColor = [UIColor purpleColor];
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
    
    [uac addAction:[URBNAlertAction actionWithTitle:@"Close" actionType:URBNAlertActionTypeDestructive actionCompleted:^(URBNAlertAction *action) {
        // Do something
    }]];
    
    [uac show];
}




- (IBAction)activeAlertCustomViewTouch:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"Custom View" message:nil view:self.customView];
    
    [uac addAction:[URBNAlertAction actionWithTitle:@"Done" actionType:URBNAlertActionTypeNormal actionCompleted:^(URBNAlertAction *action) {
        // Do something
    }]];
    
    [uac show];
}




- (IBAction)activeAlertMultipleAlertsTouch:(id)sender {
    [self activeAlertTouch:nil];
    [self activeAlertCustomViewTouch:nil];
    [self activeAlertTouch:nil];

    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"The Title" message:@"And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text."];
    [uac addAction:[URBNAlertAction actionWithTitle:@"Done" actionType:URBNAlertActionTypeNormal actionCompleted:^(URBNAlertAction *action) {
        // Do something
    }]];
    
    [uac addAction:[URBNAlertAction actionWithTitle:@"Start Over" actionType:URBNAlertActionTypeDestructive actionCompleted:^(URBNAlertAction *action) {

        [self activeAlertMultipleAlertsTouch:nil];
    }]];
    
    [uac show];
}




- (IBAction)activeAlertInputTouch:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"Input Alert" message:@"Message and message and message and going on forever and ever. Message and message and message and going on forever and ever. Message and message and message and going on forever and ever. Message and message and message and going on forever and ever. and message and message and going on forever and ever." view:nil];
    
    [uac addAction:[URBNAlertAction actionWithTitle:@"Done" actionType:URBNAlertActionTypeNormal actionCompleted:^(URBNAlertAction *action) {
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
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"The Title of my message can be up to 2 lines long. It wraps and centers." message:@"And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text."];
    uac.alertConfig.touchOutsideViewToDismiss = YES;
    
    [uac addAction:[URBNAlertAction actionWithTitle:nil actionType:URBNAlertActionTypePassive actionCompleted:^(URBNAlertAction *action) {
        // Do something
    }]];
    
    [uac show];
}




- (IBAction)passiveAlertsSimpleTouchShort:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"Passive alerts!" message:@"Very short alert. Minimum 2 second duration."];
    uac.alertConfig.duration = 2.0f;
    [uac show];
}




- (IBAction)passiveAlertCustomViewTouch:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:nil message:nil view:self.customView];
    uac.alertConfig.duration = 5.0f;
    uac.alertConfig.touchOutsideViewToDismiss = YES;
    
    [uac addAction:[URBNAlertAction actionWithTitle:nil actionType:URBNAlertActionTypePassive actionCompleted:^(URBNAlertAction *action) {
        // Do something
    }]];
    
    [uac show];
}



- (IBAction)passiveAlertQueuedTouched:(id)sender {
    [self passiveAlertSimpleTouch:nil];
    [self passiveAlertCustomViewTouch:nil];
    [self passiveAlertsSimpleTouchShort:nil];
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

@end
