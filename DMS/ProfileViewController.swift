//
//  ProfileViewController.swift
//  VMS
//
//  Created by Mohamed Fadl on 12/4/15.
//  Copyright © 2015 Compulink. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {


    override func viewWillAppear(animated: Bool) {
        
        let backButton:UIBarButtonItem  = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Done, target: self, action: "backTapped")
        self.navigationItem.leftBarButtonItem = backButton;
    }

    func backTapped(){
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }
}