//
//  UIView+URBNBorders.h
//  Pods
//
//  Created by Joseph Ridenour on 3/13/15.
//
//

#import <UIKit/UIKit.h>

@class URBNBorder;


/**
 *  This category is go give UIView full border support.  Each
 *  border has it's own set of configurations, so you can create fully custom borders on all edges.
 *  Each of the border objects is lazy loaded, so it will only draw the borders that you configure.
 */
@interface UIView (URBNBorders)

@property (nonatomic, strong, readonly) URBNBorder *urbn_topBorder;
@property (nonatomic, strong, readonly) URBNBorder *urbn_leftBorder;
@property (nonatomic, strong, readonly) URBNBorder *urbn_rightBorder;
@property (nonatomic, strong, readonly) URBNBorder *urbn_bottomBorder;

/**
 *  Call this in order to clear all of the borders
 */
- (void)urbn_resetBorders;

@end




@interface URBNBorder : NSObject

/**
 *  This is the stroke color of the border.
 */
@property (nonatomic, strong) UIColor *color;

/**
 *  This is the stroke width of the border
 */
@property (nonatomic, assign) CGFloat width;

/**
 *  This represents the edge insets of the border.  These 
 *  will be used where possible.  For instance, on the top border, 
 *  the `insets.bottom` will be ignored
 */
@property (nonatomic, assign) UIEdgeInsets insets;

@end