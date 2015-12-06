//
//  MyAlertViewDelegate.h
//  CRS
//
//  Created by Amr Abdelmonsef on 3/17/14.
//  Copyright (c) 2014 Compulink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomAlertInputDelegate : NSObject<UIAlertViewDelegate>

typedef void (^AlertViewCompletionBlock)(UIAlertView *alertView, NSInteger buttonIndex);
@property (strong,nonatomic) AlertViewCompletionBlock callback;

+ (void)showAlertView:(UIAlertView *)alertView withCallback:(AlertViewCompletionBlock)callback;


@end