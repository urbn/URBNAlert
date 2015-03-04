
#import <UIKit/UIKit.h>

/**
 *  The purpose of this is to give a quick little animation to content changing. 
 *  Whether that's text changes that look stupid when changing, or maybe just transitioning views.
 */

@interface UIView (URBNAnimations)

- (void)urbn_crossDissolveTransitionWithBlock:(dispatch_block_t)block;   // This will user .2 as the duration
- (void)urbn_crossDissolveTransitionWithDuration:(CGFloat)duration block:(dispatch_block_t)block;

@end
