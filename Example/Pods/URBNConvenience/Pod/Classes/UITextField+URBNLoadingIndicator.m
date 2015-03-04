
#import "UITextField+URBNLoadingIndicator.h"

static CGFloat kURBNTextFieldLoadingIndicatorAnimationDuration = .25f;

@implementation UITextField (URBNLoadingIndicator)

- (void)urbn_showLoading:(BOOL)loading animated:(BOOL)isAnimated {
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
            self.rightView = indy;
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
