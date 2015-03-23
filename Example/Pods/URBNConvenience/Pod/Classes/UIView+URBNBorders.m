//
//  UIView+URBNBorders.m
//  Pods
//
//  Created by Joseph Ridenour on 3/13/15.
//
//

#import "UIView+URBNBorders.h"
#import <objc/runtime.h>

/**
 *  URBNBorderView is our internal view for rendering our border objects. 
 *  It is a lazy loaded view that is added onto the viewCategory when necessary.
 */
@interface URBNBorderView : UIView
@property (nonatomic, strong) URBNBorder *urbn_leftBorder;
@property (nonatomic, strong) URBNBorder *urbn_topBorder;
@property (nonatomic, strong) URBNBorder *urbn_rightBorder;
@property (nonatomic, strong) URBNBorder *urbn_bottomBorder;
- (void)urbn_resetBorders;
@end


#pragma mark - UIView+Border
static const char kURBNBorderViewKey;
@implementation UIView (URBNBorders)

/** 
 *  Whenever we access `borderView` we'll create the borderView and pin it to the edges of
 *  ourselves.
 **/
- (URBNBorderView *)urbn_borderView {
    // If we're the borderView, then we need to return ourselves.   Infinite recursion is bad.
    if ([self isKindOfClass:[URBNBorderView class]]) {
        return (URBNBorderView *)self;
    }
    
    URBNBorderView *bv = objc_getAssociatedObject(self, &kURBNBorderViewKey);
    if (bv) {
        return bv;
    }
    
    // We do not have a borderView yet.  Let's create one and bind it to the edges of ourself
    bv = [[URBNBorderView alloc] initWithFrame:self.bounds];
    bv.opaque = NO;
    bv.userInteractionEnabled = NO;
    bv.clearsContextBeforeDrawing = YES;
    bv.contentMode = UIViewContentModeRedraw;
    bv.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bv];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(bv);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bv]|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bv]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    objc_setAssociatedObject(self, &kURBNBorderViewKey, bv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    return bv;
}

#pragma mark - External
- (void)urbn_resetBorders {
    [[self urbn_borderView] urbn_resetBorders];
}

#pragma mark - Getters
- (URBNBorder *)urbn_bottomBorder {
    return [self urbn_borderView].urbn_bottomBorder;
}

- (URBNBorder *)urbn_leftBorder {
    return [self urbn_borderView].urbn_leftBorder;
}

- (URBNBorder *)urbn_rightBorder {
    return [self urbn_borderView].urbn_rightBorder;
}

- (URBNBorder *)urbn_topBorder {
    return [self urbn_borderView].urbn_topBorder;
}

@end


#pragma mark - URBNBorderView Private
@implementation URBNBorderView

#pragma mark - Clear
- (void)clearAllBorders {
    [self unregisterKVOForBorder:_urbn_leftBorder], _urbn_leftBorder = nil;
    [self unregisterKVOForBorder:_urbn_rightBorder], _urbn_rightBorder = nil;
    [self unregisterKVOForBorder:_urbn_topBorder], _urbn_topBorder = nil;
    [self unregisterKVOForBorder:_urbn_bottomBorder], _urbn_bottomBorder = nil;
}

- (void)urbn_resetBorders {
    [self clearAllBorders];
    [self setNeedsDisplay];
}

#pragma mark - KVO
/**
 *  We're using KVO to determine when we need to redraw our borders.   If any of the properties of our borders
 *  changes, then we need to redraw.
 */
- (URBNBorder *)configuredBorder {
    URBNBorder *b = [URBNBorder new];
    [b addObserver:self forKeyPath:@"width" options:NSKeyValueObservingOptionNew context:nil];
    [b addObserver:self forKeyPath:@"color" options:NSKeyValueObservingOptionNew context:nil];
    [b addObserver:self forKeyPath:@"insets" options:NSKeyValueObservingOptionNew context:nil];
    return b;
}

- (void)unregisterKVOForBorder:(URBNBorder *)b {
    if (!b) {
        return;
    }
    [b removeObserver:self forKeyPath:@"width"];
    [b removeObserver:self forKeyPath:@"color"];
    [b removeObserver:self forKeyPath:@"insets"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self setNeedsDisplay];
}

#pragma mark - Lazy Load
- (URBNBorder *)urbn_leftBorder {
    if (!_urbn_leftBorder) {
        _urbn_leftBorder = [self configuredBorder];
    }
    return _urbn_leftBorder;
}

- (URBNBorder *)urbn_rightBorder {
    if (!_urbn_rightBorder) {
        _urbn_rightBorder = [self configuredBorder];
    }
    return _urbn_rightBorder;
}

- (URBNBorder *)urbn_bottomBorder {
    if (!_urbn_bottomBorder) {
        _urbn_bottomBorder = [self configuredBorder];
    }
    return _urbn_bottomBorder;
}

- (URBNBorder *)urbn_topBorder {
    if (!_urbn_topBorder) {
        _urbn_topBorder = [self configuredBorder];
    }
    return _urbn_topBorder;
}

#pragma mark - Drawing
- (CGFloat)renderingScaleFactor {
    return self.window.screen.nativeScale ?: self.contentScaleFactor;
}

- (CGAffineTransform)upscaleTransform {
    return CGAffineTransformMakeScale([self renderingScaleFactor], [self renderingScaleFactor]);
}

- (CGAffineTransform)downscaleTransform {
    return CGAffineTransformInvert([self upscaleTransform]);
}

- (void)drawRect:(CGRect)viewRect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectApplyAffineTransform(viewRect, [self upscaleTransform]);
    CGFloat minX = CGRectGetMinX(rect), maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect), maxY = CGRectGetMaxY(rect);
    
    // Keep things Dry
    void (^DrawBorder)(URBNBorder *, CGPoint, CGPoint) = ^(URBNBorder *b, CGPoint start, CGPoint end) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:start];
        [path addLineToPoint:end];
        path.lineWidth = b.width / [self renderingScaleFactor];
        [path applyTransform:[self downscaleTransform]];
        [b.color setStroke];
        [path stroke];
    };
    
    void (^BorderDrawBlock)(URBNBorder *, void (^)(URBNBorder*)) = ^(URBNBorder *b, void (^block)(URBNBorder*)) {
        if (b && b.width > 0) {
            CGContextSaveGState(context); {
                block(b);
            }; CGContextRestoreGState(context);
        }
    };
    
    // Top
    BorderDrawBlock(_urbn_topBorder, ^(URBNBorder *b) {
        UIEdgeInsets insets = b.insets;
        CGPoint fromPoint = CGPointMake(insets.left + minX, minY + insets.top + (b.width/2.f));
        CGPoint toPoint = CGPointMake(maxX - insets.right, fromPoint.y);
        DrawBorder(b, fromPoint, toPoint);
    });
    
    // Left
    BorderDrawBlock(_urbn_leftBorder, ^(URBNBorder *b) {
        UIEdgeInsets insets = b.insets;
        CGPoint fromPoint = CGPointMake(insets.left + minX + (b.width/2.f), insets.top + minY);
        CGPoint toPoint = CGPointMake(fromPoint.x, maxY - insets.bottom);
        DrawBorder(b, fromPoint, toPoint);
    });

    // Right
    BorderDrawBlock(_urbn_rightBorder, ^(URBNBorder *b) {
        UIEdgeInsets insets = b.insets;
        CGPoint fromPoint = CGPointMake(maxX - insets.right - (b.width/2.f), insets.top + minY);
        CGPoint toPoint = CGPointMake(fromPoint.x, maxY - insets.bottom);
        DrawBorder(b, fromPoint, toPoint);
    });

    // Bottom
    BorderDrawBlock(_urbn_bottomBorder, ^(URBNBorder *b) {
        UIEdgeInsets insets = b.insets;
        CGPoint fromPoint = CGPointMake(insets.left + minX, maxY - insets.bottom - (b.width/2.f));
        CGPoint toPoint = CGPointMake(maxX - insets.right, fromPoint.y);
        DrawBorder(b, fromPoint, toPoint);
    });
}

#pragma mark - Dealloc
- (void)dealloc {
    [self clearAllBorders];
}

@end


// Since we just have this object for the properties, there is no need for an implementation.
@implementation URBNBorder@end
