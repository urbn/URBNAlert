
#import "UITextField+URBNLoadingIndicator.h"
#import "UIView+URBNLayout.h"

static CGFloat kURBNTextFieldLoadingIndicatorAnimationDuration = .25f;

@implementation UITextField (URBNLoadingIndicator)

- (void)urbn_showLoading:(BOOL)loading animated:(BOOL)isAnimated {
    [self urbn_showLoading:loading animated:isAnimated spinnerInsets:UIEdgeInsetsZero];
}

- (void)urbn_showLoading:(BOOL)loading animated:(BOOL)isAnimated spinnerInsets:(UIEdgeInsets)insets {
    //If we're already showing the loading indicator don't try showing again
    if ( loading && [self.rightView isKindOfClass:[UIActivityIndicatorView class]] ) {
        return;
    }
    
    UIActivityIndicatorView * indy = (UIActivityIndicatorView *)self.rightView;
    
    // What we want to animate here.
    void (^DisplayBlock)() = ^{
        self.rightView.alpha = loading? 1.f : 0.f;
    };
    
    void (^CompletionBlock)() = ^{
        if(!loading) {
            self.rightView = nil;
        }
    };
    
    if(loading) {
        if(!indy || ![indy isKindOfClass:[UIActivityIndicatorView class]]) {
            indy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, (indy.size.width + insets.right + insets.left), (indy.size.height + insets.top + insets.bottom))];

            indy.frame = CGRectMake(insets.left, insets.top, indy.width, indy.height);
            [newView addSubview:indy];
            
            self.rightView = newView;
        }
        
        self.rightViewMode = UITextFieldViewModeAlways;
        [indy startAnimating];
    }
    
    self.rightView.alpha = loading ? 0.f : 1.f; // Hide at first.
    
    if (isAnimated) {
        [UIView animateWithDuration:kURBNTextFieldLoadingIndicatorAnimationDuration animations:DisplayBlock completion:^(BOOL finished) {
            CompletionBlock();
        }];
    }
    else {
        DisplayBlock();
        CompletionBlock();
    }
}

@end
