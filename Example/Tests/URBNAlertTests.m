//
//  URBNAlertTests.m
//  URBNAlert
//
//  Created by Ryan Garchinsky on 3/9/15.
//  Copyright (c) 2015 Ryan Garchinsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <URBNAlert/URBNAlertController.h>

@interface URBNAlertTests : XCTestCase

@property (nonatomic, strong) URBNAlertController *alertController;

@end

@implementation URBNAlertTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.alertController = [URBNAlertController sharedInstance];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBlurAlphaComponent {
    URBNAlertStyle *alertStyle = [URBNAlertStyle new];
    alertStyle.blurTintColor = [UIColor blackColor];
    [self.alertController setAlertStyler:alertStyle];
    XCTAssertThrows([self.alertController showPassiveAlertWithTitle:@"" message:@"" touchOutsideToDismiss:NSOSF1OperatingSystem alertDismissedBlock:^(URBNAlertController *alertController, BOOL alertWasTouched) {}]);
    
    alertStyle.blurTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    [self.alertController setAlertStyler:alertStyle];
    XCTAssertNoThrow([self.alertController showPassiveAlertWithTitle:@"" message:@"" touchOutsideToDismiss:NSOSF1OperatingSystem alertDismissedBlock:^(URBNAlertController *alertController, BOOL alertWasTouched) {}]);
}

- (void)testActiveAlert {
    // Test no completion block
    XCTAssertThrows([self.alertController showActiveAlertWithTitle:@"" message:@"" hasInput:YES buttonTitles:@[@""] touchOutsideToDismiss:YES buttonTouchedBlock:nil]);
    
    // Test 0 or no buttonTitles
    NSArray *btnTitles = @[];
    XCTAssertThrows([self.alertController showActiveAlertWithTitle:@"" message:@"" hasInput:YES buttonTitles:btnTitles touchOutsideToDismiss:YES buttonTouchedBlock:^(URBNAlertController *alertController, NSInteger index){}]);
    btnTitles = nil;
    XCTAssertThrows([self.alertController showActiveAlertWithTitle:@"" message:@"" hasInput:YES buttonTitles:btnTitles touchOutsideToDismiss:YES buttonTouchedBlock:^(URBNAlertController *alertController, NSInteger index){}]);
    
    // Test 3 or more buttonTitles
    btnTitles = @[@"", @"", @""];
    XCTAssertThrows([self.alertController showActiveAlertWithTitle:@"" message:@"" hasInput:YES buttonTitles:btnTitles touchOutsideToDismiss:YES buttonTouchedBlock:^(URBNAlertController *alertController, NSInteger index){}]);
    
    // Test 1-2 buttons
    btnTitles = @[@""];
    XCTAssertNoThrow([self.alertController showActiveAlertWithTitle:@"" message:@"" hasInput:YES buttonTitles:btnTitles touchOutsideToDismiss:YES buttonTouchedBlock:^(URBNAlertController *alertController, NSInteger index){}]);
    btnTitles = @[@"", @""];
    XCTAssertNoThrow([self.alertController showActiveAlertWithTitle:@"" message:@"" hasInput:YES buttonTitles:btnTitles touchOutsideToDismiss:YES buttonTouchedBlock:^(URBNAlertController *alertController, NSInteger index){}]);
    
    // Test custom view
    XCTAssertThrows([self.alertController showActiveAlertWithView:nil buttonTitles:btnTitles touchOutsideToDismiss:YES buttonTouchedBlock:^(URBNAlertController *alertController, NSInteger index){}]);
    XCTAssertNoThrow([self.alertController showActiveAlertWithView:[UIView new] buttonTitles:btnTitles touchOutsideToDismiss:YES buttonTouchedBlock:^(URBNAlertController *alertController, NSInteger index){}]);
}

- (void)testPassiveAlert {
    XCTAssertThrows([self.alertController showPassiveAlertWithView:nil touchOutsideToDismiss:YES duration:2.0f alertDismissedBlock:^(URBNAlertController *alertController, BOOL alertWasTouched){}]);
    XCTAssertNoThrow([self.alertController showPassiveAlertWithView:[UIView new] touchOutsideToDismiss:YES duration:2.0f alertDismissedBlock:^(URBNAlertController *alertController, BOOL alertWasTouched){}]);
}

@end
