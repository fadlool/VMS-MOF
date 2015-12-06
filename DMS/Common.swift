//
//  Common.swift
//  CRS
//
//  Created by Mohamed Fadl on 12/23/14.
//  Copyright (c) 2014 Compulink. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
}

public class Common: NSObject {
    
    public static let MenuProfileOrder: Int = 0
    public static let MenuIdentityReqOrder: Int = 1
    public static let MenuSelfVacationOrder: Int = 2
    public static let MenuMedicalReqOrder: Int = 3
    public static let MenuDelegateOrder: Int = 4
    public static let MenuLogoutOrder: Int = 5
    
    public static let LoginResult = "XXX_LOGINResult"
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
 
    
    
}