//
//  ContainerViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
    case RightPanelExpanded
}

class ContainerViewController: UIViewController {
    
    var centerNavigationController: UINavigationController!
    var centerViewController: MainViewController!
    
    var currentState: SlideOutState = .BothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .BothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    
    var leftViewController: SidePanelViewController?
    var rightViewController: SidePanelViewController?
    
    let centerPanelExpandedOffset: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        
        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMoveToParentViewController(self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        else if(segue.identifier == "showDetails"){
//            
//            let detailsViewController:NotificationDetailsViewController = segue.destinationViewController as! NotificationDetailsViewController
//            
//            if(self.notifisViewControllerDelegate?.selectedNotificaion?.MESSAGETYPE == "FYI"){
//                detailsViewController.navigationItem.title = "info_purpose".localized
//            }
//            else if(self.notifisViewControllerDelegate?.selectedNotificaion?.MESSAGETYPE == "FYA"){
//                detailsViewController.navigationItem.title = "approve_purpose".localized
//                
//            }
//            detailsViewController.notificationsViewController = self.notifisViewControllerDelegate
//            
//        }
    }
    
}

// MARK: CenterViewController delegate

extension ContainerViewController: MainViewControllerDelegate {
    
    func toggleLeftPanel() {
        
        if ( NSUserDefaults.standardUserDefaults().objectForKey(Common.UserLanguage)!.integerValue == Language.English.rawValue ) {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
            animateLeftPanel(shouldExpand: notAlreadyExpanded)
        }
    }
    
    func toggleRightPanel() {
        
        if ( NSUserDefaults.standardUserDefaults().objectForKey(Common.UserLanguage)!.integerValue == Language.Arabic.rawValue ) {
        let notAlreadyExpanded = (currentState != .RightPanelExpanded)
        
        if notAlreadyExpanded {
            addRightPanelViewController()
        }
        
            animateRightPanel(shouldExpand: notAlreadyExpanded)
        }
    }
    
    func collapseSidePanels() {
        switch (currentState) {
        case .RightPanelExpanded:
            toggleRightPanel()
        case .LeftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }
    
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = UIStoryboard.leftViewController()
            leftViewController!.SideMenuItems = SideMenuItem.sideMenuList()
            
            addChildSidePanelController(leftViewController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: SidePanelViewController) {
        sidePanelController.delegate = centerViewController
    
        view.insertSubview(sidePanelController.view, atIndex: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func addRightPanelViewController() {
        if (rightViewController == nil) {
            rightViewController = UIStoryboard.rightViewController()
            rightViewController!.SideMenuItems = SideMenuItem.sideMenuList()
            
            addChildSidePanelController(rightViewController!)
        }
    }
    
    func animateLeftPanel(shouldExpand shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .BothCollapsed
                
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func animateRightPanel(shouldExpand shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .RightPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: -CGRectGetWidth(centerNavigationController.view.frame) + centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .BothCollapsed
                
                self.rightViewController!.view.removeFromSuperview()
                self.rightViewController = nil;
            }
        }
    }
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
}

extension ContainerViewController: UIGestureRecognizerDelegate {
    // MARK: Gesture recognizer
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
        
        switch(recognizer.state) {
        case .Began:
            if (currentState == .BothCollapsed) {
                if (gestureIsDraggingFromLeftToRight ) {
                    if (NSUserDefaults.standardUserDefaults().objectForKey(Common.UserLanguage)!.integerValue == Language.English.rawValue ) {
                        addLeftPanelViewController()
                    }
                } else {
                    if (NSUserDefaults.standardUserDefaults().objectForKey(Common.UserLanguage)!.integerValue == Language.Arabic.rawValue ) {
                        addRightPanelViewController()
                    }
                }
                
                showShadowForCenterViewController(true)
            }
        case .Changed:
            if ((NSUserDefaults.standardUserDefaults().objectForKey(Common.UserLanguage)!.integerValue == Language.English.rawValue && gestureIsDraggingFromLeftToRight)||currentState == .LeftPanelExpanded) {
                recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
                recognizer.setTranslation(CGPointZero, inView: view)
                
            } else if ((NSUserDefaults.standardUserDefaults().objectForKey(Common.UserLanguage)!.integerValue == Language.Arabic.rawValue && !gestureIsDraggingFromLeftToRight)||currentState == .RightPanelExpanded) {
                recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
                recognizer.setTranslation(                                               CGPointZero, inView: view)
                
            }
            
        case .Ended:
            if (leftViewController != nil) {
                // animate the side panel open or closed based on whether the view has moved more or less than halfway
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
                
            } else if (rightViewController != nil) {
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x < 0
                animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
                
            }
        default:
            break
        }
    }
}

private extension UIStoryboard {
    
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main_iPhone", bundle: NSBundle.mainBundle())
    }
    
    class func leftViewController() -> SidePanelViewController? {
        if ( NSUserDefaults.standardUserDefaults().objectForKey(Common.UserLanguage)!.integerValue == Language.English.rawValue ) {
            return mainStoryboard().instantiateViewControllerWithIdentifier("LeftViewController") as? SidePanelViewController
        }
        return nil
    }
    
    class func rightViewController() -> SidePanelViewController? {
        if ( NSUserDefaults.standardUserDefaults().objectForKey(Common.UserLanguage)!.integerValue == Language.Arabic.rawValue ) {
            return mainStoryboard().instantiateViewControllerWithIdentifier("RightViewController") as? SidePanelViewController
        }
        return nil
    }
    
    class func centerViewController() -> MainViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("MainViewController") as? MainViewController
    }
    
}