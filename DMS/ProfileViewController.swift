//
//  ProfileViewController.swift
//  VMS
//
//  Created by Mohamed Fadl on 12/4/15.
//  Copyright © 2015 Compulink. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController,UINavigationControllerDelegate {
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var orgLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var ministryJoinDtLabel: UILabel!
    @IBOutlet weak var govJoinDtLabel: UILabel!
    @IBOutlet weak var empNumberLabel: UILabel!
    override func viewDidLoad() {
        
    }
    
//    -(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//    {
//    UILabel *label = [[UILabel alloc] init];
//    label.text=@"header title";
//    label.backgroundColor=[UIColor clearColor];
//    label.textAlignment=UITextAlignmentRight;
//    return label;
//    }
//    
//    -(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//    {
//    return 50;
//    }
    override func viewWillAppear(animated: Bool) {
        let sessionManager:SessionManager = SessionManager.sharedSessionManager()
        let userInfo:UserInfo = sessionManager.userInfo
        
        self.nameLabel.text = userInfo.VFULLNAME
        self.userNameLabel.text = userInfo.PUSERNAME
        self.orgLabel.text = userInfo.VORGNAME
        self.degreeLabel.text = userInfo.VGRADENAME
        self.statusLabel.text = userInfo.VASSIGNSTATUS
        self.ministryJoinDtLabel.text = userInfo.VMOFJOINDT
        self.govJoinDtLabel.text = userInfo.VGOVTJOINDT
        self.empNumberLabel.text = userInfo.VEMPLOYEENUMBER
        let backButton:UIBarButtonItem  = UIBarButtonItem(title: "back".localized, style: UIBarButtonItemStyle.Done, target: self, action: "backTapped")
        self.navigationItem.leftBarButtonItem = backButton;
    }

    func backTapped(){
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }
}