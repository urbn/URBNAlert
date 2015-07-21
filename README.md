[![CI Status](http://img.shields.io/travis/urbn/URBNAlert.svg?style=flat)](https://travis-ci.org/urbn/URBNAlert)
[![Version](https://img.shields.io/cocoapods/v/URBNAlert.svg?style=flat)](http://cocoadocs.org/docsets/URBNAlert)
[![License](https://img.shields.io/cocoapods/l/URBNAlert.svg?style=flat)](http://cocoadocs.org/docsets/URBNAlert)
[![Platform](https://img.shields.io/cocoapods/p/URBNAlert.svg?style=flat)](http://cocoadocs.org/docsets/URBNAlert)

# URBNAlert
![enter image description here](http://i.imgur.com/ld1gOPNm.png?1)![enter image description here](http://i.imgur.com/CkRD0OLm.png?1)![enter image description here](http://i.imgur.com/XcitAMzm.png?1)![enter image description here](http://i.imgur.com/RTsTzI4m.png?1)

URBNAlert is a customizable alert view based off of iOS's UIAlertController.

UIAlertController was a great improvement over UIAlertView, but you still cannot apply custom fonts, colors, or other styles to the alerts. URBNAlert gives you that flexability.

You can also pass custom `UIView`'s into a URBNAlert, and create passive alerts with no buttons that dismiss after a period of time.

## Usage

After adding URBNALERT to your projects Podfile, import URBNAlert using the following import line:

`#import <URBNAlert/URBNAlert.h>`

Checkout & run the pod's example project to see what URBNAlert is capable of.

### Special Note: To support background blur on iPhone 6 or 6+, you need to include a Launch image or xib that supports those devices.
During bluring of the background, there seems to be an issue with Apple’s `drawViewHierarchyInRect:afterScreenUpdates:` when `afterScreenUpdates = YES`. If no launch image or xib is supplied for the iPhone 6 or 6+, `drawViewHierarchyInRect:afterScreenUpdates:` will resize the view briefly and cause an animation artifact. To properly support background blur on those devices, a Launch image or xib must be included.

#####Setting a global alert stlyle:
```objective-c
// Set global stlying. This can be done sometime during app launch. You can change style options per alert as well.
URBNAlertController *alertController = [URBNAlertController sharedInstance];
alertController.alertStyler.buttonBackgroundColor = [UIColor blueColor];
alertController.alertStyler.buttonDestructionBackgroundColor = [UIColor greenColor];
alertController.alertStyler.backgroundColor = [UIColor greyColor];
alertController.alertStyler.titleFont = [UIFont fontWithName@"" size:14.f]; 
```

#####Basic Active Alert (2 buttons)
```objective-c
URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"The Title of my message can be up to 2 lines long. It wraps and centers." message:@"And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text."];

// You can customize style elements per alert as well. These will override the global style just for this alert.
uac.alertStyler.blurTintColor = [[UIColor orangeColor] colorWithAlphaComponent:0.4];
uac.alertStyler.backgroundColor = [UIColor orangeColor];

[uac addAction:[URBNAlertAction actionWithTitle:@"Button 1" actionType:URBNAlertActionTypeNormal actionCompleted:^(URBNAlertAction *action) {
      // URBNAlertActionTypeNormal is triggered when the user touches the button specified by this action
}]];

[uac addAction:[URBNAlertAction actionWithTitle:@"Button 2" actionType:URBNAlertActionTypeNormal actionCompleted:^(URBNAlertAction *action) {
      // Do something
}]];
    
[uac show];
```

#####Active Alert with UITextField
```objective-c
URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"Input Alert" message:@"Message and message and message and going on forever and ever. Message and message and message and going on forever and ever. Message and message and message and going on forever and ever. Message and message and message and going on forever and ever. and message and message and going on forever and ever." view:nil];
    
[uac addAction:[URBNAlertAction actionWithTitle:@"Done" actionType:URBNAlertActionTypeNormal actionCompleted:^(URBNAlertAction *action) {
    NSLog(@"input: %@", uac.textField.text);
}]];
    
[uac addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"e-mail";
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = UIKeyboardTypeEmailAddress;
}];
    
[uac show];
```

#####Basic Passive Alert
```objective-c
URBNAlertViewController *uac = [[URBNAlertViewController alloc] initWithTitle:@"The Title of my message can be up to 2 lines long. It wraps and centers." message:@"And the message that is a bunch of text. And the message that is a bunch of text. And the message that is a bunch of text."];
uac.alertConfig.touchOutsideViewToDismiss = YES; // Touching outside the alert view will dismiss the alert (only for passive alerts)
uac.alertConfig.duration = 2.0f; // Duration the alert appears (default calculates time based on the amount of text in the title and message. For passive alerts only)
uac.alertStyler.blurEnabled = @NO;

[uac addAction:[URBNAlertAction actionWithTitle:nil actionType:URBNAlertActionTypePassive actionCompleted:^(URBNAlertAction *action) {
    // URBNAlertActionTypePassive is triggered when the user taps on the actual alert view only for passive. Do something here, ie push a new view controller. For passive alerts only.
}]];
    
[uac show];
```

#####Limitations
At the moment, URBNAlert only supports the following:
- Up to 2 buttons for an active alert

Please create an issue for any additional support needed.

## Requirements

- iOS 7+

## Installation

URBNAlert is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "URBNAlert"

## Author

URBN Mobile Team, mobileteam@urbn.com

## License

URBNAlert is available under the MIT license. See the LICENSE file for more info.

