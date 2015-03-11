//
//  URBNAlertButton.m
//  Pods
//
//  Created by Ryan Garchinsky on 3/10/15.
//
//

#import "URBNAlertButton.h"

@implementation URBNAlertButton

+ (URBNAlertButton *)buttonWithTitle:(NSString *)title buttonTouched:(URBNAlertButtonTouchedd)buttonTouchedBlock {
    URBNAlertButton *btn = [URBNAlertButton new];
    [btn setTitle:title];
    [btn setButtonTouchedBlock:buttonTouchedBlock];
    return btn;
}

@end
