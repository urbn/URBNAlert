//
//  UIImage+URBN.m
//  Pods
//
//  Created by Demetri Miller on 12/5/14.
//
//

#import "UIImage+URBN.h"

@implementation UIImage (URBN)

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
