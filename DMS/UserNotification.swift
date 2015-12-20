//
//  UserNotification.swift
//  VMS
//
//  Created by Mohamed Fadl on 12/7/15.
//  Copyright © 2015 Compulink. All rights reserved.
//

import Foundation

class UserNotification: NSObject {
    
    override init() {
        
    }
    //"P_USERNAME")
   
    var PUSERNAME:String = ""
    //"P_MSG")
   
    var PMSG:NSObject?
    //"NOT_ID")
   
    var NOTID:Double = 0.0
    //"STATUS")
   
    var STATUS:String = ""
    //"BEGIN_DATE")
   
    var BEGINDATE:String = "غير متاح"
    //"BEGIN_DATE_HIJ")
   
    var BEGINDATEHIJ:String = "غير متاح"
    //"TO_USER_ID")
   
    var TOUSERID:String = "غير متاح"
    //"FROM_USER_NAME")
   
    var FROMUSERNAME:String = "غير متاح"
    //"TO_USER_NAME")
   
    var TOUSERNAME:String = "غير متاح"
    //"SUBJECT")
   
    var SUBJECT:String = "غير متاح"
    //"ABSENCE_TYPE_ID")
   
    var ABSENCETYPEID:String = "غير متاح"
    //"ABSENCE_TYPE_NAME")
   
    var ABSENCETYPENAME:String = "غير متاح"
    //"START_DATE")
   
    var STARTDATE:String = "غير متاح"
    //"START_DATE_HIJ")
   
    var STARTDATEHIJ:NSObject?
    //"END_DATE")
   
    var ENDDATE:String = "غير متاح"
    //"END_DATE_HIJ")
   
    var ENDDATEHIJ:NSObject?
    //"ABSENCE_DAYS")
   
    var ABSENCEDAYS:Double = 0.0
    //"MESSAGE_NAME")
   
    var MESSAGENAME:String = ""
    //"MESSAGE_TYPE")
   
    var MESSAGETYPE:String = ""
}