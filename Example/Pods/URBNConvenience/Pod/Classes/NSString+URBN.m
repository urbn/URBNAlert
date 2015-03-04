//
//  NSString+URBN.m
//  Pods
//
//  Created by Ray Migneco on 1/23/15.
//
//

#import "NSString+URBN.h"
#import "URBNMacros.h"

@implementation NSString (URBN)

- (BOOL)urbn_containsString:(NSString *)string {
    return ([self urbn_containsString:string withCaseOption:0]);
}

- (BOOL)urbn_containsCaseInsensitiveString:(NSString *)string {
    return ([self urbn_containsString:string withCaseOption:NSCaseInsensitiveSearch]);
}

- (BOOL)urbn_containsString:(NSString *)string withCaseOption:(NSStringCompareOptions)option {
    NSAssert((string != nil), @"String must be non-nil");
    return (!([self rangeOfString:string options:option].location == NSNotFound));
}

@end
