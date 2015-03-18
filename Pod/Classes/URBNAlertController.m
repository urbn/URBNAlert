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

#pragma mark - Show / Dismiss Methods
- (void)showNextAlert {
    if (!self.alertIsVisible && [self peekQueue]) {
        self.alertIsVisible = YES;

        URBNAlertViewController *avc = [self peekQueue];
        
        __weak typeof(self) weakSelf = self;
        __weak typeof(avc) weakAlertVC = avc;
        [avc.alertView setButtonTouchedBlock:^(URBNAlertAction *action) {
            if (action.completionBlock) {
                action.completionBlock(action);
            }
        }];
        
        [avc setTouchedOutsideBlock:^{
            weakSelf.alertIsVisible = NO;

            if (weakAlertVC.alertConfig.passiveAlertDismissedBlock) {
                weakAlertVC.alertConfig.passiveAlertDismissedBlock(weakAlertVC, NO);
            }
        }];
        
        [self.window.rootViewController addChildViewController:avc];
        [self.window.rootViewController.view addSubview:avc.view];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        if (!avc.alertConfig.isActiveAlert) {
            CGFloat duration = avc.alertConfig.duration == 0 ? [self calculateDuration:avc.alertConfig] : avc.alertConfig.duration;
            [self performSelector:@selector(dismissPassiveAlert:) withObject:avc afterDelay:duration];
        }
    }
}

- (void)dismissPassiveAlert:(URBNAlertViewController *)avc {
    self.alertIsVisible = NO;
    [self popQueue];
    [avc dismiss];
    [self showNextAlert];
}

- (void)dismissAlert {
    self.alertIsVisible = NO;
    [self popQueue];
    [self showNextAlert];
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
- (void)addAlertToQueueWithAlertViewController:(URBNAlertViewController *)avc {
    NSMutableArray *mutableQueue = self.queue.mutableCopy;
    if (!mutableQueue) {
        mutableQueue = [NSMutableArray new];
    }
    
    [mutableQueue addObject:avc];
    self.queue = mutableQueue.copy;
    
    [self showNextAlert];
}

- (URBNAlertViewController *)popQueue {
    URBNAlertViewController *avc = self.queue.firstObject;
    if (avc) {
        NSMutableArray *mutableQueue = self.queue.mutableCopy;
        [mutableQueue removeObjectAtIndex:0];
        self.queue = mutableQueue.copy;
    }
    
    return avc;
}

- (URBNAlertViewController *)peekQueue {
    return self.queue.firstObject;
}

@end