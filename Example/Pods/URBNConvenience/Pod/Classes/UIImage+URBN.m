//
//  UIImage+URBN.m
//  Pods
//
//  Created by Demetri Miller on 12/5/14.
//
//

#import "UIImage+URBN.h"

@implementation UIImage (URBN)

// Note : Sourced from https://github.com/vilanovi/UIImage-Additions

- (UIImage *)urbn_tintedImageWithColor:(UIColor *)color {
    if (!color) {
        return self;
    }
    
    CGFloat scale = self.scale;
    CGSize size = CGSizeMake(scale * self.size.width, scale * self.size.height);
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    // draw alpha-mask
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, self.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [color setFill];
    CGContextFillRect(context, rect);
    
    CGImageRef bitmapContext = CGBitmapContextCreateImage(context);
    
    UIImage *coloredImage = [UIImage imageWithCGImage:bitmapContext scale:scale orientation:UIImageOrientationUp];
    
    CGImageRelease(bitmapContext);
    
    UIGraphicsEndImageContext();
    
    return coloredImage;
}

+ (UIImage *)urbn_imageDrawnWithKey:(NSString *)key size:(CGSize)size drawBlock:(URBNConvenienceImageDrawBlock)drawBlock {
    NSAssert((key != nil), @"Key must be non-nil");
    NSAssert((size.width > 0) && (size.height > 0), @"Invalid image size (both dimensions must be greater than zero");
    static NSCache *_imageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imageCache = [[NSCache alloc] init];
    });
    
    UIImage *image = [_imageCache objectForKey:key];
    if (!image && drawBlock) {
        UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale); {
            CGContextRef context = UIGraphicsGetCurrentContext();
            drawBlock(CGRectMake(0, 0, size.width, size.height), context);
            image = UIGraphicsGetImageFromCurrentImageContext();
            [_imageCache setObject:image forKey:key];
        } UIGraphicsEndImageContext();
    }
    
    return image;
}

+ (UIImage *)urbn_screenShotOfView:(UIView *)view afterScreenUpdates:(BOOL)afterScreenUpdates {
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) afterScreenUpdates:afterScreenUpdates];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
