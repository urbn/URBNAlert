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
@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, strong) UIWindow *presentingWindow;

@end

@implementation URBNAlertController

#pragma mark - Initilization
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static URBNAlertController *instance;
    dispatch_once(&onceToken, ^{
        instance = [[URBNAlertController alloc] init];
        [instance setAlertStyler:[URBNAlertStyle new]];
        instance.presentingWindow = [[[UIApplication sharedApplication] windows] firstObject];
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
        
        // Called anytime the alert is dismissed after the animation is complete
        [avc setFinishedDismissingBlock:^(BOOL wasTouchedOutside) {
            if (wasTouchedOutside) {
                [weakSelf dismissAlertViewController:weakAlertVC];
            }
            
            // If the queue is empty, remove the window. If not keep visible to present next alert(s)
            if (!weakSelf.queue || weakSelf.queue.count == 0) {
                [weakSelf.presentingWindow makeKeyAndVisible];
                weakSelf.alertWindow.hidden = YES;
                weakSelf.alertWindow = nil;
            }
        }];
        
        [avc.alertView setButtonTouchedBlock:^(URBNAlertAction *action) {
            if (action.completionBlock) {
                action.completionBlock(action);
            }
            
            if (action.dismissOnCompletion) {
                [weakSelf dismissAlertViewController:weakAlertVC];
            }
        }];
        
        [avc.alertView setAlertViewTouchedBlock:^(URBNAlertAction *action) {
            if (action.completionBlock) {
                action.completionBlock(action);
            }
            
            [weakSelf dismissAlertViewController:weakAlertVC];
        }];
        
        // showInView: used
        if (avc.alertConfig.presentationView) {
            CGRect rect = avc.view.frame;
            rect.size.width = avc.alertConfig.presentationView.frame.size.width;
            rect.size.height = avc.alertConfig.presentationView.frame.size.height;
            avc.view.frame = rect;
            
            [avc.alertConfig.presentationView addSubview:avc.view];
        }
        else {
            [self setupAlertWindow];
            self.alertWindow.rootViewController = avc;
            [self.alertWindow makeKeyAndVisible];
        }
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        if (!avc.alertConfig.isActiveAlert) {
            CGFloat duration = avc.alertConfig.duration == 0 ? [self calculateDuration:avc.alertConfig] : avc.alertConfig.duration;
            [self performSelector:@selector(dismissAlertViewController:) withObject:avc afterDelay:duration];
        }
    }
}

- (void)dismissAlertViewController:(URBNAlertViewController *)avc {
    self.alertIsVisible = NO;;
    [avc dismiss];
    [self showNextAlert];
}

- (void)dismissingAlert {
    self.alertIsVisible = NO;
    [self popQueue];
    [self showNextAlert];
}

- (void)dismissAlert {
    [self dismissAlertViewController:[self peekQueue]];
}

#pragma mark - Methods
- (void)setupAlertWindow {
    if (self.alertWindow) {
        return;
    }
    
    self.presentingWindow = [[[UIApplication sharedApplication] windows] firstObject];
    
    self.alertWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.alertWindow.windowLevel = UIWindowLevelAlert;
    self.alertWindow.hidden = NO;
    self.alertWindow.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignActive:) name:UIWindowDidBecomeKeyNotification object:nil];
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
    NSMutableArray *mutableQueue = [self.queue mutableCopy];
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

#pragma mark - Notifications
/**
 *  Called when a new window becomes active.
 *  Specifically used to detect new alertViews or actionSheets so we can dismiss ourselves
 **/
- (void)resignActive:(NSNotification *)note {
    if (note.object == self.alertWindow || note.object == self.presentingWindow) {
        return;
    }
    
    [self dismissAlert];
}

@end