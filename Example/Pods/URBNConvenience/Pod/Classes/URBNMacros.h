
/**
 *  Various macros for logging, assertions, and device / environment detection
 *
 */

@import UIKit;

#if (TARGET_OS_EMBEDDED || TARGET_OS_IPHONE)

#pragma mark - Environment
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_SCALE [[UIScreen mainScreen] scale]

#define IS_SIMULATOR TARGET_IPHONE_SIMULATOR

#define IS_RETINA (SCREEN_SCALE > 1) ? YES : NO
#define IS_RETINA_3X (SCREEN_SCALE >= 3 ? YES : NO)

#define IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPAD_1 (IS_IPAD && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_6 (SCREEN_HEIGHT == 667.0)
#define IS_IPHONE_6P (SCREEN_HEIGHT == 736.0)
#define IS_4IN (SCREEN_HEIGHT == 568)
#define IS_3_5IN (SCREEN_HEIGHT == 480)

#pragma mark - System Version
#define VERSION_GREATER_THAN(v1, v2)               ([v1 compare:v2 options:NSNumericSearch] == NSOrderedDescending)

#define SYSTEM_VERSION_EQUAL_TO(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)             ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_OS_8_OR_LATER     (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
#define IS_OS_7_OR_LATER     (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
#define IS_OS_6_OR_LATER     (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
#define IS_OS_5_1_OR_LATER   (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.1"))
#define IS_OS_5_0_1_OR_LATER (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0.1"))
#define IS_OS_5_0            (SYSTEM_VERSION_EQUAL_TO(@"5.0"))
#define IS_OS_5_OR_LATER     (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0"))
#define IS_PRIOR_TO_OS_5     (SYSTEM_VERSION_LESS_THAN(@"5.0"))
#define IS_OS_4_OR_LATER     (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"4.0"))
#define IS_OS_32_OR_LATER    (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"3.2"))

#endif

#pragma mark - Logging
#ifdef DEBUG

#define MARK        NSLog(@"%s", __PRETTY_FUNCTION__);
#define START_TIMER NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
#define END_TIMER(msg)                     NSTimeInterval stop = [NSDate timeIntervalSinceReferenceDate]; debugLog([NSString stringWithFormat:@"%@ Time = %f", msg, stop - start]);

#define errorLog(object)                   (NSLog(@"" @"%s:" # object @"Error! %@", __PRETTY_FUNCTION__, [object description]));

#define DLOG(object)                       (NSLog(@"" # object @" %d", object));
#define FLOG(object)                       (NSLog(@"" # object @" %f", object));
#define OBJECT_LOG(object)                 (NSLog(@"" @"%s:" # object @" %@", __PRETTY_FUNCTION__, [object description]));

#define POINTLOG(point)                    (NSLog(@""  # point @" x:%f y:%f", point.x, point.y));
#define SIZELOG(size)                      (NSLog(@""  # size @" width:%f height:%f", size.width, size.height));
#define RECTLOG(rect)                      (NSLog(@""  # rect @" x:%f y:%f w:%f h:%f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height));

#define SELECTOR_LOG      (NSLog(@"%@ in %s", NSStringFromSelector(_cmd), __FILE__));
#define METHOD_LOG        (NSLog(@"%@ %s\n%@", NSStringFromSelector(_cmd), __FILE__, self))
#define METHOD_LOG_THREAD (NSLog(@"%@ %@ %s\n%@", NSStringFromSelector(_cmd), [NSThread currentThread], __FILE__, self))

#else

#define MARK
#define START_TIMER
#define END_TIMER(msg)

#define DLOG(object)
#define FLOG(object)
#define OBJECT_LOG(object)

#define POINTLOG(point)
#define SIZELOG(size)
#define RECTLOG(rect)

#define SELECTOR_LOG
#define METHOD_LOG
#define METHOD_LOG_THREAD

#endif



#pragma mark - Assertions
#ifdef DEBUG

#define NOT_NIL_ASSERT(x)                  NSAssert4((x != nil), @"\n\n    ****  Unexpected Nil Assertion  ****\n    ****  " # x @" is nil.\nin file:%s at line %i in Method %@ with object:\n %@", __FILE__, __LINE__, NSStringFromSelector(_cmd), self)
#define NIL_ASSERT(x)                      NSAssert4((x == nil), @"\n\n    ****  Unexpected Non-Nil Assertion  ****\n    ****  " # x @" is non-nil.\nin file:%s at line %i in Method %@ with object:\n %@", __FILE__, __LINE__, NSStringFromSelector(_cmd), self)
#define ALWAYS_ASSERT     NSAssert4(0, @"\n\n    ****  Unexpected Assertion  **** \nAssertion in file:%s at line %i in Method %@ with object:\n %@", __FILE__, __LINE__, NSStringFromSelector(_cmd), self)
#define MSG_ASSERT(x)                      NSAssert5(0, @"\n\n    ****  Unexpected Assertion  **** \nReason: %@\nAssertion in file:%s at line %i in Method %@ with object:\n %@", x, __FILE__, __LINE__, NSStringFromSelector(_cmd), self)
#define MSG_ASSERT_TRUE(test, msg)         NSAssert5(test, @"\n\n    ****  Unexpected Assertion  **** \nReason: %@\nAssertion in file:%s at line %i in Method %@ with object:\n %@", msg, __FILE__, __LINE__, NSStringFromSelector(_cmd), self)

#define ASSERT_TRUE(test)                  NSAssert4(test, @"\n\n    ****  Unexpected Assertion  **** \nAssertion in file:%s at line %i in Method %@ with object:\n %@", __FILE__, __LINE__, NSStringFromSelector(_cmd), self)
#define ALWAYS_ASSERT_FUNCTION(...)  [[NSAssertionHandler currentHandler] handleFailureInFunction :[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file :[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber : __LINE__ description : __VA_ARGS__]

#else

#define NOT_NIL_ASSERT(x) NSLog(@"\n\n    ****  Unexpected Nil Assertion  ****\n    ****  " # x @" is nil.\nin file:%s at line %i in Method %@ with object:\n %@", __FILE__, __LINE__, NSStringFromSelector(_cmd), self)
#define NIL_ASSERT(x) NSLog(@"\n\n    ****  Unexpected Non-Nil Assertion  ****\n    ****  " # x @" is non-nil.\nin file:%s at line %i in Method %@ with object:\n %@", __FILE__, __LINE__, NSStringFromSelector(_cmd), self)
#define ALWAYS_ASSERT NSLog(@"\n\n    ****  Unexpected Assertion  **** \nAssertion in file:%s at line %i in Method %@ with object:\n %@", __FILE__, __LINE__, NSStringFromSelector(_cmd), self)
#define MSG_ASSERT(x) NSLog(@"\n\n    ****  Unexpected Assertion  **** \nReason: %@\nAssertion in file:%s at line %i in Method %@ with object:\n %@", x, __FILE__, __LINE__, NSStringFromSelector(_cmd), self)
#define MSG_ASSERT_TRUE(test, msg) NSLog(@"\n\n    ****  Unexpected Assertion  **** \nReason: %@\nAssertion in file:%s at line %i in Method %@ with object:\n %@", msg, __FILE__, __LINE__, NSStringFromSelector(_cmd), self)

#define ASSERT_TRUE(test) NSLog(@"\n\n    ****  Unexpected Assertion  **** \nAssertion in file:%s at line %i in Method %@ with object:\n %@", __FILE__, __LINE__, NSStringFromSelector(_cmd), self)
#define ALWAYS_ASSERT_FUNCTION(...)  NSLog(@"Assert In Function %s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])



#ifndef NS_BLOCK_ASSERTIONS
#define NS_BLOCK_ASSERTIONS
#endif

#endif /* ifdef DEBUG */
