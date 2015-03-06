//
//  URBNViewController.m
//  URBNAlert
//
//  Created by Ryan Garchinsky on 03/04/2015.
//  Copyright (c) 2014 Ryan Garchinsky. All rights reserved.
//

#import "URBNViewController.h"
#import <URBNAlert/URBNAlertController.h>
#import <URBNConvenience/UIView+URBNLayout.h>
#import <URBNAlert/URBNAlertStyle.h>

@interface URBNViewController ()

@property (nonatomic, strong) URBNAlertController *alertController;

@end

@implementation URBNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.alertController = [URBNAlertController sharedInstance];

}

- (IBAction)activeAlertTouch:(id)sender {
    [self.alertController setAlertStyler:nil];
    [self.alertController showActiveAlertWithTitle:@"My Alert Title that could be 2 lines but no more than 2" message:@"Message and message and message and going on forever and ever." hasInput:NO buttons:@[@"Yes"]];
    
    __weak typeof(URBNAlertController) *weakAlertController = self.alertController;
    [self.alertController setButtonTouchedBlock:^(URBNAlertController *alertController, NSInteger index) {
        [weakAlertController dismissAlert];
    }];
}

- (IBAction)activeAlertTwoButtonTouch:(id)sender {
    [self.alertController setAlertStyler:nil];
    [self.alertController showActiveAlertWithTitle:@"My Alert Title that could be 2 lines but no more than 2" message:@"Message and message and message and going on forever and ever." hasInput:NO buttons:@[@"Yes", @"No"]];
    
    __weak typeof(URBNAlertController) *weakAlertController = self.alertController;
    [self.alertController setButtonTouchedBlock:^(URBNAlertController *alertController, NSInteger index) {
        [weakAlertController dismissAlert];
    }];
}

- (IBAction)activeAlertColoredTouch:(id)sender {
    URBNAlertStyle *alertStyle = [URBNAlertStyle new];
    alertStyle.buttonBackgroundColor = [UIColor yellowColor];
    alertStyle.buttonDenialBackgroundColor = [UIColor blueColor];
    alertStyle.backgroundColor = [UIColor orangeColor];
    alertStyle.buttonTitleColor = [UIColor blackColor];
    alertStyle.titleColor = [UIColor purpleColor];
    alertStyle.messageColor = [UIColor magentaColor];
    [self.alertController setAlertStyler:alertStyle];
    
    [self.alertController showActiveAlertWithTitle:@"My Alert Title that could be 2 lines but no more than 2" message:@"Message and message and message and going on forever and ever." hasInput:NO buttons:@[@"Yes", @"No"]];

    __weak typeof(URBNAlertController) *weakAlertController = self.alertController;
    [self.alertController setButtonTouchedBlock:^(URBNAlertController *alertController, NSInteger index) {
        [weakAlertController dismissAlert];
    }];
}

- (IBAction)activeAlertCustomViewTouch:(id)sender {
    [self.alertController setAlertStyler:nil];
    
    UIView *customView = [[UIView alloc] init];
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    customView.backgroundColor = [UIColor greenColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beagle"]];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.translatesAutoresizingMaskIntoConstraints = NO;
    imgView.backgroundColor = [UIColor redColor];
    [customView addSubview:imgView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(imgView);
    [customView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[imgView]-|" options:0 metrics:nil views:views]];
    [customView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[imgView]-|" options:0 metrics:nil views:views]];
    
    [self.alertController showActiveAlertWithView:customView buttons:@[@"Dismiss"]];
    
    __weak typeof(URBNAlertController) *weakAlertController = self.alertController;
    [self.alertController setButtonTouchedBlock:^(URBNAlertController *alertController, NSInteger index) {
        [weakAlertController dismissAlert];
    }];
}

- (IBAction)activeAlertMultipleAlertsTouch:(id)sender {
    [self.alertController showActiveAlertWithTitle:@"The First Alert" message:@"Message and message and message and going on forever and ever." hasInput:NO buttons:@[@"Yes"]];
    [self.alertController showActiveAlertWithTitle:@"#2" message:@"Message and message and message and going on forever and ever." hasInput:NO buttons:@[@"Yes", @"No"]];
    [self.alertController showActiveAlertWithTitle:@"#3" message:@"The third and final alert" hasInput:NO buttons:@[@"Done", @"Do it again!"]];

    __weak typeof(URBNAlertController) *weakAlertController = self.alertController;
    __weak typeof(self) weakSelf = self;
    [self.alertController setButtonTouchedBlock:^(URBNAlertController *alertController, NSInteger index) {
        switch (index) {
            case 1:
                [weakSelf activeAlertMultipleAlertsTouch:nil];
            case 0:
                [weakAlertController dismissAlert];
                break;

        }
    }];
}

@end
