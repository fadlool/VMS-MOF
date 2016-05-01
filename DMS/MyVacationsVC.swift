//
//  MyVacationsVC.swift
//  VMS
//
//  Created by Mohamed Fadl on 5/1/16.
//  Copyright © 2016 Compulink. All rights reserved.
//

import Foundation
import UIKit

class MyVacationsVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton:UIBarButtonItem  = UIBarButtonItem(title: "back".localized, style: UIBarButtonItemStyle.Done, target: self, action: "backTapped")
        self.navigationItem.leftBarButtonItem = backButton;
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "search".localized, style: UIBarButtonItemStyle.Done, target: self, action: "searchTapped")
    }
    func searchTapped(){
    
    }
    
    func backTapped(){
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}