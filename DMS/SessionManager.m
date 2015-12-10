//
//  SessionManager.m
//  CRS
//
//  Created by Amr Abdelmonsef on 2/13/14.
//  Copyright (c) 2014 Compulink. All rights reserved.
//

#import "SessionManager.h"
#import "UserInfo.h"

@interface SessionManager()
@end

@implementation SessionManager

+(SessionManager *)sharedSessionManager
{
    // Persistent instance.
    static SessionManager *sharedInstance = nil;
    
    // Small optimization to avoid wasting time after the
    // singleton being initialized.
    if (sharedInstance != nil)
    {
        return sharedInstance;
    }
    
    // Allocates once with Grand Central Dispatch (GCD) routine.
    // It's thread safe.
    static dispatch_once_t safer;
    dispatch_once(&safer, ^(void)
                  {
                      sharedInstance = [[SessionManager alloc] init];
                      // private initialization goes here.
                  });
    
    return sharedInstance;
}

//-(NSString *)userArabicName
//{
//    if(self.sessionInfo && self.sessionInfo.user){
//        return self.sessionInfo.user.arabicName;
//    }
//    
//    return @"";
//}

@end
