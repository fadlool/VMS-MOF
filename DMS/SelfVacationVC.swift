//
//  SelfVacationVC.swift
//  VMS
//
//  Created by Mohamed Fadl on 12/10/15.
//  Copyright © 2015 Compulink. All rights reserved.
//

import Foundation

class SelfVacationVC:UITableViewController{
    
    override func viewDidLoad() {
        let backButton:UIBarButtonItem  = UIBarButtonItem(title: "back".localized, style: UIBarButtonItemStyle.Done, target: self, action: "backTapped")
        self.navigationItem.leftBarButtonItem = backButton;
    
    }
    
    func backTapped(){
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // vacation request clicked
        NSLog(String(indexPath.section.hashValue))
        if(indexPath.section.hashValue == 0 ){
            self.performSegueWithIdentifier("show_req", sender: self)
        
        }else{
            
            let alertView:UIAlertView  = UIAlertView(title: nil, message: "not_activated".localized, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
            alertView.show()
        }
    }
}