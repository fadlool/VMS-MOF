//
//  MyAlertViewDelegate.m
//  CRS
//
//  Created by Amr Abdelmonsef on 3/17/14.
//  Copyright (c) 2014 Compulink. All rights reserved.
//

#import "CustomAlertInputDelegate.h"
#import <UIKit/UIKit.h>

@implementation CustomAlertInputDelegate
@synthesize callback;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    callback(alertView, buttonIndex);
}
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if( [inputText length] > 0 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (void)showAlertView:(UIAlertView *)alertView
         withCallback:(AlertViewCompletionBlock)callback
{
    __block CustomAlertInputDelegate *delegate = [[CustomAlertInputDelegate alloc] init];
    
    alertView.delegate = delegate;
    delegate.callback = ^(UIAlertView *alertView, NSInteger buttonIndex) {
        callback(alertView, buttonIndex);
        alertView.delegate = nil;
        delegate = nil;
    };
    
    
    [alertView show];
}

@end