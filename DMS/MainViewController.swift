//
//  MainViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit



@objc
protocol MainViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func toggleRightPanel()
    optional func collapseSidePanels()
}

class MainViewController: UIViewController,UIActionSheetDelegate,NotificationsViewControllerDelegate,UITabBarDelegate {
    
    @IBOutlet weak var noItemsLabel: UILabel!
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var noItemsView: UIView!
    @IBOutlet weak var topNavigationItem: UINavigationItem!
    var delegate: MainViewControllerDelegate?
    var notifisViewControllerDelegate: NotificationsViewController?
    
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {

        let x = item.tag
        
        switch x {
        case 0:
            
            self.noItemsLabel.hidden = true
            self.noItemsView.hidden = true
            self.topNavigationItem.title = "open_requests_title".localized
            notifisViewControllerDelegate?.startRefreshControl()
            break
        case 1:
            self.noItemsLabel.hidden = false
            self.noItemsView.hidden = false
            self.noItemsLabel.text = "not_activated".localized
            
            self.topNavigationItem.title = "medic_req".localized
//            let alertView:UIAlertView  = UIAlertView(title: nil, message: "not_activated".localized, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
//            alertView.show()
            break
        case 2:
            
            self.noItemsLabel.hidden = false
            self.noItemsView.hidden = false
            self.noItemsLabel.text = "not_activated".localized
            
            self.topNavigationItem.title = "delegate_req".localized
//            let alertView:UIAlertView  = UIAlertView(title: nil, message: "not_activated".localized, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
//            alertView.show()
            break
        default:
            
            self.noItemsLabel.hidden = false
            self.noItemsView.hidden = false
            self.noItemsLabel.text = "not_activated".localized
            self.topNavigationItem.title = "request".localized
//            let alertView:UIAlertView  = UIAlertView(title: nil, message: "not_activated".localized, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
//            alertView.show()
            break
        }
    }
    
    override func viewDidLoad() {
        
        self.tabBar.selectedItem = tabBar.items![0] as UITabBarItem;
        self.tabBar.delegate = self
        
        if(NSUserDefaults.standardUserDefaults().objectForKey(Common.UserLanguage)!.integerValue == Language.Arabic.rawValue){
            
            
            let  homeBarBtnItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "MenuIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: "sideMenuTapped")
            
            let topMenuBtnItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "topMenuTapped")
            
            self.topNavigationItem.rightBarButtonItems = [homeBarBtnItem]
            self.topNavigationItem.leftBarButtonItems = [topMenuBtnItem]
            
        }else{
            
        
        }
    
    }
    func didFinishLoading() {
        if(self.notifisViewControllerDelegate?.notificationsList != nil && self.notifisViewControllerDelegate?.notificationsList.count == 0){
            self.noItemsView.hidden = false
            self.noItemsLabel.text = "no_requests_found".localized
        }else{
            self.noItemsView.hidden = true
        
        }
    }
    func topMenuTapped(){
        
        let actionSheet:UIActionSheet  = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "cancel_dialog".localized, destructiveButtonTitle: nil, otherButtonTitles: "all_notifications".localized,"open_notifications".localized,"closed_notifications".localized,"cancelled_notifications".localized)

        actionSheet.showInView(self.view)

    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            //nop
            NSLog("Action sheet Cancel pressed -->  %ld" , buttonIndex);
            return;
        }
        let  buttonTitle:NSString = actionSheet.buttonTitleAtIndex(buttonIndex)!
        if(buttonTitle.isEqualToString("open_notifications".localized)) {
            if(self.notifisViewControllerDelegate != nil){
                self.notifisViewControllerDelegate?.status = "OPEN"
                self.notifisViewControllerDelegate?.startRefreshControl()
                self.topNavigationItem.title = "open_requests_title".localized
            }

            
        }else if(buttonTitle.isEqualToString("closed_notifications".localized)) {
            if(self.notifisViewControllerDelegate != nil){
                self.notifisViewControllerDelegate?.status = "CLOSED"
                self.notifisViewControllerDelegate?.startRefreshControl()
                self.topNavigationItem.title = "closed_requets_title".localized
            }
            
        }else if(buttonTitle.isEqualToString("cancelled_notifications".localized)) {
            if(self.notifisViewControllerDelegate != nil){
                self.notifisViewControllerDelegate?.status = "CANCELED"
                self.notifisViewControllerDelegate?.startRefreshControl()
                self.topNavigationItem.title = "canceled_requests_title".localized
            }
            
        }else if(buttonTitle.isEqualToString("all_notifications".localized)) {
            
            if(self.notifisViewControllerDelegate != nil){
                self.notifisViewControllerDelegate?.status = "ALL"
                self.notifisViewControllerDelegate?.startRefreshControl()
                self.topNavigationItem.title = "all_requests_title".localized
            }
    
        }
    }
    func sideMenuTapped() {
        
        if(NSUserDefaults.standardUserDefaults().objectForKey(Common.UserLanguage)!.integerValue == Language.Arabic.rawValue){
            delegate?.toggleRightPanel?()
        
        }else{
            delegate?.toggleLeftPanel?()
        
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "embedNotifsList"){
            self.notifisViewControllerDelegate = segue.destinationViewController as? NotificationsViewController
            self.notifisViewControllerDelegate!.mainViewController = self
            self.notifisViewControllerDelegate?.delegate = self

        }
        else if(segue.identifier == "showDetails"){
            
            let naviCtrlr:UINavigationController = segue.destinationViewController as! UINavigationController
            let rootViewController = naviCtrlr.viewControllers.first
            
            let detailsViewController:NotificationDetailsViewController = rootViewController as! NotificationDetailsViewController
            
            if(self.notifisViewControllerDelegate?.selectedNotificaion?.MESSAGETYPE == "FYI"){
                detailsViewController.navigationItem.title = "info_purpose".localized

            }
            else if(self.notifisViewControllerDelegate?.selectedNotificaion?.MESSAGETYPE == "FYA"){
                detailsViewController.navigationItem.title = "approve_purpose".localized
                
            
            }
            detailsViewController.notificationsViewController = self.notifisViewControllerDelegate
        
        }
    }
    
}

extension MainViewController: SidePanelViewControllerDelegate,UIAlertViewDelegate {
    func sideMenuItemSelected(sideMenuItem: SideMenuItem) {
       
        if(sideMenuItem.order == Common.MenuProfileOrder){
            self.performSegueWithIdentifier("show_profile", sender: self)
            
        }else if sideMenuItem.order == Common.MenuLogoutOrder{
            
            let alert:UIAlertView
            alert = UIAlertView(title:"confirm_msg".localized, message: "logout_confirm".localized, delegate: self, cancelButtonTitle: "cancel_dialog".localized, otherButtonTitles: "ok_dialog".localized)
            
            CustomAlertViewDelegate.showAlertView(alert) { (alertView, buttonIndex) -> Void in
                if(alertView.buttonTitleAtIndex(buttonIndex) == "ok_dialog".localized){
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            
            
        }else if sideMenuItem.order == Common.MenuSelfVacationOrder{
            self.performSegueWithIdentifier("showSelfVacation", sender: self)
            
        }else{
            
            let alertView:UIAlertView  = UIAlertView(title: nil, message: "not_activated".localized, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
            alertView.show()
        }
        
        delegate?.collapseSidePanels?()
    }
}