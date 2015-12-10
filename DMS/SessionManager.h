//
//  SessionManager.h
//  CRS
//
//  Created by Amr Abdelmonsef on 2/13/14.
//  Copyright (c) 2014 Compulink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoginInfo;
@class UserInfo;

@interface SessionManager : NSObject

@property (strong , nonatomic) UserInfo *userInfo;
@property (strong , nonatomic) LoginInfo *loginInfo;

+(SessionManager*)sharedSessionManager; // class method to return the singleton object

//-(NSString*) userArabicName;

@end
