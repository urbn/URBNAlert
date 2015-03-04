
#import "URBNTextField.h"

@implementation URBNTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect rect = [super leftViewRectForBounds:bounds];
    rect.origin.x += self.edgeInsets.left;
    return rect;
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    return [super clearButtonRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    return [super rightViewRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    _edgeInsets = edgeInsets;
    [self setNeedsLayout];
}

@end
