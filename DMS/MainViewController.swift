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

class MainViewController: UIViewController,UIActionSheetDelegate,NotificationsViewControllerDelegate {
    
    
    @IBOutlet weak var noItemsView: UIView!
    @IBOutlet weak var topNavigationItem: UINavigationItem!
    var delegate: MainViewControllerDelegate?
    var notifisViewControllerDelegate: NotificationsViewController?
    override func viewDidLoad() {
        
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
//                detailsViewController.approveBtn.hidden = true
//                detailsViewController.cancelBtn.hidden = true
//                detailsViewController.closeBtn.hidden = false
            }
            else if(self.notifisViewControllerDelegate?.selectedNotificaion?.MESSAGETYPE == "FYA"){
                detailsViewController.navigationItem.title = "approve_purpose".localized
                
//                detailsViewController.closeBtn.hidden = true
//                detailsViewController.approveBtn.hidden = false
//                detailsViewController.cancelBtn.hidden = false
            
            }
            detailsViewController.notificationsViewController = self.notifisViewControllerDelegate
        
        }
    }
    
}

extension MainViewController: SidePanelViewControllerDelegate {
    func sideMenuItemSelected(sideMenuItem: SideMenuItem) {
       
        if(sideMenuItem.order == Common.MenuProfileOrder){
            
            let sessionManager:SessionManager = SessionManager.sharedSessionManager()
            let loginInfo:LoginInfo = sessionManager.loginInfo
            
            let services:Services = Services(viewController: self)
            services.getUserInfo(loginInfo.PUSERNAME)
        }
        else if(sideMenuItem.order ==  Common.MenuIdentityReqOrder){
            print("The letter A")
        }else if sideMenuItem.order == Common.MenuLogoutOrder{
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
       
        
        
        delegate?.collapseSidePanels?()
    }
}