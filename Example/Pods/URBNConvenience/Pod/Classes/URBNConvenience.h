
#import <Foundation/Foundation.h>

//Categories
#import "NSDate+URBN.h"
#import "NSNotificationCenter+URBN.h"
#import "UIImage+URBN.h"
#import "UIView+URBNLayout.h"
#import "UIView+URBNAnimations.h"
#import "UITextField+URBNLoadingIndicator.h"
#import "NSString+URBN.h"

//Subclasses
#import "URBNTextField.h"

//Functions & Macros
#import "URBNFunctions.h"
#import "URBNMacros.h"


/**
 Umbrella framework header file, any files addded to the framework
 should be added here to be included when people #import "URBNConvenience.h"
 */

@interface URBNConvenience : NSObject

- (NSString *)version;

@end
