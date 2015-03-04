
#import "UIView+URBNAnimations.h"

@implementation UIView (URBNAnimations)

- (void)urbn_crossDissolveTransitionWithBlock:(dispatch_block_t)block {
    [self urbn_crossDissolveTransitionWithDuration:.2f block:block];
}

- (void)urbn_crossDissolveTransitionWithDuration:(CGFloat)duration block:(dispatch_block_t)block {
    [UIView transitionWithView:self duration:duration
                       options:UIViewAnimationOptionAllowUserInteraction |
                                UIViewAnimationOptionAllowAnimatedContent |
                                UIViewAnimationOptionTransitionCrossDissolve |
                                UIViewAnimationOptionLayoutSubviews
                    animations:block completion:nil];
}

@end
