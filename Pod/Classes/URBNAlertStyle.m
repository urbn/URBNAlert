//
//  URBNAlertStyle.m
//  Pods
//
//  Created by Ryan Garchinsky on 3/6/15.
//
//

#import "URBNAlertStyle.h"

@implementation URBNAlertStyle

#pragma mark - Title
- (UIColor *)titleColor {
    return _titleColor ?: [UIColor blackColor];
}

- (UIFont *)titleFont {
    return _titleFont ?: [UIFont boldSystemFontOfSize:14];
}

- (NSTextAlignment)titleAlignment {
    return _titleAlignment ?: NSTextAlignmentCenter;
}

#pragma mark - Message
- (UIColor *)messageColor {
    return _messageColor ?: [UIColor blackColor];
}

- (UIFont *)messageFont {
    return _messageFont ?: [UIFont systemFontOfSize:14];
}

- (NSTextAlignment)messageAlignment {
    return _messageAlignment ?: NSTextAlignmentLeft;
}

#pragma mark - Error
- (UIColor *)errorTextColor {
    return _errorTextColor ?: [UIColor redColor];
}

- (UIFont *)errorTextFont {
    return _errorTextFont ?: [UIFont boldSystemFontOfSize:14];
}

#pragma mark - Buttons
- (UIColor *)buttonTitleColor {
    return _buttonTitleColor ?: [UIColor whiteColor];
}

- (UIFont *)buttonFont {
    return _buttonFont ?: [UIFont boldSystemFontOfSize:14];
}

- (UIColor *)buttonBackgroundColor {
    return _buttonBackgroundColor ?: [UIColor lightGrayColor];
}

- (UIColor *)destructionButtonBackgroundColor {
    return _destructionButtonBackgroundColor ?: [UIColor redColor];
}

- (UIColor *)destructiveButtonTitleColor {
    return _destructiveButtonTitleColor ?: [UIColor whiteColor];
}

- (NSNumber *)buttonCornerRadius {
    return _buttonCornerRadius ?: @8;
}

- (NSNumber *)buttonHeight {
    return _buttonHeight ?: @44;
}

- (NSNumber *)buttonHorizontalMargin {
    return _buttonHorizontalMargin ?: @8;
}

#pragma mark - Alert View
- (NSNumber *)alertCornerRadius {
    return _alertCornerRadius ?: @8;
}

- (NSNumber *)sectionVerticalMargin {
    return _sectionVerticalMargin ?: @24;
}

- (NSNumber *)labelHorizontalMargin {
    return _labelHorizontalMargin ?: @16;
}

- (NSNumber *)animationDuration {
    return _animationDuration ?: @0.3f;
}

- (NSNumber *)customViewMargin {
    return _customViewMargin ?: @8;
}

- (UIColor *)backgroundColor {
    return _backgroundColor ?: [UIColor whiteColor];
}

#pragma mark - Text Field
- (NSNumber *)textFieldMaxLength {
    return _textFieldMaxLength ?: @25;
}

#pragma mark - Shadow
- (NSNumber *)alertViewShadowRadius {
    return _alertViewShadowRadius ?: @2;
}

- (NSNumber *)alertViewShadowOpacity {
    return _alertViewShadowOpacity ?: @0.3f;
}

- (UIColor *)alertViewShadowColor {
    return _alertViewShadowColor ?: [UIColor blackColor];
}

- (CGSize)alertShadowOffset {
    return CGSizeEqualToSize(_alertShadowOffset, CGSizeZero) ? CGSizeMake(1, 1) : _alertShadowOffset;
}

#pragma mark - Blur / Background View
- (NSNumber *)blurEnabled {
    return _blurEnabled ?: @YES;
}

- (NSNumber *)blurRadius {
    return _blurRadius ?: @5;
}

- (NSNumber *)blurSaturationDelta {
    return _blurSaturationDelta ?: @1;
}

- (UIColor *)blurTintColor {
    _blurTintColor = _blurTintColor ?: [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
    CGFloat red, green, blue, alpha;
    [_blurTintColor getRed:&red green:&green blue:&blue alpha:&alpha];
    NSAssert(alpha < 1.0f, @"URBNAlertStyle: blurTintColor alpha component must be less than 1.0f to see the blur effect. Please use colorWithAlphaComponent: when setting a custom blurTintColor, for example: [[UIColor whiteColor] colorWithAlphaComponent:0.4f]");
    
    return _blurTintColor;
}

- (id)copyWithZone:(NSZone *)zone {
    URBNAlertStyle *styler = [URBNAlertStyle new];
    
    // UIColors
    styler.buttonBackgroundColor = [[UIColor alloc] initWithCGColor:self.buttonBackgroundColor.CGColor];
    styler.destructionButtonBackgroundColor = [[UIColor alloc] initWithCGColor:self.destructionButtonBackgroundColor.CGColor];
    styler.destructiveButtonTitleColor = [[UIColor alloc] initWithCGColor:self.destructiveButtonTitleColor.CGColor];
    styler.buttonTitleColor = [[UIColor alloc] initWithCGColor:self.buttonTitleColor.CGColor];
    styler.backgroundColor = [[UIColor alloc] initWithCGColor:self.backgroundColor.CGColor];
    styler.titleColor = [[UIColor alloc] initWithCGColor:self.titleColor.CGColor];
    styler.messageColor = [[UIColor alloc] initWithCGColor:self.messageColor.CGColor];
    styler.alertViewShadowColor = [[UIColor alloc] initWithCGColor:self.alertViewShadowColor.CGColor];
    styler.blurTintColor = [[UIColor alloc] initWithCGColor:self.blurTintColor.CGColor];
    styler.backgroundViewTintColor = [[UIColor alloc] initWithCGColor:self.backgroundViewTintColor.CGColor];
    styler.errorTextColor = [[UIColor alloc] initWithCGColor:self.errorTextColor.CGColor];

    // UIFonts
    styler.titleFont = self.titleFont.copy;
    styler.messageFont = self.messageFont.copy;
    styler.buttonFont = self.buttonFont.copy;
    styler.errorTextFont = self.errorTextFont.copy;
    
    // NSTextAlignment
    styler.titleAlignment = self.titleAlignment;
    styler.messageAlignment = self.messageAlignment;
    
    // NSNumbers
    styler.buttonCornerRadius = self.alertCornerRadius.copy;
    styler.alertCornerRadius = self.alertCornerRadius.copy;
    styler.textFieldMaxLength = self.textFieldMaxLength.copy;
    styler.buttonHeight = self.buttonHeight.copy;
    styler.sectionVerticalMargin = self.sectionVerticalMargin.copy;
    styler.labelHorizontalMargin = self.labelHorizontalMargin.copy;
    styler.buttonHorizontalMargin = self.buttonHorizontalMargin.copy;
    styler.customViewMargin = self.customViewMargin.copy;
    styler.animationDuration = self.animationDuration.copy;
    styler.alertViewShadowOpacity = self.alertViewShadowOpacity.copy;
    styler.alertViewShadowRadius = self.alertViewShadowRadius.copy;
    styler.blurSaturationDelta = self.blurSaturationDelta.copy;
    styler.alertCornerRadius = self.alertCornerRadius.copy;

    return styler;
}

@end
