//
//  AlertButton.swift
//  Pods
//
//  Created by Kevin Taniguchi on 5/23/17.
//
//
import CoreGraphics
import UIKit

/**
 *  Conform a UIView to this protocol to generate a custom view that holds custom buttons
 */
public protocol AlertButtonContainer: class {
    var containerViewHeight: CGFloat { get }
    var actions: [AlertAction] { get }
}

public extension AlertButtonContainer where Self: UIView {
    var containerViewHeight: CGFloat {
        return frame.height
    }
}

public class AlertButton: UIButton {
    let styler: AlertStyler
    let action: AlertAction
    
    init(styler: AlertStyler, action: AlertAction) {
        self.styler = styler
        self.action = action
        
        super.init(frame: CGRect.zero)
        
        setTitle(action.title, for: .normal)
        
        setTitleColor(styler.buttonTitleColor(actionType: action.type, isEnabled: isEnabled), for: .normal)
        setTitleColor(styler.buttonHighlightTitleColor(actionType: action.type, isEnabled: isEnabled), for: .highlighted)
        setTitleColor(styler.button.selectedTitleColor, for: .selected)
        backgroundColor = styler.buttonBackgroundColor(actionType: action.type, isEnabled: action.isEnabled)
        titleLabel?.font = styler.button.font
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = styler.button.minimumScaleFactor
        layer.cornerRadius = styler.button.cornerRadius
        layer.borderWidth = styler.button.borderWidth
        layer.borderColor = styler.button.borderColor.cgColor
        layer.shadowOpacity = styler.button.shadowOpacity
        layer.shadowRadius = styler.button.shadowRadius
        layer.shadowColor = styler.button.shadowColor.cgColor
        layer.shadowOffset = styler.button.shadowOffset
        contentEdgeInsets = styler.button.contentInsets
        accessibilityIdentifier = "alertButton"
    }
    
    public override var isHighlighted: Bool {
        didSet {
            switch action.type {
            case .destructive:
                backgroundColor = isHighlighted ? styler.destructiveButton.highlightBackgroundColor : styler.destructiveButton.backgroundColor
            case .cancel:
                backgroundColor = isHighlighted ? styler.cancelButton.highlightBackgroundColor : styler.cancelButton.backgroundColor
            case .custom, .normal, .passive:
                backgroundColor = isHighlighted ? styler.button.highlightBackgroundColor : styler.button.backgroundColor
            }
        }
    }
    
    public override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? styler.button.selectedBackgroundColor : styler.buttonBackgroundColor(actionType: action.type, isEnabled: isEnabled)
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            setTitleColor(styler.buttonTitleColor(actionType: action.type, isEnabled: isEnabled), for: .normal)
            setTitleColor(styler.buttonHighlightTitleColor(actionType: action.type, isEnabled: isEnabled), for: .highlighted)
            backgroundColor = styler.buttonBackgroundColor(actionType: action.type, isEnabled: isEnabled)
            alpha = isEnabled ? 1.0 : styler.disabledButton.alpha
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
