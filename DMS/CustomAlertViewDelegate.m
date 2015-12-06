//
//  MyAlertViewDelegate.m
//  CRS
//
//  Created by Amr Abdelmonsef on 3/17/14.
//  Copyright (c) 2014 Compulink. All rights reserved.
//

#import "CustomAlertViewDelegate.h"
#import <UIKit/UIKit.h>

@implementation CustomAlertViewDelegate
@synthesize callback;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    callback(alertView, buttonIndex);
}
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    return YES;
    
}

+ (void)showAlertView:(UIAlertView *)alertView
         withCallback:(AlertViewCompletionBlock)callback
{
    __block CustomAlertViewDelegate *delegate = [[CustomAlertViewDelegate alloc] init];
    
    alertView.delegate = delegate;
    delegate.callback = ^(UIAlertView *alertView, NSInteger buttonIndex) {
        callback(alertView, buttonIndex);
        alertView.delegate = nil;
        delegate = nil;
    };
    
    
    [alertView show];
}

@end