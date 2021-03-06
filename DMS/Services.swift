//
//  Services.swift
//  VMS
//
//  Created by Mohamed Fadl on 12/4/15.
//  Copyright © 2015 Compulink. All rights reserved.
//

import Foundation
import CryptoSwift

class Services : NSObject, NSURLConnectionDelegate, NSXMLParserDelegate{
    
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    var viewController:UIViewController?
    let LoginResult = "XXX_LOGINResult"
    let GetUserInfoResult = "GET_USER_INFOResult"
    let GetUserNotificaionsResult = "XXX_GET_USER_NOTIFICATIONSResult"
    
    let APPROVE_REQResult = "XXX_APPROVE_REQUESTResult"
    let CLOSE_REQResult = "XXX_CLOSE_FYI_NOTIFICATIONResult"
    let REJECT_REQ_Result = "XXX_REJECT_REQUESTResult"
    
    var methodName:String = ""
    var returnResultString:String = ""

    internal func decrypt(encryptedValue:String)->String{
        let ivBytes:[UInt8] = [ 1, 2, 3, 4, 5, 6, 6, 5, 4, 3, 2, 1, 7, 7, 7, 7 ];
        
        let keyBytes:[UInt8] = [199 ,28, 113,199, 28, 113, 199, 28, 113, 199, 28, 113,  199, 28, 113, 199, 28, 113, 199, 28, 113,  199, 28, 113, 199, 28, 113,  199, 28, 113, 199, 28];
        
        
        let input: [UInt8] = Array(encryptedValue.utf8)
        
        let encryptedNSData = NSData(base64EncodedString: encryptedValue, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        
        do {
            
            
            let decrypted: [UInt8] = try AES(key: keyBytes, iv: ivBytes, blockMode: .CBC).decrypt((encryptedNSData?.arrayOfBytes())!, padding: PKCS7())
            
            var result = String(bytes: decrypted, encoding: NSUTF8StringEncoding)!
            
            print(result)
            
            result = String(bytes: decrypted, encoding: NSUTF8StringEncoding)!
            print("result\t\(result )")
            
            return result
        } catch AES.Error.BlockSizeExceeded {
            // block size exceeded
        } catch {
            // some error
        }
        
        return ""
        
    }
    
    
    internal func encrypt(value:String)->String{
        let ivBytes:[UInt8] = [ 1, 2, 3, 4, 5, 6, 6, 5, 4, 3, 2, 1, 7, 7, 7, 7 ];
        
        let keyBytes:[UInt8] = [199 ,28, 113,199, 28, 113, 199, 28, 113, 199, 28, 113,  199, 28, 113, 199, 28, 113, 199, 28, 113,  199, 28, 113, 199, 28, 113,  199, 28, 113, 199, 28];
        
        
        let input: [UInt8] = Array(value.utf8)
        
        
        do {
            
            let encrypted: [UInt8] = try AES(key: keyBytes, iv: ivBytes, blockMode: .CBC).encrypt(input, padding: PKCS7())
            let encryptedNSData = NSData(bytes: encrypted, length: encrypted.count)
            let encryptedBase64 = encryptedNSData.base64EncodedStringWithOptions([])
            
            print(encryptedBase64)
            
            let decrypted: [UInt8] = try AES(key: keyBytes, iv: ivBytes, blockMode: .CBC).decrypt(encrypted, padding: PKCS7())
            
            var result = String(bytes: decrypted, encoding: NSUTF8StringEncoding)!
            
            print(result)
            
            result = String(bytes: decrypted, encoding: NSUTF8StringEncoding)!
            print("result\t\(result )")
            
            return encryptedBase64
        } catch AES.Error.BlockSizeExceeded {
            // block size exceeded
        } catch {
            // some error
        }
        
        return ""
        
    }
    
    init(viewController:UIViewController) {
        self.viewController = viewController
    }
    
    func login(username:String, password:String){
        
        let soapMessage:NSString = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><XXX_LOGIN xmlns='http://tempuri.org/'><USERNAME>\(encrypt(username))</USERNAME><PASSWORD>\(encrypt(password))</PASSWORD></XXX_LOGIN></soap:Body></soap:Envelope>"
        
        self.processRequest(soapMessage, service: Common.LOGIN_SERVICE)

    }
    
    func getUserInfo(username:String){
        let sessionManager = SessionManager.sharedSessionManager()
        let loginInfo:LoginInfo = sessionManager.loginInfo
        let soapMessage:NSString = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GET_USER_INFO xmlns='http://tempuri.org/'><USERNAME>\(encrypt(username))</USERNAME><WebServiceUserName>\(encrypt(loginInfo.V_WS_USER_NAME))</WebServiceUserName><WebServicePass>\(encrypt(loginInfo.V_WS_PASSWORD))</WebServicePass></GET_USER_INFO></soap:Body></soap:Envelope>"
        
        self.processRequest(soapMessage, service: Common.GET_USER_INFO_SERVICE)
    }
    
    func getUserNotifications(username:String, status:String){
        
        let sessionManager = SessionManager.sharedSessionManager()
        let loginInfo:LoginInfo = sessionManager.loginInfo
        let soapMessage:NSString = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><XXX_GET_USER_NOTIFICATIONS xmlns='http://tempuri.org/'><p_UserName>\(encrypt(username))</p_UserName><P_STATUS>\(encrypt(status))</P_STATUS><WebServiceUserName>\(encrypt(loginInfo.V_WS_USER_NAME))</WebServiceUserName><WebServicePass>\(encrypt(loginInfo.V_WS_PASSWORD))</WebServicePass></XXX_GET_USER_NOTIFICATIONS></soap:Body></soap:Envelope>"
        
        self.processRequest(soapMessage, service: Common.GET_USER_NOTIFS_SERVICE)
        
    }
    
    func getEmployeesList(){
        
        let sessionManager = SessionManager.sharedSessionManager()
        let loginInfo:LoginInfo = sessionManager.loginInfo
        let soapMessage:NSString = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><XXX_GET_EMP_LIST xmlns='http://tempuri.org/'><WebServiceUserName>\(encrypt(loginInfo.V_WS_USER_NAME))</WebServiceUserName><WebServicePass>\(encrypt(loginInfo.V_WS_PASSWORD))</WebServicePass></XXX_GET_EMP_LIST></soap:Body></soap:Envelope>"
        
        self.processRequest(soapMessage, service: Common.GET_EMPLOYEES_LIST_SERVICE)
        
    }
    
    
    func approveRequest(username:String, noteId:String){
        let sessionManager = SessionManager.sharedSessionManager()
        let loginInfo:LoginInfo = sessionManager.loginInfo
        let soapMessage:NSString = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><XXX_APPROVE_REQUEST xmlns='http://tempuri.org/'><P_USERNAME>\(encrypt(username))</P_USERNAME><p_Not_ID>\(encrypt(noteId))</p_Not_ID><WebServiceUserName>\(encrypt(loginInfo.V_WS_USER_NAME))</WebServiceUserName><WebServicePass>\(encrypt(loginInfo.V_WS_PASSWORD))</WebServicePass></XXX_APPROVE_REQUEST></soap:Body></soap:Envelope>"
        
        self.processRequest(soapMessage, service: Common.APPROVE_REQ_SERVICE)
        
    }
    func rejectRequest(username:String, noteId:String){
        
        let sessionManager = SessionManager.sharedSessionManager()
        let loginInfo:LoginInfo = sessionManager.loginInfo
        let soapMessage:NSString = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><XXX_REJECT_REQUEST xmlns='http://tempuri.org/'><P_USERNAME>\(encrypt(username))</P_USERNAME><p_Not_ID>\(encrypt(noteId))</p_Not_ID><WebServiceUserName>\(encrypt(loginInfo.V_WS_USER_NAME))</WebServiceUserName><WebServicePass>\(encrypt(loginInfo.V_WS_PASSWORD))</WebServicePass></XXX_REJECT_REQUEST></soap:Body></soap:Envelope>"
        
        self.processRequest(soapMessage, service: Common.REJECT_REQ_SERVICE)
        
    }
    
    func cancelRequest(username:String, noteId:String){
        
        let sessionManager = SessionManager.sharedSessionManager()
        let loginInfo:LoginInfo = sessionManager.loginInfo
        let soapMessage:NSString = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><XXX_CLOSE_FYI_NOTIFICATION xmlns='http://tempuri.org/'><P_USERNAME>\(encrypt(username))</P_USERNAME><p_Not_ID>\(encrypt(noteId))</p_Not_ID><WebServiceUserName>\(encrypt(loginInfo.V_WS_USER_NAME))</WebServiceUserName><WebServicePass>\(encrypt(loginInfo.V_WS_PASSWORD))</WebServicePass></XXX_CLOSE_FYI_NOTIFICATION></soap:Body></soap:Envelope>"
        
        self.processRequest(soapMessage, service: Common.CLOSE_REQ_SERVICE)
        
    }
    
    func vacationRequest(username:String, vacationrequest:VacationRequest){
        
        let sessionManager = SessionManager.sharedSessionManager()
        let loginInfo:LoginInfo = sessionManager.loginInfo
        let soapMessage:NSString = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><CREATE_VACATION_REQUEST xmlns='http://tempuri.org/'><P_UserName>\(encrypt(username))</P_UserName><P_Absence_type_ID>\(encrypt(vacationrequest.P_Absence_type_ID))</P_Absence_type_ID><P_ST_DATE>\(encrypt(vacationrequest.P_ST_DATE))</P_ST_DATE><P_END_DATE>\(encrypt(vacationrequest.P_END_DATE))</P_END_DATE><P_DAYS>\(encrypt(vacationrequest.P_DAYS))</P_DAYS><P_REPLACED_BY>\(encrypt(vacationrequest.P_REPLACED_BY))</P_REPLACED_BY><P_COMMENT1>\(encrypt(vacationrequest.P_COMMENT1))</P_COMMENT1><P_COMMENT2>\(encrypt(vacationrequest.P_COMMENT2))</P_COMMENT2><WebServiceUserName>\(encrypt(loginInfo.V_WS_USER_NAME))</WebServiceUserName><WebServicePass>\(encrypt(loginInfo.V_WS_PASSWORD))</WebServicePass></CREATE_VACATION_REQUEST></soap:Body></soap:Envelope>"
        
        self.processRequest(soapMessage, service: Common.REQUEST_VACATION_SERVICE)
        
    }
    
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        mutableData.length = 0;
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        mutableData.appendData(data)
    }
    
    
    func showVerificationCodeDialog(loginInfo:LoginInfo){
        let alert:UIAlertView = UIAlertView()
        alert.title = "verification_code".localized
        alert.message = "verification_code_message".localized
        alert.addButtonWithTitle("verify".localized)
        alert.addButtonWithTitle("cancel_dialog".localized)
        
        alert.alertViewStyle = .PlainTextInput;
        
        CustomAlertInputDelegate.showAlertView(alert) { (alert, btnIndex) -> Void in
            if(alert.buttonTitleAtIndex(btnIndex) == "verify".localized){
                if(alert.textFieldAtIndex(0)?.text == loginInfo.V_VERIFICATION_CODE){
                    self.getUserInfo(loginInfo.PUSERNAME)
                }else{
                    let alertView:UIAlertView  = UIAlertView(title: nil, message: "code_invalid".localized, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
                    alertView.show()
                    
                    CustomAlertInputDelegate.showAlertView(alertView) { (alert, btnIndex) -> Void in
                        if(alert.buttonTitleAtIndex(btnIndex) == "ok_dialog".localized){
                            
                            self.showVerificationCodeDialog(loginInfo)
                            
                        }
                        
                    }

                }
            }
            
        }
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        
        let xmlParser = NSXMLParser(data: mutableData)
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
        
        MBProgressHUD.hideHUDForView(viewController!.view, animated: true)
        if(returnResultString == ""){
            let alertView:UIAlertView  = UIAlertView(title: nil, message: "try_again".localized, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
            alertView.show()
            return
            
        }else if(returnResultString.containsString("soap:Server")){
            let alertView:UIAlertView  = UIAlertView(title: "Server Error", message: returnResultString, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
            alertView.show()
            return
        
        
        }
        if(self.methodName == Common.LOGIN_SERVICE){
            
            // [{"P_USERNAME":"900189","V_VALUE":"Y","V_USER_TYPE":"EMP","V_FULL_NAME":"عبدالعزيز بن عبدالرحمن بن محمد العقيل","V_ORG_NAME":" الادارة العامة لتقنية المعلومات","V_ASSIGN_STATUS":"تعيين نشط"}]
            
            let loginJsonResArr:NSArray = Helper.getJSONDictObjFromString(returnResultString) as! NSArray
            
            let loginJsonResDict:NSDictionary = loginJsonResArr.objectAtIndex(0) as! NSDictionary
            let loginInfo:LoginInfo  = LoginInfo()
            loginInfo.PUSERNAME = decrypt(loginJsonResDict.valueForKey("P_USERNAME") as! String)
            loginInfo.VVALUE = decrypt(loginJsonResDict.valueForKey("V_VALUE") as! String)
            
            loginInfo.V_WS_USER_NAME = decrypt(loginJsonResDict.valueForKey("V_WS_USER_NAME") as! String)
            
            loginInfo.V_WS_PASSWORD = decrypt(loginJsonResDict.valueForKey("V_WS_PASSWORD") as! String)
            
            if(loginInfo.VVALUE == "Y"){
                loginInfo.VUSERTYPE = decrypt(loginJsonResDict.valueForKey("V_USER_TYPE") as! String)
                loginInfo.VFULLNAME = decrypt(loginJsonResDict.valueForKey("V_FULL_NAME") as! String)
                loginInfo.VORGNAME = decrypt(loginJsonResDict.valueForKey("V_ORG_NAME") as! String)
                loginInfo.VASSIGNSTATUS = decrypt(loginJsonResDict.valueForKey("V_ASSIGN_STATUS") as! String)
                loginInfo.V_VERIFICATION_CODE = decrypt(loginJsonResDict.valueForKey("V_VERIFICATION_CODE") as! String)
                let sessionManager:SessionManager  = SessionManager.sharedSessionManager()
                sessionManager.loginInfo = loginInfo
                returnResultString = ""
            
                self.getUserInfo(loginInfo.PUSERNAME)
//            self.showVerificationCodeDialog(loginInfo)

                
            }else{
                let alertView:UIAlertView  = UIAlertView(title: nil, message: "login_invalid".localized, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
                alertView.show()
            }
        }
        else if self.methodName == Common.GET_USER_INFO_SERVICE{
            
            //                [{"P_USERNAME":"900189","V_FULL_NAME":"عبدالعزيز بن عبدالرحمن بن محمد العقيل","V_ORG_NAME":" الادارة العامة لتقنية المعلومات","V_ASSIGN_STATUS":"تعيين نشط","V_MOF_JOIN_DT":"1405/11/28","V_GOVT_JOIN_DT":"1403/12/18","V_GRADE_NAME":"11","V_EMPLOYEE_NUMBER":"0002852","V_EMP _TYPE":"EMP","V_ANNUAL_LEAVE_BAL":"152","V_EMERGENCY_LEAVE_BAL":"3"}]
            if(!returnResultString.containsString("Error103")){
                let loginJsonResArr:NSArray = Helper.getJSONDictObjFromString(returnResultString) as! NSArray
                
                let loginJsonResDict:NSDictionary = loginJsonResArr.objectAtIndex(0) as! NSDictionary
                let userInfo:UserInfo = UserInfo()
                userInfo.PUSERNAME =  decrypt(loginJsonResDict.valueForKey("P_USERNAME") as! String)
                userInfo.VFULLNAME =  decrypt(loginJsonResDict.valueForKey("V_FULL_NAME") as! String)
                userInfo.VORGNAME =  decrypt(loginJsonResDict.valueForKey("V_ORG_NAME") as! String)
                userInfo.VASSIGNSTATUS =  decrypt(loginJsonResDict.valueForKey("V_ASSIGN_STATUS") as! String)
                userInfo.VMOFJOINDT =  decrypt(loginJsonResDict.valueForKey("V_MOF_JOIN_DT") as! String)
                userInfo.VGOVTJOINDT =  decrypt(loginJsonResDict.valueForKey("V_GOVT_JOIN_DT") as! String)
                userInfo.VGRADENAME =  decrypt(loginJsonResDict.valueForKey("V_GRADE_NAME") as! String)
                userInfo.VEMPLOYEENUMBER = decrypt( loginJsonResDict.valueForKey("V_EMPLOYEE_NUMBER") as! String)
                userInfo.VEMPTYPE =  decrypt(loginJsonResDict.valueForKey("V_EMP_TYPE") as! String)
                userInfo.VANNUALLEAVEBAL =  decrypt(loginJsonResDict.valueForKey("V_ANNUAL_LEAVE_BAL") as! String)
                userInfo.VEMERGENCYLEAVEBAL =  decrypt(loginJsonResDict.valueForKey("V_EMERGENCY_LEAVE_BAL") as! String)
                
                
                let sessionManager:SessionManager  = SessionManager.sharedSessionManager()
                sessionManager.userInfo = userInfo
                
                // login success
                let containerViewController = ContainerViewController()
                let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
                containerViewController.modalTransitionStyle = modalStyle
                viewController!.presentViewController(containerViewController, animated: true, completion: nil)
                
                
            }else{
                let alertView:UIAlertView  = UIAlertView(title: nil, message: "try_again".localized, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
                alertView.show()
            
            }
        }
        else if self.methodName == Common.GET_USER_NOTIFS_SERVICE{
            
            let notificationsJsonResArr:NSArray = Helper.getJSONDictObjFromString(returnResultString) as! NSArray
//                {"P_USERNAME":"1016","P_MSG":null,"NOT_ID":655949.0,"STATUS":"OPEN","BEGIN_DATE":"2015-12-07T15:12:43","BEGIN_DATE_HIJ":"1437/02/25","TO_USER_ID":"1016","FROM_USER_NAME":"فهد المنيف","TO_USER_NAME":"سعد الوتيد","SUBJECT":"طلب إجازه الخاص بـ فهد المنيف","ABSENCE_TYPE_ID":"65","ABSENCE_TYPE_NAME":"طلب تسجيل الأجازة العادية","START_DATE":null,"START_DATE_HIJ":"1437-02-10T00:00:00","END_DATE":null,"END_DATE_HIJ":"1437-02-14T00:00:00","ABSENCE_DAYS":5.0,"MESSAGE_TYPE":"FYA"},
        
            
            let notificationsViewController:NotificationsViewController = self.viewController as! NotificationsViewController
            
            notificationsViewController.loading = false;
            NSLog("Notifications retreive succeded:");
            
            var notification:UserNotification
            for notificationDict in notificationsJsonResArr {

                notification = UserNotification()
                
                if((notificationDict.valueForKey("SUBJECT") as? NSNull) == nil){
                    notification.SUBJECT = decrypt(notificationDict.valueForKey("SUBJECT") as! String)
                }
                
                if((notificationDict.valueForKey("TO_USER_NAME") as? NSNull) == nil){
                    notification.TOUSERNAME = decrypt(notificationDict.valueForKey("TO_USER_NAME") as! String)
                }
                
                if((notificationDict.valueForKey("FROM_USER_NAME") as? NSNull) == nil){
                    notification.FROMUSERNAME
                        = decrypt(notificationDict.valueForKey("FROM_USER_NAME") as! String)
                }
                
                if((notificationDict.valueForKey("ABSENCE_TYPE_ID") as? NSNull) == nil){
                    notification.ABSENCETYPEID = decrypt(notificationDict.valueForKey("ABSENCE_TYPE_ID") as! String)

                }
                
                if((notificationDict.valueForKey("ABSENCE_TYPE_NAME") as? NSNull) == nil){
                    notification.ABSENCETYPENAME = decrypt(notificationDict.valueForKey("ABSENCE_TYPE_NAME") as! String)
                }
                
                if((notificationDict.valueForKey("ABSENCE_DAYS") as? NSNull) == nil){
                    let absDays:String? = decrypt((notificationDict.valueForKey("ABSENCE_DAYS") as? String)!)
                    if(absDays != nil && absDays != ""){
                        notification.ABSENCEDAYS = Double(absDays!)!
                    }
                }
                
                if((notificationDict.valueForKey("BEGIN_DATE_HIJ") as? NSNull) == nil){
                    notification.BEGINDATEHIJ = decrypt(notificationDict.valueForKey("BEGIN_DATE_HIJ") as! String)
                }
                
                if((notificationDict.valueForKey("START_DATE_HIJ") as? NSNull) == nil){
                    notification.STARTDATEHIJ = decrypt(notificationDict.valueForKey("START_DATE_HIJ") as! String)
                }
                
                if((notificationDict.valueForKey("END_DATE_HIJ") as? NSNull) == nil){
                    notification.ENDDATEHIJ = decrypt(notificationDict.valueForKey("END_DATE_HIJ") as! String)
                }
                
                if((notificationDict.valueForKey("START_DATE") as? NSNull) == nil){
                    let str:String = decrypt(notificationDict.valueForKey("START_DATE") as! String)
                    
//                    let range = str.rangeOfString("T")!
//                    let substring: String = str.substringToIndex(range.startIndex)
                    
                    NSLog(str)
                    
                    notification.STARTDATE = str
                }
                
                if((notificationDict.valueForKey("END_DATE") as? NSNull) == nil){
                    let str:String = decrypt(notificationDict.valueForKey("END_DATE") as! String)
                    
//                    let range = str.rangeOfString("T")!
//                    let substring: String = str.substringToIndex(range.startIndex)
//
//                    NSLog(substring)
                    
                    notification.ENDDATE = str
                }
                
                if((notificationDict.valueForKey("P_USERNAME") as? NSNull) == nil){
                    notification.PUSERNAME = decrypt(notificationDict.valueForKey("P_USERNAME") as! String)
                }
                
                if((notificationDict.valueForKey("MESSAGE_TYPE") as? NSNull) == nil){
                    notification.MESSAGETYPE = decrypt(notificationDict.valueForKey("MESSAGE_TYPE") as! String)
                }
                
                if((notificationDict.valueForKey("TO_USER_NAME") as? NSNull) == nil){
                    notification.TOUSERNAME = decrypt(notificationDict.valueForKey("TO_USER_NAME") as! String)
                }
                
                if((notificationDict.valueForKey("STATUS") as? NSNull) == nil){
                    notification.STATUS = decrypt(notificationDict.valueForKey("STATUS") as! String)
                }
                
                if((notificationDict.valueForKey("NOT_ID") as? NSNull) == nil){
                    let NOTID:String? = decrypt((notificationDict.valueForKey("NOT_ID") as? String)!)
                    if(NOTID != nil && NOTID != ""){
                        notification.NOTID = Double(NOTID!)!
                    }
                    
                }
                
                notificationsViewController.notificationsList.addObject(notification)
            
            }
            
            notificationsViewController.tableView!.reloadData()
            notificationsViewController.stopRefreshControl()
        }else if(self.methodName == Common.APPROVE_REQ_SERVICE){
            
            
            let reqJsonResArr:NSArray = Helper.getJSONDictObjFromString(returnResultString) as! NSArray
            
            let reqJsonResDict:NSDictionary = reqJsonResArr.objectAtIndex(0) as! NSDictionary
            
            
            if ((decrypt((reqJsonResDict.valueForKey("P_MSG"))! as! String) == "Done")) {
                let alert:UIAlertView
                alert = UIAlertView(title: nil, message: "your_request_isapproved".localized,delegate: viewController, cancelButtonTitle: "ok_dialog".localized)
                
                CustomAlertViewDelegate.showAlertView(alert) { (alertView, buttonIndex) -> Void in
                    if(alertView.buttonTitleAtIndex(buttonIndex) == "ok_dialog".localized){
                        self.viewController!.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            
            }else{
                let alertView:UIAlertView  = UIAlertView(title: nil, message: "your_request_didnot_done".localized, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
                alertView.show()
            
            
            }
        }else if(self.methodName == Common.REJECT_REQ_SERVICE){
            
            
            let reqJsonResArr:NSArray = Helper.getJSONDictObjFromString(returnResultString) as! NSArray
            
            let reqJsonResDict:NSDictionary = reqJsonResArr.objectAtIndex(0) as! NSDictionary
            
            
            if ((decrypt((reqJsonResDict.valueForKey("P_MSG"))! as! String) == "Done")) {
                let alert:UIAlertView
                alert = UIAlertView(title: nil, message: "your_request_isrejected".localized,delegate: viewController, cancelButtonTitle: "ok_dialog".localized)
                
                CustomAlertViewDelegate.showAlertView(alert) { (alertView, buttonIndex) -> Void in
                    if(alertView.buttonTitleAtIndex(buttonIndex) == "ok_dialog".localized){
                        self.viewController!.dismissViewControllerAnimated(true, completion: nil)
                    }
                }

                
            }else{
                let alertView:UIAlertView  = UIAlertView(title: nil, message: "your_request_didnot_done".localized, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
                alertView.show()
                
                
            }
        }else if(self.methodName == Common.CLOSE_REQ_SERVICE){
            
            
            let reqJsonResArr:NSArray = Helper.getJSONDictObjFromString(returnResultString) as! NSArray
            
            let reqJsonResDict:NSDictionary = reqJsonResArr.objectAtIndex(0) as! NSDictionary
            
            
            if ((decrypt((reqJsonResDict.valueForKey("P_MSG"))! as! String) == "Done")) {
                let alert:UIAlertView
                
                alert = UIAlertView(title: nil, message: "your_request_isclosed".localized,delegate: viewController, cancelButtonTitle: "ok_dialog".localized)
                
                CustomAlertViewDelegate.showAlertView(alert) { (alertView, buttonIndex) -> Void in
                    if(alertView.buttonTitleAtIndex(buttonIndex) == "ok_dialog".localized){
                        self.viewController!.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
                
                
            }else{
                let alertView:UIAlertView  = UIAlertView(title: nil, message: "your_request_didnot_done".localized, delegate: nil, cancelButtonTitle: "ok_dialog".localized )
                alertView.show()
                
                
            }
        }
        
        else if(self.methodName == Common.GET_EMPLOYEES_LIST_SERVICE){
            
            let reqJsonResArr:NSArray = Helper.getJSONDictObjFromString(returnResultString) as! NSArray
            
//            Log.v("XXX_GET_EMP_LIST", results + " ");
//            final JSONArray jsonArray = new JSONArray(GetEmployeeListService.results);
            if(reqJsonResArr.count > 0) {
                var jsonObject:NSDictionary
                var dropDownItem:DropDownItem
                let filterVC:FilterTableViewController = self.viewController as! FilterTableViewController
                for (var i = 0; i < reqJsonResArr.count; i++) {
                      jsonObject = reqJsonResArr.objectAtIndex(i) as! NSDictionary
                    dropDownItem = DropDownItem(idx: decrypt(String(jsonObject.valueForKey("PERSON_ID")!)), title: decrypt(String(jsonObject.objectForKey("PERSON_NAME")!)))
                        filterVC.allTableData.addObject(dropDownItem)
                }
                
                filterVC.tableView.reloadData()               
            }
        
        
        }
        
        else if(self.methodName == Common.REQUEST_VACATION_SERVICE){
//        [{\"P_USERNAME\":\"1016\",\"P_MSG\":\"الخدمة لم تطبق على شاغري المرتبتين الرابعة عشر والخامسة عشر\"}]
            
            let resArr:NSArray = Helper.getJSONDictObjFromString(returnResultString) as! NSArray
            let resDict:NSDictionary = resArr.objectAtIndex(0) as! NSDictionary
            
            if((resDict.valueForKey("P_MSG") as? NSNull) == nil){
                
                if ((decrypt((resDict.valueForKey("P_MSG"))! as! String) == "Done")) {
//                if (resDict.valueForKey("P_MSG")!.isEqual("Done") ) {
                    let alert:UIAlertView
                    alert = UIAlertView(title: nil, message: "your_request_isdone".localized,delegate: viewController, cancelButtonTitle: "ok_dialog".localized)
                    
                    CustomAlertViewDelegate.showAlertView(alert) { (alertView, buttonIndex) -> Void in
                        if(alertView.buttonTitleAtIndex(buttonIndex) == "ok_dialog".localized){
                            self.viewController!.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                
                }
            else if (decrypt((resDict.valueForKey("P_MSG"))! as! String) != "Done") {
                
                let alertView:UIAlertView  = UIAlertView(title: nil, message: decrypt((resDict.valueForKey("P_MSG"))! as! String), delegate: nil, cancelButtonTitle: "ok_dialog".localized )
                alertView.show()
                
            }else{
                let alert:UIAlertView
                alert = UIAlertView(title: nil, message: "your_request_isrejected".localized,delegate: viewController, cancelButtonTitle: "ok_dialog".localized)
                
                CustomAlertViewDelegate.showAlertView(alert) { (alertView, buttonIndex) -> Void in
                    if(alertView.buttonTitleAtIndex(buttonIndex) == "ok_dialog".localized){
                        self.viewController!.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
                
                }
            }
        
        }
        
    }
    
    
    // NSXMLParserDelegate
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentElementName = elementName
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        NSLog(string)
//        if currentElementName == LoginResult {
        
            returnResultString = returnResultString + string
            
            
//        }
//        else if currentElementName == GetUserInfoResult{
//            
//            returnResultString = returnResultString + string
//            
//        } else if currentElementName == GetUserNotificaionsResult{
//            
//            returnResultString = returnResultString + string
//            
//        }else if currentElementName == GetUserNotificaionsResult{
//            
//            returnResultString = returnResultString + string
//            
//        }else if currentElementName == GetUserNotificaionsResult{
//            
//            returnResultString = returnResultString + string
//            
//        }else if currentElementName == GetUserNotificaionsResult{
//            
//            returnResultString = returnResultString + string
//            
//        }
        
    }
    
    func processRequest( soapMessage:NSString,  service:String){
    
        self.methodName = service
        let urlString = "http://87.101.205.249:1257/service.asmx"
        
        let url = NSURL(string: urlString)
        
        let theRequest = NSMutableURLRequest(URL: url!)
        print(soapMessage)
        let msgLength = String(soapMessage.length)
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        theRequest.addValue("http://tempuri.org/"+service, forHTTPHeaderField: "SOAPAction")
        theRequest.HTTPMethod = "POST"
        theRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) // or false
        if service != Common.GET_USER_NOTIFS_SERVICE{
            MBProgressHUD.showHUDAddedTo(viewController!.view, animated: true)
        }
        let connection = NSURLConnection(request: theRequest, delegate: self, startImmediately: true)
        connection!.start()
        
        if (connection == true) {
            NSMutableData.initialize()
        }
}
    
    
   
}