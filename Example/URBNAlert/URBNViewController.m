//
//  URBNViewController.m
//  URBNAlert
//
//  Created by Ryan Garchinsky on 03/04/2015.
//  Copyright (c) 2014 Ryan Garchinsky. All rights reserved.
//

#import "URBNViewController.h"
#import <URBNAlert/URBNAlert.h>

@interface CustomView : UIView

@property (nonatomic, strong) UITextField *customTextField;

@end

@implementation CustomView

@end

@interface URBNViewController ()

@property (nonatomic, strong) URBNAlertController *alertController;
@property (nonatomic, strong) CustomView *customView;
@property (nonatomic, strong) IBOutlet UIView *bottomView;
@property (nonatomic, assign) BOOL isModal;
@property (strong, nonatomic) IBOutlet UIButton *modalButton;

@end

@implementation URBNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Set global stlying. This can be done sometime during app launch. You can change style options per alert as well.
    self.alertController = [URBNAlertController sharedInstance];
    self.alertController.alertStyler.buttonBackgroundColor = [UIColor blueColor];
    self.alertController.alertStyler.cancelButtonTitleColor = [UIColor redColor];
    
    self.navigationItem.title = @"URBNAlert";
    
    if (self.isModal) {
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeTouch)]];
        [self.modalButton setHidden:YES];
    }
}




#pragma mark - Active Alert Touches
- (IBAction)activeAlertTouch:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"The Title of my message can be up to 2 lines long. It wraps and centers." message:@"And the message that is a bunch of text that will turn scrollable once the text view runs out of space.\nAnd the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  "];
    uac.alertStyler.blurTintColor = [[UIColor orangeColor] colorWithAlphaComponent:0.4];
    uac.alertStyler.messageAlignment = NSTextAlignmentCenter;
    [uac addAction:[URBNAlertAction actionWithTitle:@"Done" actionType:URBNAlertActionTypeNormal actionCompleted:^(URBNAlertAction *action) {
        // Do something
    }]];
    [uac show];
}




- (IBAction)activeAlertTwoButtonTouch:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"The Title" message:@"And the message that is a bunch of text. And the message that is a bunch of text.\n\n And the message that is a bunch of text."];
    uac.alertStyler.buttonShadowColor = [UIColor purpleColor];
    uac.alertStyler.buttonShadowOpacity = @1;
    uac.alertStyler.buttonShadowRadius = @2;
    uac.alertStyler.buttonShadowOffset = CGSizeMake(2.0, 2.0);
    
    [uac addAction:[URBNAlertAction actionWithTitle:@"Submit" actionType:URBNAlertActionTypeNormal dismissOnActionComplete:NO actionCompleted:^(URBNAlertAction *action) {
        // Alternate way to dismiss the currently active alert
        [[URBNAlertController sharedInstance] dismissAlert];
    }]];
    
    [uac addAction:[URBNAlertAction actionWithTitle:@"Button Two" actionType:URBNAlertActionTypeDestructive actionCompleted:^(URBNAlertAction *action) {
        // Do something
    }]];
    
    [uac show];
}




- (IBAction)activeAlertColoredTouch:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"Custom Styled Alert" message:@"You can change the fonts, colors, button size, corner radius, and much more."];
    uac.alertStyler.buttonBackgroundColor = [UIColor greenColor];
    uac.alertStyler.cancelButtonTitleColor = [UIColor redColor];
    uac.alertStyler.cancelButtonTitleColor = [UIColor whiteColor];
    uac.alertStyler.backgroundColor = [UIColor orangeColor];
    uac.alertStyler.buttonTitleColor = [UIColor blackColor];
    uac.alertStyler.titleColor = [UIColor purpleColor];
    uac.alertStyler.titleFont = [UIFont fontWithName:@"Chalkduster" size:30];
    uac.alertStyler.messageColor = [UIColor blackColor];
    uac.alertStyler.buttonCornerRadius = @2;
    uac.alertStyler.alertCornerRadius = @2;
    uac.alertStyler.buttonHeight = @30;
    uac.alertStyler.animationDuration = @0.5f;
    uac.alertStyler.animationDamping = @0.9f;
    uac.alertStyler.alertShadowOffset = CGSizeMake(6, 6);
    uac.alertStyler.alertViewShadowColor = [UIColor greenColor];
    uac.alertStyler.blurTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    uac.alertStyler.messageAlignment = NSTextAlignmentRight;
    uac.alertStyler.buttonMarginEdgeInsets = UIEdgeInsetsMake(20, 5, 5, 5);
    uac.alertStyler.alertMinWidth = @150;
    uac.alertStyler.alertMaxWidth = @200;
    
    [uac addAction:[URBNAlertAction actionWithTitle:@"Cancel" actionType:URBNAlertActionTypeCancel actionCompleted:^(URBNAlertAction *action) {
        // Do something
    }]];
    
    [uac addAction:[URBNAlertAction actionWithTitle:@"Normal" actionType:URBNAlertActionTypeNormal actionCompleted:^(URBNAlertAction *action) {
        // Do something
    }]];
    
    [uac show];
}




- (IBAction)activeAlertCustomViewTouch:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"Custom View" message:nil view:self.customView];
    
    uac.alertStyler.firstResponder = self.customView.customTextField;
    
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
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"Input Alert" message:@"Enter some info bro:" view:nil];
    uac.alertStyler.textFieldEdgeInsets = UIEdgeInsetsMake(15.0, 15.0, 15.0, 15.0);
    
    [uac addAction:[URBNAlertAction actionWithTitle:@"Done" actionType:URBNAlertActionTypeNormal actionCompleted:^(URBNAlertAction *action) {
        NSLog(@"input 1: %@", uac.textField.text);
        NSLog(@"input 2: %@", [[uac textFieldAtIndex:1] text]);
        NSLog(@"input 3: %@", [[uac textFieldAtIndex:2] text]);
    }]];
    
    __weak typeof(uac) weakUac = uac;
    [uac addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.borderStyle = UITextBorderStyleLine;
        textField.placeholder = @"e-mail";
        textField.returnKeyType = UIReturnKeyDone;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }];
    
    [uac addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.borderStyle = UITextBorderStyleLine;
        textField.placeholder = @"password";
        textField.returnKeyType = UIReturnKeyDone;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }];
    
    [uac addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.borderStyle = UITextBorderStyleLine;
        textField.placeholder = @"confirm";
        textField.returnKeyType = UIReturnKeyDone;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        weakUac.alertStyler.firstResponder = textField;
    }];
    
    
    [uac show];
}


- (IBAction)activeAlertMultipleButtons:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"Multiple Buttons" message:@"When 3 or more buttons are added to the alert, they then align in a vertical layout."];
    
    uac.alertStyler.separatorHeight = @1;
    uac.alertStyler.separatorColor = [UIColor darkGrayColor];
    
    [uac addAction:[URBNAlertAction actionWithTitle:@"Submit" actionType:URBNAlertActionTypeNormal dismissOnActionComplete:NO actionCompleted:^(URBNAlertAction *action) {
        // Alternate way to dismiss the currently active alert
        [[URBNAlertController sharedInstance] dismissAlert];
    }]];
    
    [uac addAction:[URBNAlertAction actionWithTitle:@"Button Two" actionType:URBNAlertActionTypeDestructive actionCompleted:^(URBNAlertAction *action) {
        // Do something
    }]];
    
    [uac addAction:[URBNAlertAction actionWithTitle:@"Button Three" actionType:URBNAlertActionTypeCancel actionCompleted:^(URBNAlertAction *action) {
        // Do something
    }]];
    
    [uac addAction:[URBNAlertAction actionWithTitle:@"Button Four" actionType:URBNAlertActionTypeCancel actionCompleted:^(URBNAlertAction *action) {
        // Do something
    }]];
    
    [uac show];
}


- (IBAction)activeAlertValidateInput:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"Validated Input Alert" message:@"Input must be 5 characters long to pass."];
    uac.alertStyler.disabledButtonTitleColor = [UIColor orangeColor];
    uac.alertStyler.disabledButtonBackgroundColor = [UIColor blackColor];
    uac.alertStyler.disabledButtonAlpha = @1.f;
    uac.alertStyler.textFieldEdgeInsets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
    
    [uac addAction:[URBNAlertAction actionWithTitle:@"Cancel" actionType:URBNAlertActionTypeCancel actionCompleted:nil]];
    
    __weak typeof(uac) weakUac = uac;
    [uac addAction:[URBNAlertAction actionWithTitle:@"Submit" actionType:URBNAlertActionTypeNormal dismissOnActionComplete:NO actionCompleted:^(URBNAlertAction *action) {
        [weakUac startLoading];
        
        UITextField *textField = [weakUac textFieldAtIndex:0];
        if (textField.text.length != 5) {
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [weakUac stopLoading];
                [weakUac showInputError:@"Error! must enter 5 characters. You must now cancel.\nBTW This message can span multiple lines."];
                [action setEnabled:NO];
            });
        }
        else {
            [weakUac dismiss];
        }
    }]];
    
    [uac addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = @"must enter 5 characters";
        textField.returnKeyType = UIReturnKeyDone;
    }];
    
    [uac show];
}




#pragma mark - Passive Alert Touches
- (IBAction)passiveAlertSimpleTouch:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"The Title of my message can be up to 2 lines long. It wraps and centers." message:@"And the message that is a bunch of text that will turn scrollable once the text view runs out of space.\nAnd the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text.  "];
    uac.alertConfig.touchOutsideViewToDismiss = YES;
    uac.alertStyler.blurEnabled = @NO;
    uac.alertStyler.backgroundViewTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
    
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




- (IBAction)passiveAlertShowInView:(id)sender {
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"Passive alerts!" message:@"Very short alert. Minimum 2 second duration."];
    uac.alertStyler.blurTintColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    uac.alertConfig.duration = 2.0f;
    [uac showInView:self.bottomView];
}




#pragma mark - Methods
- (IBAction)fromModalTouched:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    URBNViewController *vc = [sb instantiateViewControllerWithIdentifier:@"URBNViewController"];
    [vc setIsModal:YES];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)closeTouch {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getters
- (UIView *)customView {
    if (!_customView) {
        _customView = [[CustomView alloc] init];
        _customView.backgroundColor = [UIColor greenColor];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beagle"]];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.translatesAutoresizingMaskIntoConstraints = NO;
        imgView.backgroundColor = [UIColor redColor];
        [_customView addSubview:imgView];
        
        _customView.customTextField = [UITextField new];
        _customView.customTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _customView.customTextField.backgroundColor = [UIColor whiteColor];
        _customView.customTextField.borderStyle = UITextBorderStyleRoundedRect;
        [_customView addSubview:_customView.customTextField];
        
        NSDictionary *views = @{@"imgView" : imgView, @"textField" : _customView.customTextField};
        [_customView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[imgView]-|" options:0 metrics:nil views:views]];
        [_customView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textField]-|" options:0 metrics:nil views:views]];
        [_customView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textField]-[imgView]-|" options:0 metrics:nil views:views]];
    }
    
    return _customView;
}

@end
