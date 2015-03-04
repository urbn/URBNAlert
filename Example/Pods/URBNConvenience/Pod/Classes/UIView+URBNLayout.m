//
//  UIView+URBNLayout.m
//

#import "UIView+URBNLayout.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (URBNLayoutFrameHelpers)

- (CGPoint)position {
    return self.frame.origin;
}

- (void)setPosition:(CGPoint)position {
    CGRect rect = self.frame;
    rect.origin = position;
    [self setFrame:rect];
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    CGRect rect = self.frame;
    rect.origin.x = x;
    [self setFrame:rect];
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    CGRect rect = self.frame;
    rect.origin.y = y;
    [self setFrame:rect];
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect rect = self.frame;
    rect.size = size;
    [self setFrame:rect];
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    [self setFrame:rect];
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    [self setFrame:rect];
}

@end

@implementation UIView (URBNLayoutTransfomrHelpers)

CGAffineTransform CGAffineScaleTransformForRectConversion(CGRect fromRect, CGRect toRect) {
    CGFloat scaleX = toRect.size.width / fromRect.size.width;
    CGFloat scaleY = toRect.size.height / fromRect.size.height;
    
    return CGAffineTransformMakeScale(scaleX, scaleY);
}

CGAffineTransform CGAffineTranslateTransformForRectConversion(CGRect fromRect, CGRect toRect) {
    CGFloat translateX = CGRectGetMidX(toRect) - CGRectGetMidX(fromRect);
    CGFloat translateY = CGRectGetMidY(toRect) - CGRectGetMidY(fromRect);
    
    return CGAffineTransformMakeTranslation(translateX, translateY);
}

CGAffineTransform CGAffineTransformForRectConversion(CGRect fromRect, CGRect toRect) {
    CGFloat scaleX = toRect.size.width / fromRect.size.width;
    CGFloat scaleY = toRect.size.height / fromRect.size.height;
    
    CGFloat translateX = CGRectGetMidX(toRect) - CGRectGetMidX(fromRect);
    CGFloat translateY = CGRectGetMidY(toRect) - CGRectGetMidY(fromRect);
    
    CGAffineTransform t = CGAffineTransformMakeTranslation(translateX, translateY);
    return CGAffineTransformScale(t, scaleX, scaleY);
}

CATransform3D CATranform3DForRectConversion(CGRect fromRect, CGRect toRect) {
    return CATransform3DMakeAffineTransform(CGAffineTransformForRectConversion(fromRect, toRect));
}

CGSize CGSizeAspectFit(CGSize aspectRatio, CGSize boundingSize) {
    float width = boundingSize.width / aspectRatio.width;
    float height = boundingSize.height / aspectRatio.height;
    
    if (height < width) {
        boundingSize.width = boundingSize.height / aspectRatio.height * aspectRatio.width;
    }
    else if (width < height) {
        boundingSize.height = boundingSize.width / aspectRatio.width * aspectRatio.height;
    }
    
    return boundingSize;
}

float pin(float min, float value, float max) {
    if (value > max) {
        return max;
    }
    else if (value < min) {
        return min;
    }
    else {
        return value;
    }
}

@end

static NSString * URBNConstraint_Identifier = @"URBN.Constraint.Identifier";
@implementation UIView (URBNLayoutConstraintHelpers)

#pragma mark - Constraint Identifier Helpers
+ (void)urbn_setConstraintIdentifier:(NSString *)identifier {
    URBNConstraint_Identifier = identifier;
}
+ (NSString *)urbn_constraintIdentifier {
    return URBNConstraint_Identifier;
}

#pragma mark - View Setup Helpers
+ (UIView *)urbn_viewContsrainedToSize:(CGSize)size {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    // set low priority so any superview that wants to override can
    [view urbn_addHeightLayoutConstraintWithConstant:size.height withPriority:UILayoutPriorityDefaultLow];
    [view urbn_addWidthLayoutConstraingWithConstant:size.width withPriority:UILayoutPriorityDefaultLow];
    
    return view;
}

- (void)urbn_clearAllConstraints {
    [self removeConstraints:[self constraints]];
}

- (void)urbn_clearAllConstraintsForSubView:(UIView *)view {
    NSPredicate *firstItem = [NSPredicate predicateWithFormat:@"%K == %@", @"firstItem", view];
    NSPredicate *secondItem = [NSPredicate predicateWithFormat:@"%K == %@", @"secondItem", view];
    
    [self removeConstraints:[[self constraints] filteredArrayUsingPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:@[firstItem, secondItem]]]];
}

- (void)urbn_constrainViewEqual:(UIView *)view {
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *con1 = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *con2 = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *con3 = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:0 toItem:view attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    NSLayoutConstraint *con4 = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:0 toItem:view attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    NSArray *constraints = @[con1,con2,con3,con4];
    
    [self urbn_addAndIdentifyConstraints:constraints];
}

- (void)urbn_layoutAndInvalidateIntrinsicSize {
    [self layoutIfNeeded];
    [self invalidateIntrinsicContentSize];
}

- (UIView *)urbn_wrapInContainerViewWithView:(UIView *)container {
    return [self urbn_wrapInContainerViewWithView:container insets:UIEdgeInsetsZero];
}

- (UIView *)urbn_wrapInContainerViewWithView:(UIView *)container insets:(UIEdgeInsets)insets {
    if(container == nil) {
        container = [[UIView alloc] init];
        container.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    // Add ourself to the container
    [container addSubview:self];
    
    UIView *view = self;
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    NSDictionary *metrics = @{ @"left" : @(insets.left), @"right" : @(insets.right), @"top" : @(insets.top), @"bottom" : @(insets.bottom)};
    NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[view]-right-|" options:0 metrics:metrics views:views];
    NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[view]-bottom-|" options:0 metrics:metrics views:views];
    
    [container urbn_addAndIdentifyConstraints:h];
    [container urbn_addAndIdentifyConstraints:v];
    
    return container;
}

#pragma mark - Width Constraints
- (NSLayoutConstraint *)urbn_widthLayoutConstraint {
    return [self urbn_constraintForAttribute:NSLayoutAttributeWidth];
}

- (NSLayoutConstraint *)urbn_addWidthLayoutConstraingWithConstant:(CGFloat)constant {
    return [self urbn_addWidthLayoutConstraingWithConstant:constant withPriority:UILayoutPriorityRequired];
}

- (NSLayoutConstraint *)urbn_addWidthLayoutConstraingWithConstant:(CGFloat)constant withPriority:(UILayoutPriority)priority {
    return [self urbn_addConstraintForAttribute:NSLayoutAttributeWidth withConstant:constant withPriority:priority];
}

#pragma mark - Height Constraints
- (NSLayoutConstraint *)urbn_heightLayoutConstraint {
    return [self urbn_constraintForAttribute:NSLayoutAttributeHeight];
}

- (NSLayoutConstraint *)urbn_addHeightLayoutConstraintWithConstant:(CGFloat)constant {
    return [self urbn_addHeightLayoutConstraintWithConstant:constant withPriority:UILayoutPriorityRequired];
}

- (NSLayoutConstraint *)urbn_addHeightLayoutConstraintWithConstant:(CGFloat)constant withPriority:(UILayoutPriority)priority {
    return [self urbn_addConstraintForAttribute:NSLayoutAttributeHeight withConstant:constant withPriority:priority];
}

#pragma mark - General Constraints
- (void)urbn_addAndIdentifyConstraints:(NSArray *)constraints {
    [constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        [self urbn_identifyConstraint:obj];
    }];
    [self addConstraints:constraints];
}

- (NSLayoutConstraint *)urbn_constraintForAttribute:(NSLayoutAttribute)attribute {
    NSMutableArray *predicates = [NSMutableArray array];
    [predicates addObject:[NSPredicate predicateWithFormat:@"firstItem == %@", self]];
    [predicates addObject:[NSPredicate predicateWithFormat:@"firstAttribute == %i", attribute] ];
    if ([[NSLayoutConstraint new] respondsToSelector:@selector(identifier)]) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"identifier == %@", URBNConstraint_Identifier]];
    }
    
    NSMutableArray* constraintsToSearch = [NSMutableArray array];
    [constraintsToSearch addObjectsFromArray:self.superview.constraints];
    [constraintsToSearch addObjectsFromArray:self.constraints];
    return [[constraintsToSearch filteredArrayUsingPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:predicates]] firstObject];
}

- (NSLayoutConstraint *)urbn_addConstraintForAttribute:(NSLayoutAttribute)attribute withConstant:(CGFloat)constant withPriority:(UILayoutPriority)priority {
    return [self urbn_addConstraintForAttribute:attribute withItem:nil withConstant:constant withPriority:priority];
}

- (NSLayoutConstraint *)urbn_addConstraintForAttribute:(NSLayoutAttribute)attribute withItem:(id)item {
    return [self urbn_addConstraintForAttribute:attribute withItem:item withConstant:0.f];
}

- (NSLayoutConstraint *)urbn_addConstraintForAttribute:(NSLayoutAttribute)attribute withItem:(id)item withConstant:(CGFloat)constant {
    return [self urbn_addConstraintForAttribute:attribute withItem:item withConstant:constant withPriority:UILayoutPriorityDefaultHigh];
}

- (NSLayoutConstraint *)urbn_addConstraintForAttribute:(NSLayoutAttribute)attribute withItem:(id)item withConstant:(CGFloat)constant withPriority:(UILayoutPriority)priority {
    NSLayoutAttribute toAttribute = item ? attribute : NSLayoutAttributeNotAnAttribute;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:item attribute:toAttribute multiplier:1 constant:constant];
    
    constraint.priority = priority;
    [((UIView *)item ?: self) urbn_addAndIdentifyConstraints:@[constraint]];
    return constraint;
}

#pragma mark - Private
- (NSLayoutConstraint *)urbn_identifyConstraint:(NSLayoutConstraint *)constraint {
    SEL identifierSelector = @selector(identifier);
    if ([constraint respondsToSelector:identifierSelector]) {
        [constraint setValue:URBNConstraint_Identifier forKey:NSStringFromSelector(identifierSelector)];
    }
    return constraint;
}

@end