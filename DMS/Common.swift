//
//  Common.swift
//  CRS
//
//  Created by Mohamed Fadl on 12/23/14.
//  Copyright (c) 2014 Compulink. All rights reserved.
//

import Foundation
import CryptoSwift

extension String {
    
    func aesEncrypt(key: String, iv: String) throws -> String{
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        let enc = try AES(key: key, iv: iv, blockMode:.CBC).encrypt(data!.arrayOfBytes(), padding: PKCS7())
        let encData = NSData(bytes: enc, length: Int(enc.count))
        let base64String: String = encData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0));
        let result = String(base64String)
        return result
    }
    
    func aesDecrypt(key: String, iv: String) throws -> String {
        let data = NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions(rawValue: 0))
        let dec = try AES(key: key, iv: iv, blockMode:.CBC).decrypt(data!.arrayOfBytes(), padding: PKCS7())
        let decData = NSData(bytes: dec, length: Int(dec.count))
        let result = NSString(data: decData, encoding: NSUTF8StringEncoding)
        return String(result!)
    }
}
extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
}

public class Common: NSObject {
    
    public static let LOGIN_SERVICE = "XXX_LOGIN";
    public static let GET_USER_INFO_SERVICE = "GET_USER_INFO";
    public static let GET_USER_NOTIFS_SERVICE = "XXX_GET_USER_NOTIFICATIONS";
    public static let APPROVE_REQ_SERVICE = "XXX_APPROVE_REQUEST"
    public static let CLOSE_REQ_SERVICE = "XXX_CLOSE_FYI_NOTIFICATION"
    public static let REJECT_REQ_SERVICE = "XXX_REJECT_REQUEST"
    public static let GET_EMPLOYEES_LIST_SERVICE = "XXX_GET_EMP_LIST"
    public static let REQUEST_VACATION_SERVICE = "CREATE_VACATION_REQUEST"
    
    public static let MenuProfileOrder: Int = 0
    public static let MenuIdentityReqOrder: Int = 1
    public static let MenuSelfVacationOrder: Int = 2
    public static let MenuMedicalReqOrder: Int = 3
    public static let MenuDelegateOrder: Int = 4
    public static let MenuLogoutOrder: Int = 5
    
    public static let UserLanguage: String = "preference_language"
    public static let DateIsHijri: String = "preference_is_hijri"
    public static let DateFormat: String = "preference_date_format"
    public static let DUPLICATE_DRAFT:String = "Duplicate Draft"
    public static let ERROR_TYPE:String = "Compulink.Common.Entities.Exceptions.InvalidSessionException"
    
    
    public static var BASE_URL_EXTERNAL:String = "http://10.0.2.14:4000/WebClientServer" // Kassem
    //public static var BASE_URL_EXTERNAL:String = "http://10.0.2.133:9000/WebClientServer"
    
    public static let DATE_FORMAT_1 = "dd MM yyyy"
    public static let DATE_FORMAT_2 = "dd/MM/yyyy"
    
    public static let BASE_URL_TAG = "BASE_URL"
    
       public class func setBaseUrl(url:String){
        self.BASE_URL_EXTERNAL = url
    }
    
   
    public class func changeLanguage(){
        // use whatever language/locale id you want to override
//        let language = SessionManager.sharedSessionManager().sessionInfo.language
        let language = 1
        if (language ==  Language.Arabic.rawValue){
            NSUserDefaults.standardUserDefaults().setObject(["ar_SA"], forKey:"AppleLanguages")
        }else{
            NSUserDefaults.standardUserDefaults().setObject(["en_US"], forKey:"AppleLanguages")
        }
        
        NSUserDefaults.standardUserDefaults().setObject(String(language), forKey: UserLanguage);
        NSUserDefaults.standardUserDefaults().synchronize();
        
    }
    public class func getDateString(cal: NSDate, isHijri:Bool)->NSString {
        
        var dateString = ""
        
        let dateFormat = DATE_FORMAT_2
        
        // Set up components of a Gregorian date
        let  gregorianComponents:NSDateComponents = NSCalendar.currentCalendar().components( [NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: cal)
        
        if (isHijri && dateFormat.isEqual(DATE_FORMAT_1)) {
            let hijriCalendar: NSCalendar?
            // Then create an Islamic calendar
            if #available(iOS 8.0, *) {
               hijriCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierIslamicUmmAlQura)
            } else {
                // Fallback on earlier versions
                hijriCalendar = NSCalendar(calendarIdentifier: NSIslamicCalendar)
                
            }
            
            // And grab those date components for the same date
            let hijriComponents: NSDateComponents  = hijriCalendar!.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: cal)
            
            
            dateString = "\(hijriComponents.day) \(hijriComponents.month) \(hijriComponents.year)"
            
            
        } else if (isHijri && dateFormat.isEqual(DATE_FORMAT_2)) {
             let hijriCalendar: NSCalendar?
            // Then create an Islamic calendar
            if #available(iOS 8.0, *) {
                 hijriCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierIslamicUmmAlQura)
            } else {
                // Fallback on earlier versions
                hijriCalendar = NSCalendar(calendarIdentifier: NSIslamicCalendar)
                
            }
            
            // And grab those date components for the same date
            let hijriComponents: NSDateComponents  = hijriCalendar!.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: cal)
            
            var monthStr = ""
            var dayStr = ""
            
            if(hijriComponents.month < 10){
                monthStr = "0\(hijriComponents.month)"
            }else{
                monthStr = String(hijriComponents.month)
            }
            
            if(hijriComponents.day < 10){
                dayStr = "0\(hijriComponents.day)"
            }else{
                dayStr = String(hijriComponents.day)
            }
            
             dateString = "\(dayStr)/\(monthStr)/\(hijriComponents.year)"
            
        } else if (!isHijri && dateFormat.isEqual(DATE_FORMAT_1)) {
            dateString = "\(gregorianComponents.day) \(gregorianComponents.month) \(gregorianComponents.year)"
            
        } else if (!isHijri  && dateFormat.isEqual(DATE_FORMAT_2)) {
            var monthStr = ""
            var dayStr = ""
            
            if(gregorianComponents.month < 10){
                monthStr = "0\(gregorianComponents.month)"
            }else{
                monthStr = String(gregorianComponents.month)
            }
            if(gregorianComponents.day < 10){
                dayStr = "0\(gregorianComponents.day)"
            }else{
                dayStr = String(gregorianComponents.day)
            }
                        
            dateString = "\(gregorianComponents.year)/"+monthStr+"/"+dayStr
            
        }
        
        return dateString;
        
    }
    
    
}