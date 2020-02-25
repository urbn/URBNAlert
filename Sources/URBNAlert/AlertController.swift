//
//  AlertController.swift
//  Pods
//
//  Created by Kevin Taniguchi on 5/22/17.
//
//
import UIKit

public class AlertController: NSObject {
    public static let shared = AlertController()
    public var alertStyler = AlertStyler()
    
    private var alertIsVisible = false
    private var queue: [AlertViewController] = []
    private var alertWindow: UIWindow?
    public var presentingWindow = UIApplication.shared.currentWindow ?? UIWindow(frame: UIScreen.main.bounds)
    
    // MARK: Queueing
    public func addAlertToQueue(avc: AlertViewController) {
        queue.append(avc)
        
        showNextAlert()
    }
    
    public func showNextAlert() {
        guard let nextAVC = queue.first, !alertIsVisible else { return }
        
        nextAVC.dismissingHandler = {[weak self] wasTouchedOutside in
            guard let strongSelf = self else { return }
            if wasTouchedOutside {
                strongSelf.dismiss(alertViewController: nextAVC)
            }
            
            if strongSelf.queue.isEmpty {
                strongSelf.alertWindow?.resignKey()
                strongSelf.alertWindow?.isHidden = true
                strongSelf.alertWindow = nil
                strongSelf.presentingWindow.makeKey()
            }
            
            if nextAVC.alertConfiguration.presentationView != nil {
                nextAVC.view.removeFromSuperview()
            }
        }
        
        if let presentationView = nextAVC.alertConfiguration.presentationView {
            var rect = nextAVC.view.frame
            rect.size.width = presentationView.frame.size.width
            rect.size.height = presentationView.frame.size.height
            nextAVC.view.frame = rect
            nextAVC.alertConfiguration.presentationView?.addSubview(nextAVC.view)
        }
        else {
            NotificationCenter.default.addObserver(self, selector: #selector(resignActive(note:)), name:  Notification.Name(rawValue: "UIWindowDidBecomeKeyNotification"), object: nil)
            setupAlertWindow()
            alertWindow?.rootViewController = nextAVC
            alertWindow?.makeKeyAndVisible()
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        if !nextAVC.alertConfiguration.isActiveAlert, let duration = nextAVC.alertConfiguration.duration {
            perform(#selector(dismiss(alertViewController:)), with: nextAVC, afterDelay: TimeInterval(duration))
        }
    }
    
    private func setupAlertWindow() {
        if alertWindow == nil {
            alertWindow = UIWindow(frame: UIScreen.main.bounds)
        }
        alertWindow?.windowLevel = UIWindow.Level.alert
        alertWindow?.isHidden = false
        alertWindow?.accessibilityIdentifier = "alertWindow"
        
        NotificationCenter.default.addObserver(self, selector: #selector(resignActive) , name:  Notification.Name(rawValue: "UIWindowDidBecomeKeyNotification")  , object: nil)
    }
    
    func popQueueAndShowNextIfNecessary() {
        alertIsVisible = false
        if !queue.isEmpty {
            _ = queue.removeFirst()
        }
        showNextAlert()
    }
    
    /// Conveinence to close alerts that are visible or in queue
    public func dismissAllAlerts() {
        queue.forEach { (avc) in
            avc.dismissAlert(sender: self)
        }
    }
    
    @objc func dismiss(alertViewController: AlertViewController) {
        alertIsVisible = false
        alertViewController.dismissAlert(sender: self)
    }
    
    /**
     *  Called when a new window becomes active.
     *  Specifically used to detect new alertViews or actionSheets so we can dismiss ourselves
     **/
    @objc func resignActive(note: Notification) {
        guard let noteWindow = note.object as? UIWindow, noteWindow != alertWindow, noteWindow != presentingWindow else { return }
        
        if let nextAVC = queue.first {
            dismiss(alertViewController: nextAVC)
        }
    }
}


extension UIApplication {
    
    var currentWindow: UIWindow? {
        windows.first(where: { $0.isKeyWindow })
    }
}
