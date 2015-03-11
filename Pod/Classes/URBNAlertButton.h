//
//  URBNAlertButton.h
//  Pods
//
//  Created by Ryan Garchinsky on 3/10/15.
//
//

#import <Foundation/Foundation.h>

typedef void(^URBNAlertButtonTouchedd)();

@interface URBNAlertButton : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, copy) URBNAlertButtonTouchedd buttonTouchedBlock;
- (void)setButtonTouchedBlock:(URBNAlertButtonTouchedd)buttonTouchedBlock;

+ (URBNAlertButton *)buttonWithTitle:(NSString *)title buttonTouched:(URBNAlertButtonTouchedd)buttonTouchedBlock;

@end
