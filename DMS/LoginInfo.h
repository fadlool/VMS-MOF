//
//  LoginInfo.h
//  VMS
//
//  Created by Mohamed Fadl on 12/7/15.
//  Copyright © 2015 Compulink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginInfo : NSObject
//"P_USERNAME")
@property (nonatomic, strong) NSString* PUSERNAME;

//"V_ASSIGN_STATUS")
@property (nonatomic, strong) NSString* VASSIGNSTATUS;

//"V_FULL_NAME")
@property (nonatomic, strong) NSString* VFULLNAME;

//"V_ORG_NAME")
@property (nonatomic, strong) NSString* VORGNAME;

//"V_USER_TYPE")
@property (nonatomic, strong) NSString*  VUSERTYPE;

//"V_VALUE")
@property (nonatomic, strong) NSString*  VVALUE;

@end
