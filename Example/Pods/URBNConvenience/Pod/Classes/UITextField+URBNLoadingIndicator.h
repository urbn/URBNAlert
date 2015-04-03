
#import <UIKit/UIKit.h>

/**
 *  The purpose of this category is to easily add the ability to 
 *  show hide UIActivityIndicatorView as the rightView of a UITextField
 */

@interface UITextField (URBNLoadingIndicator)

- (void)urbn_showLoading:(BOOL)loading animated:(BOOL)isAnimated;
- (void)urbn_showLoading:(BOOL)loading animated:(BOOL)isAnimated spinnerInsets:(UIEdgeInsets)insets;

@end
