# URBNAlert

[![CI Status](http://img.shields.io/travis/urbn/URBNAlert.svg?style=flat)](https://travis-ci.org/urbn/URBNAlert)
[![Version](https://img.shields.io/cocoapods/v/URBNAlert.svg?style=flat)](http://cocoadocs.org/docsets/URBNAlert)
[![License](https://img.shields.io/cocoapods/l/URBNAlert.svg?style=flat)](http://cocoadocs.org/docsets/URBNAlert)
[![Platform](https://img.shields.io/cocoapods/p/URBNAlert.svg?style=flat)](http://cocoadocs.org/docsets/URBNAlert)

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage
After adding URBNAlert to your projects Podfile, import URBNAlert using the following import line:
#import URBNAlert

Setting Alert Style:
```
var alertStyler = AlertStyler()

// Blur Styling
alertStyler.blur.isEnabled = false
alertStyler.blur.tint = UIColor.red

// Button Styling
alertStyler.button.backgroundColor = UIColor.white
alertStyler.button.highlightBackgroundColor = .UIColor.lightGray
alertStyler.button.titleColor = UIColor.black

// Message Styling
alertStyler.message.color = UIColor.darkGray
alertStyler.message.backgroundColor = UIColor.white

// Assign styler to your alert
let alert = AlertViewController(message: “Alert Title”)
alert.alertStyler = alertStyler
```

1 Action Alert Example:
[<img src="https://imgur.com/a/q0AVpDn">]
```
let alert = AlertViewController(message: “Alert Title”)

let action = AlertAction(type: .custom, title: “Action Title”), completion: { _ in
    // Perform action here
}

alert.addActions([action])

alert.show()
```

2 Action Alert Example:
[<img src="https://imgur.com/65JHhII">]

3+ Action Alert Example:
[<img src="https://imgur.com/dRXt6J5">]

Custom View Alert Example:
[<img src="https://imgur.com/HnZbmK9">]
```
let imageView = UIImageView(image: UIImage.stretchableImage(color: .blue))
imageView.contentMode = .scaleAspectFit
imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true

let stackView = UIStackView(arrangedSubviews: [customLabel, imageView])
stackView.axis = .vertical
stackView.spacing = 10
let containerView = UIView()

containerView.widthAnchor.constraint(equalToConstant: view.frame.width - 2 * 30).isActive = true
containerView.embed(subview: stackView, insets: UIEdgeInsets(top: 0, left: 18, bottom: 18, right: 18))
```

Textfield Alert Example:
[<img src="https://imgur.com/MDwHzw3">]
```
let alert = AlertViewController(title: "Alert Title", message: sampleMessage)

alert.addTextfield { textField in
    textField.setStylesForAlert()
}

alert.addActions(action)
alert.show()
```

## Requirements


## Installation

URBNSwiftAlert is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "URBNSwiftAlert"
```

## Author

URBN Mobile Team, mobileteam@urbn.com

## License

URBNSwiftAlert is available under the MIT license. See the LICENSE file for more info.
