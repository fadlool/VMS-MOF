//
//  ViewController.swift
//  DMS
//
//  Created by Mohamed Fadl on 11/25/15.
//  Copyright © 2015 Compulink. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var logoLabel: UILabel!
    
    @IBOutlet weak var loginBottomConstraint: NSLayoutConstraint!
    var loginBottomConstraintValue:CGFloat = 0
    
    var kbShown:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if(NSUserDefaults.standardUserDefaults().objectForKey(Common.UserLanguage)!.integerValue == Language.English.rawValue){
            self.usernameTxtField.leftViewMode = UITextFieldViewMode.Always;
            self.usernameTxtField.leftView = UIImageView(image: UIImage(named: "UserIcon"))
            self.usernameTxtField.textAlignment = NSTextAlignment.Left
            
            self.passwordTxtField.leftViewMode = UITextFieldViewMode.Always;
            self.passwordTxtField.leftView = UIImageView(image: UIImage(named: "PassIcon"))
            self.passwordTxtField.textAlignment = NSTextAlignment.Left
        }else{
            self.usernameTxtField.rightViewMode = UITextFieldViewMode.Always;
            self.usernameTxtField.rightView = UIImageView(image: UIImage(named: "UserIcon"))
            self.usernameTxtField.textAlignment = NSTextAlignment.Right
            
            self.passwordTxtField.rightViewMode = UITextFieldViewMode.Always;
            self.passwordTxtField.rightView = UIImageView(image: UIImage(named: "PassIcon"))
            self.passwordTxtField.textAlignment = NSTextAlignment.Right
            
            
        }
        
        self.passwordTxtField.delegate = self;
        self.usernameTxtField.delegate = self;
        
        // save default value to restore onkeyboardHide
        self.loginBottomConstraintValue = self.loginBottomConstraint.constant
        
        self.awakeFromNib()
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if(toInterfaceOrientation == UIInterfaceOrientation.Portrait){
            self.logoImgView.hidden = false
            self.logoLabel.hidden = false
            
        }else{
            self.logoImgView.hidden = true
            self.logoLabel.hidden = true
        }
    }
    
    @IBAction func loginBtnTapped(sender: AnyObject) {
        self.login()
       
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField.returnKeyType == UIReturnKeyType.Next){
            self.passwordTxtField.becomeFirstResponder()
            
        }else{
            self.login()
            
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if(UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait){
            self.logoImgView.hidden = true
            self.logoLabel.hidden = true
            
        }else{
            self.logoImgView.hidden = false
            self.logoLabel.hidden = false
        }
        
        self.observeKeyboard()
    }
    
    override func awakeFromNib() {
//        self.usernameTxtField.textAlignment = NSTextAlignment.Natural
//        self.passwordTxtField.textAlignment = NSTextAlignment.Natural
        
    }
    
    func observeKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }

    func keyboardWillShow(notification:NSNotification){
        
        UIView.beginAnimations(nil, context:nil)
        UIView.setAnimationDuration(0.3)
        UIView.commitAnimations()
        
        let  info:NSDictionary = notification.userInfo!
        
        var kbRect:CGRect  = (info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue)!
        kbRect = self.view.convertRect(kbRect, fromView: nil)
        NSLog("Updating constraints.")
        
        self.loginBottomConstraint.constant =  kbRect.height
        
        let animationDuration:NSTimeInterval = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey)!.doubleValue
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification:NSNotification){
       
        UIView.beginAnimations(nil, context:nil)
        UIView.setAnimationDuration(0.3)
        UIView.commitAnimations()
        
        let  info:NSDictionary = notification.userInfo!
        
        var kbRect:CGRect  = (info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue)!
        kbRect = self.view.convertRect(kbRect, fromView: nil)
        NSLog("Updating constraints.")
        
        self.loginBottomConstraint.constant =  self.loginBottomConstraintValue
        
        let animationDuration:NSTimeInterval = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey)!.doubleValue
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.view.layoutIfNeeded()
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch:UITouch  = (event?.allTouches()?.first)!
        if (self.usernameTxtField.isFirstResponder() && touch.view != self.usernameTxtField) {
            self.usernameTxtField.resignFirstResponder()
        }
        if (self.passwordTxtField.isFirstResponder() && touch.view != self.passwordTxtField) {
            self.passwordTxtField.resignFirstResponder()
        }
        super.touchesBegan(touches, withEvent: event)
    }
    
    func login(){
        let services:Services = Services(viewController: self)
        services.login(self.usernameTxtField.text!,password:self.passwordTxtField.text!)
        
    }
}

