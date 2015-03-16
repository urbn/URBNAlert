//
//  UIImage+URBN.h
//  Pods
//
//  Created by Demetri Miller on 12/5/14.
//
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageEffects.h"

typedef void(^URBNConvenienceImageDrawBlock)(CGRect rect, CGContextRef context);

@interface UIImage (URBN)

+ (UIImage *)urbn_imageDrawnWithKey:(NSString *)key size:(CGSize)size drawBlock:(URBNConvenienceImageDrawBlock)drawBlock;
+ (UIImage *)screenShotOfView:(UIView *)view afterScreenUpdates:(BOOL)afterScreenUpdates;

/**
 * UIImage+UIImageEffects blur method:

 * Note: tintColor must have a alpha < 1 
         ie. [[UIColor redColor] colorWithAlphaComponent:0.5];
 */
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;


@end
