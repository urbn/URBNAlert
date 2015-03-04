//
//  UIImage+URBN.h
//  Pods
//
//  Created by Demetri Miller on 12/5/14.
//
//

#import <UIKit/UIKit.h>

typedef void(^URBNConvenienceImageDrawBlock)(CGRect rect, CGContextRef context);

@interface UIImage (URBN)

+ (UIImage *)urbn_imageDrawnWithKey:(NSString *)key size:(CGSize)size drawBlock:(URBNConvenienceImageDrawBlock)drawBlock;

@end
