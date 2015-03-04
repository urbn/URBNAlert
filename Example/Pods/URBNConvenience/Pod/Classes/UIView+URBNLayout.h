//
//  UIView+URBNLayout.h
//

#import <UIKit/UIKit.h>

@interface UIView (URBNLayoutFrameHelpers)

// Position of the top-left corner in superview's coordinates
@property CGPoint position;
@property CGFloat x;
@property CGFloat y;

// Setting size keeps the position (top-left corner) constant
@property CGSize size;
@property CGFloat width;
@property CGFloat height;

@end

@interface UIView (URBNLayoutTransfomrHelpers)

CGAffineTransform CGAffineScaleTransformForRectConversion(CGRect fromRect, CGRect toRect);
CGAffineTransform CGAffineTransformForRectConversion(CGRect fromRect, CGRect toRect);
CATransform3D CATranform3DForRectConversion(CGRect fromRect, CGRect toRect);
CGSize CGSizeAspectFit(CGSize aspectRatio, CGSize boundingSize);
float pin(float min, float value, float max);

@end

@interface UIView (URBNLayoutConstraintHelpers)

/**
 *  Any of the methods below that add constriants will use this as the 
 *  constraint.identifier.  
 *  You can set your own identifier if you'd like something that is more
 *  tailored to your application.   By default it's defined as "URBN.Constraint.Identifier"
 *
 *  NOTE: This should be set at the very beginning of app launch if necessary
 */
+ (void)urbn_setConstraintIdentifier:(NSString *)identifier;
+ (NSString *)urbn_constraintIdentifier;

/**
 *  Get a view with height and width constraints set to the specified size.
 *
 *  @param size The size you want your width / height set to.
 *
 *  @return The autoLayout enabled view at the proper size
 */
+ (UIView *)urbn_viewContsrainedToSize:(CGSize)size;

/** 
 *  Wraps [self removeConstraints:[self constraints]];
 */
- (void)urbn_clearAllConstraints;

/**
 *  Wraps [self layoutIfNeeded]; [self invalidateIntrinsicContentSize];
 */
- (void)urbn_layoutAndInvalidateIntrinsicSize;

/**
 *  This will remove all constraints from self that pertain to 
 *  the given view.   This will NOT remove constraints added on the view itself.
 *
 *  @param view The view to match constraints for.
 */
- (void)urbn_clearAllConstraintsForSubView:(UIView *)view;

/**
 *  Constrains centerX, centerY, width, and height to match
 *  the given view
 *
 *  @param view The view to match constraints with
 */
- (void)urbn_constrainViewEqual:(UIView *)view;

/**
 *  Convenience accessors / setters for basic constraints.
 */
- (NSLayoutConstraint *)urbn_widthLayoutConstraint;
- (NSLayoutConstraint *)urbn_heightLayoutConstraint;

- (NSLayoutConstraint *)urbn_addWidthLayoutConstraingWithConstant:(CGFloat)constant;
- (NSLayoutConstraint *)urbn_addWidthLayoutConstraingWithConstant:(CGFloat)constant withPriority:(UILayoutPriority)priority;

- (NSLayoutConstraint *)urbn_addHeightLayoutConstraintWithConstant:(CGFloat)constant;
- (NSLayoutConstraint *)urbn_addHeightLayoutConstraintWithConstant:(CGFloat)constant withPriority:(UILayoutPriority)priority;

// Everything else
/**
 *  This will define the `identifier` property of each constraint.
 *  You can then use the `-urbn_constraintForAttribute` to lookup any of these constraints.
 *
 *  @param constraints  The constraints to add identifiers for. 
 */
- (void)urbn_addAndIdentifyConstraints:(NSArray *)constraints;
- (NSLayoutConstraint *)urbn_constraintForAttribute:(NSLayoutAttribute)attribute;
- (NSLayoutConstraint *)urbn_addConstraintForAttribute:(NSLayoutAttribute)attribute withConstant:(CGFloat)constant withPriority:(UILayoutPriority)priority;

/**
 *  Create a constraint with the given properties
 *
 *  @param attribute This is the attribute to create the constraint with.  (This will also be the attribute related if @item is defined)
 *  @param item      The `toItem` to relate against.  If this is defined, then the @attribute will be used as the relation
 *  @param constant  The constant for the constraint
 *  @param priority  The priority of the constraint (Defaults to High)
 *
 *  @return A newly created constraint based on the params above.  This constraint will have already been applied to the self.
 */
- (NSLayoutConstraint *)urbn_addConstraintForAttribute:(NSLayoutAttribute)attribute withItem:(id)item;
- (NSLayoutConstraint *)urbn_addConstraintForAttribute:(NSLayoutAttribute)attribute withItem:(id)item withConstant:(CGFloat)constant;
- (NSLayoutConstraint *)urbn_addConstraintForAttribute:(NSLayoutAttribute)attribute withItem:(id)item withConstant:(CGFloat)constant withPriority:(UILayoutPriority)priority;

/**
 *  The purpose of this is to replace the
 *
 *  ```objc
 *      UIView *container = [[UIView alloc] init];
 *      container.translatesAutoresizingMaskIntoConstraints = NO;
 *      [container addSubview: view]; 
 *
 *      NSDictionary *views = NSDictionaryOfVariableBindings(view);
 *      NSDictionary *metrics = @{@"top":@0, @"left": @0, @"bot": @0, @"right": @0};
 *      NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[view]-right-|" options:0 metrics:metrics views:views];
 *      NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[view]-bottom-|" options:0 metrics:metrics views:views];
 *      [container addConstraints:[h arrayByAddingObjectsFromArray:v]];
 *  ```
 *
 *  @param  container - This is an optional container that you've created.  Passing nil will 
 *                      tell this method to create the container for you.
 *  @return The containing view
 */
- (UIView *)urbn_wrapInContainerViewWithView:(UIView *)container;
- (UIView *)urbn_wrapInContainerViewWithView:(UIView *)container insets:(UIEdgeInsets)insets;

@end

