//
//  AlertView.swift
//  Pods
//
//  Created by Kevin Taniguchi on 5/22/17.
//
//
import UIKit
import URBNSwiftyConvenience

public typealias EmptyHandler = () -> Void

class AlertView: UIView {
    fileprivate lazy var titleLabel = UILabel()
    fileprivate lazy var messageView = UITextView()
    fileprivate lazy var textFieldErrorLabel = UILabel()
    fileprivate let stackView = UIStackView()
    fileprivate lazy var buttonsSV = UIStackView()
    fileprivate lazy var buttonActions = [AlertAction]()
    fileprivate let separatorBorderView = UIView()
    var returnButtonHandler: EmptyHandler?
    var configuration: AlertConfiguration
    
    init(configuration: AlertConfiguration) {
        self.configuration = configuration
        
        super.init(frame: CGRect.zero)
        
        backgroundColor = configuration.styler.background.color
        layer.cornerRadius = configuration.styler.alert.cornerRadius
        layer.shadowRadius = configuration.styler.alertViewShadow.radius
        layer.shadowOpacity = configuration.styler.alertViewShadow.opacity
        layer.shadowOffset = configuration.styler.alertViewShadow.offset
        layer.shadowColor = configuration.styler.alertViewShadow.color.cgColor
        
        stackView.axis = .vertical
        
        var insets: UIEdgeInsets
        var spacing: CGFloat
        
        switch configuration.type {
        case .fullStandard:
            addStandardComponents()
            addButtons()
            insets = configuration.styler.alert.insets
            spacing = configuration.styler.alert.labelVerticalSpacing
        case .customButton:
            addStandardComponents()
            addCustomButtons()
            insets = configuration.styler.alert.insets
            spacing = configuration.styler.alert.labelVerticalSpacing
        case .customView:
            addStandardComponents()
            addCustomView()
            addButtons()
            insets = UIEdgeInsets.zero
            spacing = 0.0
        case .fullCustom:
            addCustomView()
            addCustomButtons()
            insets = UIEdgeInsets.zero
            spacing = 0.0
        }
        
        let separatorBorderStyle = configuration.styler.alert.alertSeparatorBorderStyle
        separatorBorderView.heightAnchor.constraint(equalToConstant: CGFloat(separatorBorderStyle.pixelWidth) / UIScreen.main.scale).isActive = true
        separatorBorderView.backgroundColor = separatorBorderStyle.color
        
        stackView.spacing = spacing
        embed(subview: stackView, insets: insets)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup and add UI
extension AlertView {
    func addStandardComponents() {
        
        if let title = configuration.title, !title.isEmpty {
            titleLabel.backgroundColor = configuration.styler.title.backgroundColor
            titleLabel.textAlignment = configuration.styler.title.alignment
            titleLabel.font = configuration.styler.title.font
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = .byWordWrapping
            titleLabel.textColor = configuration.styler.title.color
            titleLabel.text = title
            titleLabel.accessibilityIdentifier = "alertTitle"
            
            let titleInsetConstraints = configuration.styler.title.insetConstraints
            let titleContainer = UIView()
            titleContainer.embed(subview: titleLabel, insets: UIEdgeInsets(top: titleInsetConstraints.top.constant, left: titleInsetConstraints.left.constant, bottom: titleInsetConstraints.bottom.constant, right: titleInsetConstraints.right.constant))
            
            stackView.addArrangedSubview(titleContainer)
        }
        
        if let message = configuration.message, !message.isEmpty {
            messageView.backgroundColor = configuration.styler.message.backgroundColor
            messageView.textAlignment = configuration.styler.message.alignment
            messageView.font = configuration.styler.message.font
            messageView.textColor = configuration.styler.message.color
            messageView.isEditable = false
            messageView.text = message
            messageView.accessibilityIdentifier = "alertMessage"
            
            let buttonH = configuration.customButtons?.containerViewHeight ?? configuration.styler.button.height
            let maxTextViewH = UIScreen.main.bounds.height - titleLabel.intrinsicContentSize.height - 150.0 - (configuration.styler.alert.insets.top) * 2 - buttonH
            let maxWidth = UIScreen.main.bounds.width - (configuration.styler.alert.insets.left + configuration.styler.alert.insets.right) - configuration.styler.alert.horizontalMargin*2
            
            let messageSize = messageView.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
            let maxHeight = messageSize.height > maxTextViewH ? maxTextViewH : messageSize.height
            messageView.isScrollEnabled = messageSize.height > maxTextViewH
            messageView.heightAnchor.constraint(greaterThanOrEqualToConstant: maxHeight).isActive = true
            
            let messageContainer = UIView()
            let messageInsetConstraints = configuration.styler.message.insetConstraints
            messageContainer.embed(subview: messageView, insets: UIEdgeInsets(top: messageInsetConstraints.top.constant, left: messageInsetConstraints.left.constant, bottom: messageInsetConstraints.bottom.constant, right: messageInsetConstraints.right.constant))
            
            stackView.addArrangedSubview(messageContainer)
        }
        
        if !configuration.textFields.isEmpty {
            let textFieldsSV = UIStackView()
            
            configuration.textFields.forEach({ (tf) in
                if let height = configuration.styler.textField.height, height > 0 {
                    tf.heightAnchor.constraint(equalToConstant: height).isActive = true
                }
                
                textFieldsSV.addArrangedSubview(tf)
            })
            
            textFieldsSV.axis = .vertical
            textFieldsSV.spacing = configuration.styler.textField.verticalMargin
            for tf in configuration.textFields {
                tf.returnKeyType = .done
                tf.delegate = self
            }
            
            textFieldErrorLabel.numberOfLines = 0
            textFieldErrorLabel.lineBreakMode = .byWordWrapping
            textFieldErrorLabel.textColor = configuration.styler.textField.errorMessageColor
            textFieldErrorLabel.font = configuration.styler.textField.errorMessageFont
            textFieldsSV.addArrangedSubview(textFieldErrorLabel)
            textFieldErrorLabel.isHidden = true
            textFieldErrorLabel.accessibilityIdentifier = "alertTextFieldError"
            
            stackView.addArrangedSubview(textFieldsSV.wrapInNewView(with: InsetConstraints(insets: configuration.styler.textField.edgeInsets)))
        }
    }
    
    func addButtons() {
        // Only add the container if we have non-passive actions added
        guard configuration.actions.filter( { $0.type != AlertAction.ActionType.passive } ).count > 0 else { return }
        
        buttonsSV.axis = configuration.actions.count < 3 ? configuration.styler.button.layoutAxis : .vertical
        buttonsSV.distribution = .fillEqually
        buttonsSV.spacing = configuration.styler.button.spacing
        
        let buttonContainer = UIView()
        buttonContainer.backgroundColor = configuration.styler.button.buttonContainerBackgroundColor
        // Ensure the button container corner radius matches the base alerts radius
        buttonContainer.layer.cornerRadius = configuration.styler.alert.cornerRadius

        buttonsSV.wrap(in: buttonContainer, with: configuration.styler.button.containerInsetConstraints)
        let borderButtonSV = UIStackView(arrangedSubviews: [separatorBorderView, buttonContainer])
        borderButtonSV.axis = .vertical
        
        stackView.addArrangedSubviews(borderButtonSV)
    }
    
    func addCustomView() {
        if let customView = configuration.customView {
            stackView.addArrangedSubview(customView)
        }
    }
    
    func addCustomButtons() {
        if let customButtons = configuration.customButtons as? UIView {
            stackView.addArrangedSubview(customButtons)
        }
    }
}

extension AlertView: AlertButtonContainer {
    
    var actions: [AlertAction] {
        return buttonActions
    }
    
    public func show(errorMessage: String) {
        textFieldErrorLabel.isHidden = false
        textFieldErrorLabel.text = errorMessage
    }
    
    public func addActions(_ actions: [AlertAction]) {
        for action in actions {
            if action.type != .passive {
                let button = AlertButton(styler: configuration.styler, action: action)
                button.heightAnchor.constraint(equalToConstant: configuration.styler.button.height).isActive = true
                buttonsSV.addArrangedSubview(button)
                action.add(button: button)
            }
        }
    }
}

extension AlertView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charCount = textField.text?.count ?? 0
        if let charCount = textField.text?.count, range.length + range.location > charCount {
            return false
        }
        
        let newLength = charCount + string.count - range.length
        
        return newLength < configuration.styler.textField.maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        returnButtonHandler?()
        
        return false
    }
}

