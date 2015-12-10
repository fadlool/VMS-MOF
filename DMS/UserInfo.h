//
//  UserInfo.h
//  CRS
//
//  Created by Amr Abdelmonsef on 2/10/14.
//  Copyright (c) 2014 Compulink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject


//"P_USERNAME")
@property (nonatomic, strong) NSString* PUSERNAME;

//"V_ASSIGN_STATUS")
@property (nonatomic, strong) NSString* VASSIGNSTATUS;

//"V_EMPLOYEE_NUMBER")
@property (nonatomic, strong) NSString* VEMPLOYEENUMBER;

//"V_FULL_NAME")
@property (nonatomic, strong) NSString* VFULLNAME;

//"V_GOVT_JOIN_DT")
@property (nonatomic, strong) NSString* VGOVTJOINDT;

//"V_GRADE_NAME")
@property (nonatomic, strong) NSString* VGRADENAME;

//"V_MOF_JOIN_DT")
@property (nonatomic, strong) NSString* VMOFJOINDT;

//"V_ORG_NAME")
@property (nonatomic, strong) NSString* VORGNAME;
//"V_EMP_TYPE")
@property (nonatomic, strong) NSString* VEMPTYPE;

//"V_ANNUAL_LEAVE_BAL")
@property (nonatomic, strong) NSString* VANNUALLEAVEBAL;

//"V_EMERGENCY_LEAVE_BAL")
@property (nonatomic, strong) NSString* VEMERGENCYLEAVEBAL;



@end
