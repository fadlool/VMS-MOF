//
//  NotificationsViewController.swift
//  VMS
//
//  Created by Mohamed Fadl on 12/7/15.
//  Copyright © 2015 Compulink. All rights reserved.
//

import Foundation
import UIKit

@objc
protocol NotificationsViewControllerDelegate {
    optional func didFinishLoading()
}

class NotificationsViewController: UITableViewController {
    
    var notificationsList:NSMutableArray = []
    
    var mwTopRefreshControl:UIRefreshControl?
    var mwBottomRefreshControl:UIRefreshControl?
    var moreResultsAvail:Bool = false
    var loading:Bool = false
    var currentPage:Int = 0
    
    var editMode:Bool = false
    var refreshBar:UIRefreshControl?
    
    var mainViewController:MainViewController?
    var status:String = "OPEN"
    
    var delegate: NotificationsViewControllerDelegate?
    
    var selectedNotificaion:UserNotification?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations.
        // self.clearsSelectionOnViewWillAppear = NO;
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
        
        // Pull to refresh
        self.refreshBar = UIRefreshControl()
        self.refreshBar!.tintColor = UIColor.darkTextColor()
        
        self.refreshBar?.addTarget(self, action: "refreshView:", forControlEvents: UIControlEvents.ValueChanged)
        
        
        self.tableView.addSubview(self.refreshBar!)
        
        self.mwTopRefreshControl =  self.refreshBar;
//        self.mwBottomRefreshControl = self.refreshBar;
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.startRefreshControl()
        
    }
    
    func refreshView(refresh:UIRefreshControl ) {
        // custom refresh logic would be placed here...
        self.loadLatestNotifications()
    }
    
    func startRefreshControl(){
        
        self.mwTopRefreshControl?.beginRefreshing()
          self.tableView.backgroundColor =  UIColor(red: 0.91, green: 0.89, blue: 0.78, alpha: 1.0)
        self.tableView.setContentOffset(CGPointMake(0, -self.mwTopRefreshControl!.frame.size.height), animated:true)
        self.refreshView(self.mwTopRefreshControl!)
    }
    
    func stopRefreshControl(){
        self.delegate?.didFinishLoading!()
        self.mwTopRefreshControl?.endRefreshing()
    }
    
   
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
            let v:UIView = UIView()
            v.backgroundColor = UIColor(red: 0.91, green: 0.89, blue: 0.78, alpha: 1.0)
            return v;
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return  self.notificationsList.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:NotificationCell = tableView.dequeueReusableCellWithIdentifier("notification_cell") as! NotificationCell
        
        let customColorView:UIView  = UIView()
        customColorView.backgroundColor =  UIColor(red: 0.91, green: 0.89, blue: 0.78, alpha: 1.0)
        cell.selectedBackgroundView =  customColorView
        NSLog(String(indexPath.section.hashValue))
        if(indexPath.section.hashValue < self.notificationsList.count){
            let contentItem:UserNotification = self.notificationsList.objectAtIndex(indexPath.section.hashValue) as! UserNotification
            
            // Configure the cell...
            cell.notificationTitleLabel.text = contentItem.SUBJECT
            cell.dateLabel.text = contentItem.BEGINDATEHIJ
            cell.backgroundColor = UIColor.whiteColor()
            cell.layer.borderColor = UIColor.lightTextColor().CGColor
            cell.layer.borderWidth = 1
            cell.clipsToBounds = true
            
        }
        
        
        cell.tag = indexPath.row;
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.mainViewController!.performSegueWithIdentifier("showDetails", sender: self.mainViewController)
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        self.selectedNotificaion = self.notificationsList.objectAtIndex(indexPath.row) as? UserNotification
        
    }
    
    func loadLatestNotifications(){
        
        self.notificationsList.removeAllObjects()
        self.tableView!.reloadData()
        
        self.currentPage = 0;
        
        self.loading = true
        
        let sessionManager:SessionManager = SessionManager.sharedSessionManager()
        let loginInfo:LoginInfo = sessionManager.loginInfo
        
        let services:Services = Services(viewController: self)
        
        services.getUserNotifications(loginInfo.PUSERNAME, status: self.status)
    
    }
}
