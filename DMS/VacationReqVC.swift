//
//  VacationReqVC.swift
//  VMS
//
//  Created by Mohamed Fadl on 12/10/15.
//  Copyright © 2015 Compulink. All rights reserved.
//

import Foundation

class VacationReqVC:UITableViewController,UITextFieldDelegate,UIAlertViewDelegate {
    
    
    
    @IBOutlet weak var empNameLabel: UILabel!
    
    @IBOutlet weak var empNoLabel: UILabel!
    
    @IBOutlet weak var workGroupLabel: UILabel!
    
    @IBOutlet weak var normalVacLabel: UILabel!
    
    @IBOutlet weak var forcedVacLabel: UILabel!
    
    @IBOutlet weak var vacDaysStepper: UIStepper!
    @IBOutlet weak var vacationTypePicker: CurvedLabel!
    
    @IBOutlet weak var notesLabel_2: UITextField!
    @IBOutlet weak var notesLabel_1: UITextField!
    @IBOutlet weak var alternateEmpAutoCompTxtField: UITextField!
    @IBOutlet weak var endDatePicker: CurvedLabel!
    @IBOutlet weak var startDatePicker: CurvedLabel!
    
    @IBOutlet weak var vacDaysTxtField: UITextField!
    
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    weak var selectedEmp:DropDownItem!
    
    var startDate:NSDate?
    var endDate:NSDate?
    
    var vacationRequest:VacationRequest = VacationRequest()
    
    
    
    func validate() ->Bool {
        var isValid:Bool = true;
        if (self.startDate == nil) {
            let alertView:UIAlertView  = UIAlertView(title: nil, message: "select_date_start".localized, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
            alertView.show()
            isValid = false;
        } else if (self.vacationRequest.P_DAYS == "") {
            let alertView:UIAlertView  = UIAlertView(title: nil, message: "enter_day_no".localized, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
            alertView.show()
            isValid = false;
    isValid = false;
    } else if (self.vacationRequest.P_Absence_type_ID == "") {
            let alertView:UIAlertView  = UIAlertView(title: nil, message: "enter_vac_type".localized, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
            alertView.show()
            isValid = false;
    }
//        else if (self.vacationRequest. == "") {
//    Toast.makeText(getApplicationContext(), "فضلا ادخل الموظف البديل", Toast.LENGTH_SHORT).show();
//    isValid = false;
//    }
    //        if(startDateID.getText().toString().length()==0||
    //                dayNoID.getText().toString().length()==0||
    //                itemPos==0
    //                ){
    //            isValid=false;
    //        }
    //        else{
    //            isValid=true;
    //        }
    return isValid;
    
    }
    
    
    
    func actionTapped(){
        let sessionManager:SessionManager = SessionManager.sharedSessionManager()
        let loginInfo:LoginInfo = sessionManager.loginInfo
     
        if(validate()){
        let services:Services = Services(viewController: self)
            
            let alert:UIAlertView
            alert = UIAlertView(title:"confirm_msg".localized, message: "vaction_confirmation".localized, delegate: self, cancelButtonTitle: "cancel_dialog".localized, otherButtonTitles: "ok_dialog".localized)
            
            CustomAlertViewDelegate.showAlertView(alert) { (alertView, buttonIndex) -> Void in
                if(alertView.buttonTitleAtIndex(buttonIndex) == "ok_dialog".localized){
                    services.vacationRequest(loginInfo.PUSERNAME, vacationrequest: self.vacationRequest)
                }
            }
        }
    }
    @IBAction func noOfDaysEditingChnaged(sender: UITextField) {
        if(sender.text! != ""){
            self.vacationRequest.P_DAYS = sender.text!
        
            let value:Double = Double(sender.text!)!
        
            if(self.startDate == nil){
                let alertView:UIAlertView  = UIAlertView(title: nil, message: "select_date_start".localized, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
                alertView.show()
                return
            }
            
            self.endDate = self.startDate!.dateByAddingTimeInterval(60*60*24*value)
            let dateString:NSString = Common.getDateString(self.endDate!, isHijri: true)
            self.endDatePicker.text = dateString as String
            self.vacationRequest.P_END_DATE = Common.getDateString(self.endDate!, isHijri: false) as String
            self.endDateLabel.text = self.endDate!.descriptionWithLocale( NSLocale(localeIdentifier: "ar_EG"))
            

        }
    }
 
    override func viewDidLoad() {
        
        let sessionManager:SessionManager = SessionManager.sharedSessionManager()
        let loginInfo:LoginInfo = sessionManager.loginInfo
        let userInfo:UserInfo? = sessionManager.userInfo
        
        
        self.empNameLabel.text = loginInfo.VFULLNAME
        self.empNoLabel.text = loginInfo.PUSERNAME
        self.workGroupLabel.text = loginInfo.VORGNAME
        
        if(userInfo != nil){
            self.normalVacLabel.text = userInfo!.VANNUALLEAVEBAL
            self.forcedVacLabel.text = userInfo!.VEMERGENCYLEAVEBAL
            if (userInfo?.VEMPTYPE == "EMP") {
                self.alternateEmpAutoCompTxtField.hidden = true
            } else {
                self.alternateEmpAutoCompTxtField.hidden = false
            }
        
        }
        
        
        let backButton:UIBarButtonItem  = UIBarButtonItem(title: "back".localized, style: UIBarButtonItemStyle.Done, target: self, action: "backTapped")
        self.navigationItem.leftBarButtonItem = backButton;
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "actionTapped")
        
        self.vacationTypePicker.text = "select_vac_type".localized
        let showPickerDateGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self,action:"showVacTypePicker:")
        self.vacationTypePicker.addGestureRecognizer(showPickerDateGesture)
        
        self.startDatePicker.text = "select_date".localized
        let showStartPickerDateGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self,action:"showStartDatePicker:")
        self.startDatePicker.addGestureRecognizer(showStartPickerDateGesture)
        
        
        self.endDatePicker.text = "select_date".localized
        let showEndPickerDateGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self,action:"showEndDatePicker:")
        self.endDatePicker.addGestureRecognizer(showEndPickerDateGesture)
        
        
        self.vacDaysTxtField.delegate = self;
    }
    
    @IBAction func stepperValueChanged(sender: AnyObject) {
        let stepper:UIStepper = sender as! UIStepper
        if(stepper.value >= 0){
                if(self.startDate == nil){
                    let alertView:UIAlertView  = UIAlertView(title: nil, message: "select_date_start".localized, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
                    alertView.show()
                    return
                }
            
            self.vacDaysTxtField.text = String(stepper.value)
            self.vacationRequest.P_DAYS = String(stepper.value)
            
                self.endDate = self.startDate!.dateByAddingTimeInterval(60*60*24*stepper.value)
                let dateString:NSString = Common.getDateString(self.endDate!, isHijri: true)
                self.endDatePicker.text = dateString as String
                self.vacationRequest.P_END_DATE = Common.getDateString(self.endDate!, isHijri: false) as String
                self.endDateLabel.text = self.endDate!.descriptionWithLocale( NSLocale(localeIdentifier: "ar_EG"))
            
        }
    }
    override func viewWillAppear(animated: Bool) {
        if(self.selectedEmp != nil){
            self.alternateEmpAutoCompTxtField.text = self.selectedEmp?.title
        
        }
    }
    @IBAction func alternateEmpTxtTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("show_emp_list", sender: self)
    }
    func showVacTypePicker(sender:AnyObject){
        
        let initialSelection = 0
        
        let normalVacType:DropDownItem = DropDownItem(idx: "1", title: "vac_normal".localized)
        let urgentVacType:DropDownItem = DropDownItem(idx: "2", title: "vac_urgent".localized)
        
        let crsTypesArr:NSMutableArray = NSMutableArray()
        crsTypesArr.addObject(normalVacType)
        crsTypesArr.addObject(urgentVacType)
        
        let  gesture:UITapGestureRecognizer = sender as! UITapGestureRecognizer
        let picker:ActionSheetStringPicker  = ActionSheetStringPicker(title: "select_vac_type".localized, rows: crsTypesArr as [AnyObject], initialSelection: initialSelection, doneBlock: { (picker , selectedIndex , selectedValue ) -> Void in
            let vacType:DropDownItem = selectedValue as! DropDownItem
            self.vacationTypePicker.text = vacType.title
            
            if (vacType.idx == "1") {
                self.vacationRequest.P_Absence_type_ID = "65";
            } else {
                self.vacationRequest.P_Absence_type_ID = "69";
            }
            
            }, cancelBlock: { (picker) -> Void in
                
            }, origin: gesture.view)
        
        picker.showActionSheetPicker()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let naviCtrlr:UINavigationController = segue.destinationViewController as! UINavigationController
        let rootViewController = naviCtrlr.viewControllers.first
        
        let filterViewController:FilterTableViewController = rootViewController as! FilterTableViewController
        
        filterViewController.vacReqController = self
        
    }
    
    func backTapped(){
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func showStartDatePicker(sender:AnyObject){
    
    let  gesture:UITapGestureRecognizer = sender as! UITapGestureRecognizer
    
        let actionSheetPicker:ActionSheetDatePicker = ActionSheetDatePicker(title: "select_date".localized, datePickerMode: UIDatePickerMode.Date , selectedDate: NSDate(), doneBlock: { (picker, selectedDate, origin) -> Void in
            
        
            let gregorianCal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            
            let flags: NSCalendarUnit = [NSCalendarUnit.Day,NSCalendarUnit.Month,NSCalendarUnit.Year]
            
            let comps:NSDateComponents = (gregorianCal?.components(flags, fromDate: selectedDate as! NSDate))!
            
            self.startDate = NSCalendar.currentCalendar().dateFromComponents(comps)!
  
            self.startDatePicker.text = Common.getDateString(self.startDate!, isHijri: true) as String
            
            self.vacationRequest.P_ST_DATE = Common.getDateString(self.startDate!, isHijri: false) as String

            let str:String = self.startDate!.descriptionWithLocale( NSLocale(localeIdentifier: "ar_EG"))
            self.startDateLabel.text = str
            }, cancelBlock: { (picker) -> Void in
                
            }, origin: gesture.view)
        
    let calendar:NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierIslamicUmmAlQura)!

    actionSheetPicker.calendar = calendar;
    actionSheetPicker.locale = NSLocale(localeIdentifier: "ar_SA")
    
    actionSheetPicker.datePickerMode = UIDatePickerMode.Date;
    actionSheetPicker.showActionSheetPicker()
    }
    
    
    func showEndDatePicker(sender:AnyObject){
        
        let  gesture:UITapGestureRecognizer = sender as! UITapGestureRecognizer
        
        let actionSheetPicker:ActionSheetDatePicker = ActionSheetDatePicker(title: "select_date".localized, datePickerMode: UIDatePickerMode.Date , selectedDate: NSDate(), doneBlock: { (picker, selectedDate, origin) -> Void in
            
            
            //            endDateID.setText(dtHijri.getYear() + " / " + month + " / " + day);
            let gregorianCal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            
            let flags: NSCalendarUnit = [NSCalendarUnit.Day,NSCalendarUnit.Month,NSCalendarUnit.Year]
            
            let comps:NSDateComponents = (gregorianCal?.components(flags, fromDate: selectedDate as! NSDate))!
            
            self.endDate = NSCalendar.currentCalendar().dateFromComponents(comps)!
            
            self.vacationRequest.P_END_DATE = Common.getDateString(self.endDate!, isHijri: false) as String
            
            self.endDatePicker.text = Common.getDateString(self.endDate!, isHijri: true) as String
            let str:String = self.endDate!.descriptionWithLocale( NSLocale(localeIdentifier: "ar_EG"))
            self.endDateLabel.text = str
            }, cancelBlock: { (picker) -> Void in
                
            }, origin: gesture.view)
        
        let calendar:NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierIslamicUmmAlQura)!
        
        actionSheetPicker.calendar = calendar;
        actionSheetPicker.locale = NSLocale(localeIdentifier: "ar_SA")
        
        actionSheetPicker.datePickerMode = UIDatePickerMode.Date;
        actionSheetPicker.showActionSheetPicker()
    }
    
  
}
