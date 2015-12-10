//
//  VacationReqVC.swift
//  VMS
//
//  Created by Mohamed Fadl on 12/10/15.
//  Copyright © 2015 Compulink. All rights reserved.
//

import Foundation

class VacationReqVC:UITableViewController {
    
    
    
    @IBOutlet weak var empNameLabel: UILabel!
    
    @IBOutlet weak var empNoLabel: UILabel!
    
    @IBOutlet weak var workGroupLabel: UILabel!
    
    @IBOutlet weak var normalVacLabel: NSLayoutConstraint!
    
    @IBOutlet weak var forcedVacLabel: UILabel!
    
    @IBOutlet weak var vacationTypePicker: CurvedLabel!
    
    override func viewDidLoad() {
        let backButton:UIBarButtonItem  = UIBarButtonItem(title: "back".localized, style: UIBarButtonItemStyle.Done, target: self, action: "backTapped")
        self.navigationItem.leftBarButtonItem = backButton;
        
        let showPickerDateGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self,action:"showIncomingDateGesture:")
        self.vacationTypePicker.addGestureRecognizer(showPickerDateGesture)
        
    }
    
    func showVacTypePicker(sender:AnyObject){
        
        let initialSelection = 0
        
        let normalVacType:VacType = VacType(idx: 0, title: "vac_normal".localized)
        let urgentVacType:VacType = VacType(idx: 0, title: "vac_urgent".localized)
        
        let crsTypesArr:NSMutableArray = NSMutableArray()
        crsTypesArr.addObject(normalVacType)
        crsTypesArr.addObject(urgentVacType)
        
        let  gesture:UITapGestureRecognizer = sender as! UITapGestureRecognizer
        let picker:ActionSheetStringPicker  = ActionSheetStringPicker(title: "select_vac_type".localized, rows: crsTypesArr as [AnyObject], initialSelection: initialSelection, doneBlock: { (picker , selectedIndex , selectedValue ) -> Void in
            let vacType:VacType = selectedValue as! VacType
            self.vacationTypePicker.text = vacType.title
            }, cancelBlock: { (picker) -> Void in
                
            }, origin: gesture.view)
        
        picker.showActionSheetPicker()
        
    }
    
    func backTapped(){
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
