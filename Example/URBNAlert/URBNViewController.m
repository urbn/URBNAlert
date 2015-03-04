//
//  URBNViewController.m
//  URBNAlert
//
//  Created by Ryan Garchinsky on 03/04/2015.
//  Copyright (c) 2014 Ryan Garchinsky. All rights reserved.
//

#import "URBNViewController.h"
#import <URBNAlert/URBNAlertController.h>

@interface URBNViewController ()

@end

@implementation URBNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)activeAlertTouch:(id)sender {
    URBNAlertController *alertContoller = [[URBNAlertController alloc] initActiveAlertWithTitle:@"My Alert Title that could be 2 lines but no more than 2" message:@"Message and message and message and going on forever and ever." hasInput:YES buttons:@[@"Yes"]];
    alertContoller.touchOutsideToDismiss = NO;
    
    __weak typeof(URBNAlertController) *weakAlertController = alertContoller;
    [alertContoller setButtonTouchedBlock:^(URBNAlertController *alertController, NSInteger index) {
        NSLog(@"button touch at index: %ld", index);
        [weakAlertController dismissAlert];
    }];
    
    [alertContoller showAlert];
}

- (IBAction)activeAlertTwoButtonTouch:(id)sender {
    URBNAlertController *alertContoller = [[URBNAlertController alloc] initActiveAlertWithTitle:@"My Alert Title" message:@"Message and message and message and going on forever and ever." hasInput:YES buttons:@[@"Yes", @"No"]];
    alertContoller.touchOutsideToDismiss = NO;
    alertContoller.buttonBackgroundColor = [UIColor redColor];
    
    __weak typeof(URBNAlertController) *weakAlertController = alertContoller;
    [alertContoller setButtonTouchedBlock:^(URBNAlertController *alertController, NSInteger index) {
        NSLog(@"button touch at index: %ld", index);
        [weakAlertController dismissAlert];
    }];
    
    [alertContoller showAlert];
}

@end
