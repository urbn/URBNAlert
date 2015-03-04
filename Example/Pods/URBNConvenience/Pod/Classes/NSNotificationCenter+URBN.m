
#import "NSNotificationCenter+URBN.h"

@implementation NSNotificationCenter (MainQueue)

- (void)urbn_postNotification:(NSNotification *)notification onMainQueue:(BOOL)onMainQueue {
    void (^block)(void) = ^{
        [self postNotification:notification];
    };
    
    if (onMainQueue) {
        dispatch_async(dispatch_get_main_queue(), block);
    }
    else {
        block();
    }
}

- (void)urbn_postNotificationName:(NSString *)aName object:(id)anObject onMainQueue:(BOOL)onMainQueue {
    [self urbn_postNotificationName:aName object:anObject userInfo:nil onMainQueue:onMainQueue];
}

- (void)urbn_postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo onMainQueue:(BOOL)onMainQueue {
    NSNotification *notification = [[NSNotification alloc] initWithName:aName object:anObject userInfo:aUserInfo];
    [self urbn_postNotification:notification onMainQueue:onMainQueue];
}

@end
