[![CI Status](http://img.shields.io/travis/urbn/URBNConvenience.svg?style=flat)](https://travis-ci.org/urbn/URBNConvenience)
[![Version](https://img.shields.io/cocoapods/v/URBNConvenience.svg?style=flat)](http://cocoadocs.org/docsets/URBNConvenience)
[![License](https://img.shields.io/cocoapods/l/URBNConvenience.svg?style=flat)](http://cocoadocs.org/docsets/URBNConvenience)
[![Platform](https://img.shields.io/cocoapods/p/URBNConvenience.svg?style=flat)](http://cocoadocs.org/docsets/URBNConvenience)

# URBNConvenience

A collection of useful Categories, Macros, and convenience functions we use in URBN apps.

## Usage

URBNConvenience classes may be individually imported on an as needed basis, or if you need all of them imported at once, you may import `URBNConvenience.h` which will bring with it all of the other classes currently in the URBNConvenience pod.

* __URBNConvenience:__ An umbrella framework header to be included when all URBNConvenience classes are needed. Also includes version information about URBNConvenience.

* __URBNFunctions:__ Convenience methods for things like app information, debug info, conversions, & async dispatching.

* __URBNMacros:__ Convenience macros for things like OS & device versions, logging, and assertions.

* __NSNotificationCenter+URBN:__ A category on `NSNotificationCenter` to remove the boiler plate around posting a notification on the main queue.

* __UITextField+URBNLoadingIndicator:__ A category on `UITextField` that displays a stock loading indicator as the `rightView` of the textfield.

* __UIView+URBNAnimations:__ A short and sweet category on `UIView` to quickly add cross dissolve animations to views. The default animation duration is 0.2 seconds.

* __UIView+URBNBorders:__ A simple category to add those pesky borders on any side of the UIView.   Each border has it's own color, width, and insets.

* __UIView+URBNLayout:__ A super useful category on `UIView` to expedite layout work with `UIView`’s. Includes methods for manual frame layout as well as auto layout.

* __URBNTextField:__ Because designers like text insets and padding, this subclass adds `edgeInsets`. These insets work with all `UITextField`’s subviews (text, editing, left view, clear button, & right view).

* __NSDate+URBN:__ A category on `NSDate` to get human-readable information about the duration between two dates.

* __UIImage+URBN:__ The current FP app has a lot of asset bloat. This category provides a way to cache/reuse image assets drawn with CoreGraphics.

* __NSString+URBN:__ A category on `NSString` that provides some convenient functions for finding substrings.


## Requirements

URBNConvenience has been tested on iOS 7 and up. Though it may work on lower deployment targets. ARC is required.

## Installation

URBNConvenience is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```
pod "URBNConvenience"
```

## License

URBNConvenience is available under the MIT license. See the LICENSE file for more info.

