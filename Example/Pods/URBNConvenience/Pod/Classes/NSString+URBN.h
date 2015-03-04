//
//  NSString+URBN.h
//  Pods
//
//  Created by Ray Migneco on 1/23/15.
//
//

#import <Foundation/Foundation.h>

@interface NSString (URBN)

- (BOOL)urbn_containsString:(NSString *)string;
- (BOOL)urbn_containsCaseInsensitiveString:(NSString *)string;

@end
