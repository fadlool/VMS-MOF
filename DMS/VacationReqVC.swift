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
    var selectedEmp:DropDownItem?
    
    @IBOutlet weak var alterEmpCell: UITableViewCell!
    var startDate:NSDate?
    var endDate:NSDate?
    
    var vacationRequest:VacationRequest = VacationRequest()
    
    
    
    func validate() ->Bool {
        
        let sessionManager:SessionManager = SessionManager.sharedSessionManager()
        let loginInfo:LoginInfo = sessionManager.loginInfo
        let userInfo:UserInfo? = sessionManager.userInfo
        
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
        else if (userInfo?.VEMPTYPE != "EMP" && self.selectedEmp == nil) {
            
            let alertView:UIAlertView  = UIAlertView(title: nil, message: "enter_alternate_emp".localized, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
            alertView.show()
            isValid = false;
        }
    return isValid;
    
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField.returnKeyType == UIReturnKeyType.Next){
            self.notesLabel_2.becomeFirstResponder()
            
        }else{
            self.notesLabel_2.resignFirstResponder()
            
        }
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.tableView.contentInset.bottom - keyboardHeight , 0)
            }
        }
    }
    
    @IBAction func commentOneEditChanged(sender: AnyObject) {
        
        let txtField:UITextField = sender as! UITextField
        self.vacationRequest.P_COMMENT1 = txtField.text!
    }
    
    @IBAction func commentTwoEditChanged(sender: AnyObject) {
        let txtField:UITextField = sender as! UITextField
        self.vacationRequest.P_COMMENT2 = txtField.text!
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
        
            let value:Double = Double(sender.text!)!
        
            self.updateEndDate(value)
            

        }
    }
 
    override func viewDidLoad() {
        
        let sessionManager:SessionManager = SessionManager.sharedSessionManager()
        let loginInfo:LoginInfo = sessionManager.loginInfo
        let userInfo:UserInfo? = sessionManager.userInfo
        
        self.normalVacLabel.text = userInfo!.VANNUALLEAVEBAL
        self.forcedVacLabel.text = userInfo!.VEMERGENCYLEAVEBAL
        
        self.empNameLabel.text = loginInfo.VFULLNAME
        self.empNoLabel.text = loginInfo.PUSERNAME
        self.workGroupLabel.text = loginInfo.VORGNAME
    
        
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
        
        
        if (userInfo?.VEMPTYPE == "EMP") {
            self.alterEmpCell.hidden = true
        
        }else{
            self.alterEmpCell.hidden = false
        
        }
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        self.view.addGestureRecognizer(tap)
        
        let screenBound:CGRect  = UIScreen().bounds
        let screenSize:CGSize = screenBound.size
        let screenWidth:CGFloat = screenSize.width
        
        let numberToolbar:UIToolbar = UIToolbar(frame: CGRectMake(0, 0, screenWidth, 50))
        
        numberToolbar.barStyle = UIBarStyle.Default
        numberToolbar.items = [UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: "cancelNumberPad"),UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "doneWithNumberPad")]
        
        numberToolbar.sizeToFit()
        self.vacDaysTxtField.inputAccessoryView = numberToolbar
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardDidShowNotification, object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardDidHideNotification, object: nil)
        
        
        self.notesLabel_1.delegate = self;
        self.notesLabel_2.delegate = self;
    }
    
    func cancelNumberPad(){
        
        self.vacDaysTxtField.resignFirstResponder()
        self.vacDaysTxtField.text = ""
        
    }
    func doneWithNumberPad(){
        if(self.vacDaysTxtField.text! != ""){
            
            let value:Double = Double(self.vacDaysTxtField.text!)!
            
            self.updateEndDate(value)
            
            
        }
        
        self.vacDaysTxtField.resignFirstResponder()
        
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        if (self.vacDaysTxtField.isFirstResponder() ) {
            self.vacDaysTxtField.resignFirstResponder()
        }
        if (self.notesLabel_1.isFirstResponder()) {
            self.notesLabel_1.resignFirstResponder()
        }
        
        if (self.notesLabel_2.isFirstResponder()) {
            self.notesLabel_2.resignFirstResponder()
        }
    }
    
    @IBAction func stepperValueChanged(sender: AnyObject) {
        let stepper:UIStepper = sender as! UIStepper
        self.updateEndDate(stepper.value)
    }
    
    func updateEndDate(value:Double){
    
        if(value >= 0){
            if(self.startDate == nil){
                let alertView:UIAlertView  = UIAlertView(title: nil, message: "select_date_start".localized, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
                alertView.show()
                return
            }
            
            self.vacDaysTxtField.text = String(value)
            self.vacationRequest.P_DAYS = String(value)
            
            self.endDate = self.startDate!.dateByAddingTimeInterval(60*60*24*(value-1))
            let dateString:NSString = Common.getDateString(self.endDate!, isHijri: true)
            self.endDatePicker.text = dateString as String
            self.vacationRequest.P_END_DATE = Common.getDateString(self.endDate!, isHijri: false) as String
            
            let  dateFormatter:NSDateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
            dateFormatter.locale = NSLocale(localeIdentifier: "ar_EG")
            NSLog(dateFormatter.stringFromDate(self.endDate!))
            let str:String = dateFormatter.stringFromDate(self.endDate!)
            
            self.endDateLabel.text = str
            

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

            let  dateFormatter:NSDateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
            dateFormatter.locale = NSLocale(localeIdentifier: "ar_EG")
            NSLog(dateFormatter.stringFromDate(self.startDate!))
            let str:String = dateFormatter.stringFromDate(self.startDate!)
            
            self.startDateLabel.text = str
            }, cancelBlock: { (picker) -> Void in
                
            }, origin: gesture.view)
        
        
        let calendar:NSCalendar?
    if #available(iOS 8.0, *) {
        calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierIslamicUmmAlQura)!
    } else {
        calendar = NSCalendar(calendarIdentifier: NSIslamicCalendar)!
    }

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
            
            let  dateFormatter:NSDateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
            dateFormatter.locale = NSLocale(localeIdentifier: "ar_EG")
            NSLog(dateFormatter.stringFromDate(self.endDate!))
            let str:String = dateFormatter.stringFromDate(self.endDate!)
            
            self.endDateLabel.text = str
            }, cancelBlock: { (picker) -> Void in
                
            }, origin: gesture.view)
        let calendar:NSCalendar?
        if #available(iOS 8.0, *) {
            calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierIslamicUmmAlQura)!
        } else {
            // Fallback on earlier versionsNSCalendarIdentifierGregorian
            
            calendar = NSCalendar(calendarIdentifier: NSIslamicCalendar)!
        }
        
        actionSheetPicker.calendar = calendar;
        actionSheetPicker.locale = NSLocale(localeIdentifier: "ar_SA")
        
        actionSheetPicker.datePickerMode = UIDatePickerMode.Date;
        actionSheetPicker.showActionSheetPicker()
    }
    
  
}
