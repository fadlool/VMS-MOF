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
        if(indexPath.row == 0){
            self.performSegueWithIdentifier("show_req", sender: self)
        
        }
    }
}