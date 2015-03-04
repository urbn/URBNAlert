
#import <Foundation/Foundation.h>

@interface NSNotificationCenter (MainQueue)

- (void)urbn_postNotification:(NSNotification *)notification onMainQueue:(BOOL)onMainQueue;
- (void)urbn_postNotificationName:(NSString *)aName object:(id)anObject onMainQueue:(BOOL)onMainQueue;
- (void)urbn_postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo onMainQueue:(BOOL)onMainQueue;

@end
