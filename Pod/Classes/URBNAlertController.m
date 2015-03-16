//
//  URBNAlertController.m
//  URBNAlertTest
//
//  Created by Ryan Garchinsky on 3/3/15.
//  Copyright (c) 2015 URBN. All rights reserved.
//

#import "URBNAlertController.h"
#import "URBNAlertViewController.h"
#import "URBNAlertView.h"
#import "URBNAlertConfig.h"
#import "URBNAlertAction.h"

@interface URBNAlertController ()

@property (nonatomic, assign) BOOL alertIsVisible;
@property (nonatomic, copy) NSArray *queue;

@end

@implementation URBNAlertController

#pragma mark - Initilization
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static URBNAlertController *instance;
    dispatch_once(&onceToken, ^{
        instance = [[URBNAlertController alloc] init];
        [instance setAlertStyler:[URBNAlertStyle new]];
        instance.window = [[UIApplication sharedApplication] windows][0];
    });
    
    return instance;
}

#pragma mark - Setters
- (void)setAlertStyler:(URBNAlertStyle *)alertStyler {
    _alertStyler = alertStyler ?: [URBNAlertStyle new];
}

#pragma mark - Methods
- (void)showAlertWithAlertViewController:(URBNAlertViewController *)alertVC {
    if (!self.alertIsVisible) {
        self.alertIsVisible = YES;

        __weak typeof(self) weakSelf = self;
        __weak typeof(alertVC) weakAlertVC = alertVC;
        [alertVC.alertView setButtonTouchedBlock:^(URBNAlertAction *action) {
            if (action.completionBlock) {
                action.completionBlock(action);
            }
        }];
        
        [alertVC setTouchedOutsideBlock:^{
            weakSelf.alertIsVisible = NO;

            if (weakAlertVC.alertConfig.passiveAlertDismissedBlock) {
                weakAlertVC.alertConfig.passiveAlertDismissedBlock(weakSelf, NO);
            }
        }];
        
        [self.window.rootViewController addChildViewController:alertVC];
        [self.window.rootViewController.view addSubview:alertVC.view];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        if (!alertVC.alertConfig.isActiveAlert) {
            [self performSelector:@selector(dismissAlert) withObject:nil afterDelay:alertVC.alertConfig.duration];
        }
    }
    else {
        [self queueAlert:alertVC];
    }
}

- (void)dismissAlert {
    self.alertIsVisible = NO;
    
    [self dequeueAlert];
}

- (CGFloat)calculateDuration:(URBNAlertConfig *)config {
    // The average number of words a person can read for minute is 250 - 300
    NSInteger wordCount = [[config.title componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] count];
    wordCount += [[config.message componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] count];
    
    NSInteger wordsPerSecond = 300 / 60;
    CGFloat calculatedDuration = ((wordCount / wordsPerSecond) < 2.f) ? 2.f : (wordCount / wordsPerSecond);
    
    return calculatedDuration;
}

#pragma mark - Queueing
- (void)queueAlert:(URBNAlertViewController *)avc {
    NSMutableArray *mutableQueue = self.queue.mutableCopy;
    if (!mutableQueue) {
        mutableQueue = [NSMutableArray new];
    }
    
    [mutableQueue addObject:avc];
    self.queue = mutableQueue.copy;
}

- (void)dequeueAlert {
    URBNAlertViewController *avc = self.queue.firstObject;
    if (avc) {
        NSMutableArray *mutableQueue = self.queue.mutableCopy;
        [mutableQueue removeObjectAtIndex:0];
        self.queue = mutableQueue.copy;
        [self showAlertWithAlertViewController:avc];
    }
}

@end