//
//  NotificationDetailsViewController.swift
//  VMS
//
//  Created by Mohamed Fadl on 12/9/15.
//  Copyright © 2015 Compulink. All rights reserved.
//

import Foundation
import UIKit

class NotificationDetailsViewController:UITableViewController {
//    @IBOutlet weak var beginDateLabel: UILabel!
//    
//    @IBOutlet weak var toUserLabel: UILabel!
    @IBOutlet weak var employeeNameLabel: UILabel!
//    @IBOutlet weak var employeeNumberLabel: UILabel!
//    @IBOutlet weak var workGroupLabel: UILabel!
    
    @IBOutlet weak var vacationTypeLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var numberOfDaysLabel: UILabel!
    @IBOutlet weak var requestStatusLabel: UILabel!
    
    
    @IBOutlet weak var approveBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    var notificationsViewController:NotificationsViewController?
    
    @IBAction func closeBtnTapped(sender: AnyObject) {
        
        let selectedNotification:UserNotification = (self.notificationsViewController?.selectedNotificaion!)!
        
        let sessionManager:SessionManager = SessionManager.sharedSessionManager()
        let loginInfo:LoginInfo = sessionManager.loginInfo
        let services:Services = Services(viewController: self)
        services.cancelRequest(loginInfo.PUSERNAME, noteId: String(selectedNotification.NOTID))
    }
    @IBAction func approveBtnTapped(sender: AnyObject) {
        
        let selectedNotification:UserNotification = (self.notificationsViewController?.selectedNotificaion!)!
        
        let sessionManager:SessionManager = SessionManager.sharedSessionManager()
        let loginInfo:LoginInfo = sessionManager.loginInfo
        let services:Services = Services(viewController: self)
        services.approveRequest(loginInfo.PUSERNAME, noteId: String(selectedNotification.NOTID))
    }
    @IBAction func rejectBtnTapped(sender: AnyObject) {
        
        let selectedNotification:UserNotification = (self.notificationsViewController?.selectedNotificaion!)!
        
        let sessionManager:SessionManager = SessionManager.sharedSessionManager()
        let loginInfo:LoginInfo = sessionManager.loginInfo
        let services:Services = Services(viewController: self)
        services.rejectRequest(loginInfo.PUSERNAME, noteId: String(selectedNotification.NOTID))
    }
    func backTapped(){
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    override func viewDidLoad() {
        let backButton:UIBarButtonItem  = UIBarButtonItem(title: "back".localized, style: UIBarButtonItemStyle.Done, target: self, action: "backTapped")
        self.navigationItem.leftBarButtonItem = backButton;
        
        if(self.notificationsViewController?.selectedNotificaion?.MESSAGETYPE == "FYI"){
            self.navigationItem.title = "info_purpose".localized
            self.approveBtn.hidden = true
            self.cancelBtn.hidden = true
            self.closeBtn.hidden = false
        }
        else if(self.notificationsViewController?.selectedNotificaion?.MESSAGETYPE == "FYA"){
            self.navigationItem.title = "approve_purpose".localized
            
            self.closeBtn.hidden = true
            self.approveBtn.hidden = false
            self.cancelBtn.hidden = false
            
        }
    }
    override func viewWillAppear(animated: Bool) {
        let selectedNotification:UserNotification = (self.notificationsViewController?.selectedNotificaion!)!
        
//        let sessionManager:SessionManager = SessionManager.sharedSessionManager()
//        let loginInfo:LoginInfo = sessionManager.loginInfo
        
        self.vacationTypeLabel.text = selectedNotification.ABSENCETYPENAME
        self.startDateLabel.text = selectedNotification.STARTDATE
        self.endDateLabel.text = selectedNotification.ENDDATE
        self.numberOfDaysLabel.text = String(Int(selectedNotification.ABSENCEDAYS))
        self.requestStatusLabel.text = selectedNotification.SUBJECT
//        self.beginDateLabel.text = selectedNotification.BEGINDATEHIJ
        self.employeeNameLabel.text = selectedNotification.FROMUSERNAME
//        self.employeeNumberLabel.text = "غير متاح"
//        self.workGroupLabel.text = "غير متاح"
//        self.toUserLabel.text = selectedNotification.TOUSERNAME
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label:UILabel  = UILabel()
        label.backgroundColor=UIColor.clearColor()
        label.textAlignment=NSTextAlignment.Right
        label.textColor=UIColor.grayColor()
        
        
        if(section == 0){
            label.text = "emp_details".localized
        
        }else if(section == 1){
            label.text = "vacation_details".localized
        
        }
        return label
        
    }
}
