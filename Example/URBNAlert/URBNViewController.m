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
    self.alertController.touchOutsideToDismiss = NO;

}

- (IBAction)activeAlertTouch:(id)sender {
    URBNAlertController *alertContoller = [[URBNAlertController alloc] initActiveAlertWithTitle:@"My Alert Title that could be 2 lines but no more than 2" message:@"Message and message and message and going on forever and ever." hasInput:YES buttons:@[@"Yes"]];
    
    __weak typeof(URBNAlertController) *weakAlertController = alertContoller;
    [alertContoller setButtonTouchedBlock:^(URBNAlertController *alertController, NSInteger index) {
        [weakAlertController dismissAlert];
    }];
    
    [alertContoller showAlert];
}

- (IBAction)activeAlertTwoButtonTouch:(id)sender {
    URBNAlertController *alertContoller = [[URBNAlertController alloc] initActiveAlertWithTitle:@"My Alert Title" message:@"Message and message and message and going on forever and ever." hasInput:YES buttons:@[@"Yes", @"No"]];
    
    __weak typeof(URBNAlertController) *weakAlertController = alertContoller;
    [alertContoller setButtonTouchedBlock:^(URBNAlertController *alertController, NSInteger index) {
        [weakAlertController dismissAlert];
    }];
    
    [alertContoller showAlert];
}

- (IBAction)activeAlertColoredTouch:(id)sender {
    URBNAlertController *alertContoller = [[URBNAlertController alloc] initActiveAlertWithTitle:@"Colorful Alert" message:@"Message and message and message and going on forever and ever and ever and ever and ever and ever and ever and ever and ever and ever and ever and ever and ever and ever and ever and ever and ever and ever and ever and ever and ever and ever." hasInput:YES buttons:@[@"Yes", @"No"]];
    
    URBNAlertStyle *alertStyle = [URBNAlertStyle new];
    alertStyle.buttonBackgroundColor = [UIColor redColor];
    alertStyle.buttonDenialBackgroundColor = [UIColor greenColor];
    alertStyle.backgroundColor = [UIColor orangeColor];
    alertStyle.titleColor = [UIColor purpleColor];
    alertStyle.messageColor = [UIColor blueColor];
    
    [self.alertController setAlertStyle:alertStyle];

    __weak typeof(URBNAlertController) *weakAlertController = alertContoller;
    [alertContoller setButtonTouchedBlock:^(URBNAlertController *alertController, NSInteger index) {
        [weakAlertController dismissAlert];
    }];
    
    [alertContoller showAlert];
}

- (IBAction)activeAlertCustomViewTouch:(id)sender {
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
    
    URBNAlertController *alertContoller = [[URBNAlertController alloc] initActiveAlertWithView:customView buttons:@[@"So Cute"]];
    
    __weak typeof(URBNAlertController) *weakAlertController = alertContoller;
    [alertContoller setButtonTouchedBlock:^(URBNAlertController *alertController, NSInteger index) {
        [weakAlertController dismissAlert];
    }];
    
    [alertContoller showAlert];
}

@end
