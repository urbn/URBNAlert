//
//  URBNAlertTests.m
//  URBNAlert
//
//  Created by Ryan Garchinsky on 3/9/15.
//  Copyright (c) 2015 Ryan Garchinsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <URBNAlert/URBNAlert.h>

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
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"Title" message:@"Message"];
    uac.alertStyler.blurTintColor = [UIColor redColor];
    XCTAssertThrows([uac show]);
    
    URBNAlertViewController *uac2 = [[URBNAlertViewController alloc] initWithTitle:@"Title" message:@"Message"];
    uac2.alertStyler.blurTintColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    XCTAssertNoThrow([uac2 show]);
}

- (void)testActiveAlert {
    // Test no completion block
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"Title" message:@"Message"];
    [uac addAction:[URBNAlertAction actionWithTitle:@"btn" actionType:URBNAlertActionTypeNormal actionCompleted:nil]];
    XCTAssertNoThrow([uac show]);
    
    // Test with completion block
    uac = [[URBNAlertViewController alloc] initWithTitle:@"Title" message:@"Message"];
    [uac addAction:[URBNAlertAction actionWithTitle:@"btn" actionType:URBNAlertActionTypeNormal actionCompleted:^(URBNAlertAction *action) {
    }]];
    XCTAssertNoThrow([uac show]);
    
    // Test 3 or more buttonTitles
    uac = [[URBNAlertViewController alloc] initWithTitle:@"Title" message:@"Message"];
    [uac addAction:[URBNAlertAction actionWithTitle:@"btn1" actionType:URBNAlertActionTypeNormal actionCompleted:nil]];
    [uac addAction:[URBNAlertAction actionWithTitle:@"btn2" actionType:URBNAlertActionTypeNormal actionCompleted:nil]];
    XCTAssertThrows([uac addAction:[URBNAlertAction actionWithTitle:@"btn3" actionType:URBNAlertActionTypeNormal actionCompleted:nil]]);
    
    //Test 2 buttons
    uac = [[URBNAlertViewController alloc] initWithTitle:@"Title" message:@"Message"];
    [uac addAction:[URBNAlertAction actionWithTitle:@"btn" actionType:URBNAlertActionTypeNormal actionCompleted:^(URBNAlertAction *action) {
    }]];
    [uac addAction:[URBNAlertAction actionWithTitle:@"btn2" actionType:URBNAlertActionTypeNormal actionCompleted:^(URBNAlertAction *action) {
    }]];
    XCTAssertNoThrow([uac show]);
    
    // Test nil custom view
    uac = [[URBNAlertViewController alloc] initWithTitle:@"Title" message:@"Message" view:nil];
    [uac addAction:[URBNAlertAction actionWithTitle:@"btn" actionType:URBNAlertActionTypeNormal actionCompleted:nil]];
    XCTAssertNoThrow([uac show]);
    
    // Test custom view
    uac = [[URBNAlertViewController alloc] initWithTitle:@"Title" message:@"Message" view:[UIView new]];
    [uac addAction:[URBNAlertAction actionWithTitle:@"btn" actionType:URBNAlertActionTypeNormal actionCompleted:nil]];
    XCTAssertNoThrow([uac show]);
    
    // Test nil title & message
    uac = [[URBNAlertViewController alloc] initWithTitle:nil message:nil];
    [uac addAction:[URBNAlertAction actionWithTitle:@"btn" actionType:URBNAlertActionTypeNormal actionCompleted:nil]];
    XCTAssertNoThrow([uac addTextFieldWithConfigurationHandler:nil]);
}

- (void)testPassiveAlert {
    // Show simple passive alert
    URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"Title" message:@"Message"];
    uac.alertConfig.touchOutsideViewToDismiss = YES;
    uac.alertConfig.duration = 2.f;
    XCTAssertNoThrow([uac show]);
    
    // Action block (view touched)
    uac = [[URBNAlertViewController alloc] initWithTitle:@"Title" message:@"Message"];
    [uac addAction:[URBNAlertAction actionWithTitle:@"" actionType:URBNAlertActionTypePassive actionCompleted:^(URBNAlertAction *action) {
    }]];
    XCTAssertNoThrow([uac show]);
    
    // Action block (view touched) nil
    uac = [[URBNAlertViewController alloc] initWithTitle:@"Title" message:@"Message"];
    [uac addAction:[URBNAlertAction actionWithTitle:@"" actionType:URBNAlertActionTypePassive actionCompleted:nil]];
    XCTAssertNoThrow([uac show]);
    
    // nil title and message
    uac = [[URBNAlertViewController alloc] initWithTitle:nil message:nil];
    XCTAssertNoThrow([uac show]);
    
    // nil view
    uac = [[URBNAlertViewController alloc] initWithTitle:nil message:nil view:nil];
    XCTAssertNoThrow([uac show]);
    
    // non-nil view
    uac = [[URBNAlertViewController alloc] initWithTitle:nil message:nil view:[UIView new]];
    XCTAssertNoThrow([uac show]);
}

@end
