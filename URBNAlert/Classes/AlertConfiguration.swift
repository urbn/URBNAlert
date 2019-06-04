//
//  AlertConfiguration.swift
//  Pods
//
//  Created by Kevin Taniguchi on 5/22/17.
//
//
import CoreGraphics
import UIKit

public struct AlertConfiguration {
    /**
     *  Title text for the alert
     */
    public var title: String?
    
    /**
     *  Message text for the alert
     */
    public var message: String?
    
    /**
     *  The view to present from when using showInView:
     */
    public var presentationView: UIView?
    
    /**
     *  Duration of a passive alert (no buttons added)
     */
    public var duration: CGFloat?
    
    /**
     *  When set to true, you can touch outside of an alert to dismiss it
     */
    public var touchOutsideToDismiss = false
    
    /**
     *  When set to true, you can touch the alert's view (custom or standard) to dismiss it
     */
    public var tapInsideToDismiss = false
    
    /**
     *  When set to true, you can touch outside of an alert to dismiss it
     */
    public var alertViewButtonContainer: AlertButtonContainer?
    
    // Internal Variables
    var type = URBNSwAlertType.fullStandard
    var styler = AlertController.shared.alertStyler
    var textFields = [UITextField]()
    var customView: UIView?
    var customButtons: AlertButtonContainer?
    var actions = [AlertAction]()
    var textFieldInputs = [UITextField]()
    
    var isActiveAlert: Bool {
        let hasActiveAction = !actions.filter{$0.type != .passive}.isEmpty
        return hasActiveAction
    }
    
}
