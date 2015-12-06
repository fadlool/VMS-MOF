//
//  Helper.m
//  CRS
//
//  Created by Amr Abdelmonsef on 2/16/14.
//  Copyright (c) 2014 Compulink. All rights reserved.
//

#import "Helper.h"
#import "CustomAlertViewDelegate.h"
#import <MOF-Swift.h>
@implementation Helper

+ (Helper*)getInstance
{
    Helper* _me_1 = [[Helper alloc] init];
    return _me_1;
}
+(NSDate *)dateFromDotNetJSONString:(NSString *)dateString
{
    // Extract the numeric part of the date.  Dates should be in the format
    // "/Date(x)/", where x is a number.  This format is supplied automatically
    // by JSON serialisers in .NET.
    static NSRegularExpression *dateRegEx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateRegEx = [[NSRegularExpression alloc] initWithPattern:@"^\\/date\\((-?\\d++)(?:([+-])(\\d{2})(\\d{2}))?\\)\\/$" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    NSTextCheckingResult *regexResult = [dateRegEx firstMatchInString:dateString options:0 range:NSMakeRange(0, [dateString length])];
    
    if (regexResult) {
        // NSTimeInterval is specified in seconds, with milliseconds as
        // fractions.  The value we get back from the web service is specified
        // in milliseconds.  Both values are since 1st Jan 1970 (epoch).
        NSTimeInterval seconds = [[dateString substringWithRange:[regexResult rangeAtIndex:1]] doubleValue] / 1000.0;
        // timezone offset
        //        if ([regexResult rangeAtIndex:2].location != NSNotFound) {
        //            NSString *sign = [dateString substringWithRange:[regexResult rangeAtIndex:2]];
        //            // hours
        //            seconds += [[NSString stringWithFormat:@"%@%@", sign, [dateString substringWithRange:[regexResult rangeAtIndex:3]]] doubleValue] * 60.0 * 60.0;
        //            // minutes
        //            seconds += [[NSString stringWithFormat:@"%@%@", sign, [dateString substringWithRange:[regexResult rangeAtIndex:4]]] doubleValue] * 60.0;
        //        }
        
        return [NSDate dateWithTimeIntervalSince1970:seconds];
    }
    return nil;
}


+ (NSString*) getDotNetDate:(NSDate*) date {
    double timeSince1970= date.timeIntervalSince1970;
    NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
    offset=offset/3600;
    double nowMillis = 1000.0 * (timeSince1970);
    NSString *dotNetDate=[NSString stringWithFormat:@"/Date(%.0f%+03d00)/",nowMillis,offset] ;
    return dotNetDate;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(void) changeLanguageWithSegmentPosition{
    
    //    0 segment for English, 1 fo Arabic
    NSString *currentLanguage ;
    NSArray *langArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    if ([[langArr objectAtIndex:0] isEqualToString:@"ar_SA"]) {
        
        currentLanguage =  @"en_US";
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:currentLanguage, nil] forKey:@"AppleLanguages"];
//        [[NSUserDefaults standardUserDefaults] setObject:@(English) forKey:[Common UserLanguage]];
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:[Common UserLanguage]];
    }else{
        currentLanguage = @"ar_SA";
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:currentLanguage, nil] forKey:@"AppleLanguages"];
//        [[NSUserDefaults standardUserDefaults] setObject:@(Arabic) forKey:[Common UserLanguage]];
        [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:[Common UserLanguage]];
        
    }
    //    if (selectedSegement == 0){
    //        currentLanguage = @"ar_SA";
    //        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:currentLanguage, nil] forKey:@"AppleLanguages"];
    //        [[NSUserDefaults standardUserDefaults] setObject:@(Arabic) forKey:[Common UserLanguage]];
    //
    //    }else{
    //        currentLanguage =  @"en_US";
    //        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:currentLanguage, nil] forKey:@"AppleLanguages"];
    //        [[NSUserDefaults standardUserDefaults] setObject:@(English) forKey:[Common UserLanguage]];
    //    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"True" forKey:@"UIApplicationExitsOnSuspend"];
    
    NSString *msg = NSLocalizedString(@"language_change_confirm_dialog",nil);
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"language_change_dialog_title", nil)
                                                     message:msg
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:NSLocalizedString(@"ok_dialog", nil), nil];
    
    [CustomAlertViewDelegate showAlertView:alert withCallback:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"ok_dialog", nil)])
        {
            exit(0);
        }
    }];
    
}

+(id)getJSONDictObjFromString:(NSString *)jsonString{
    NSError * err;
    if ([jsonString isKindOfClass:[NSDictionary class]]) {
        
        return jsonString;
    }
    
    NSData *data =[jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * response;
    if(data!=nil){
        response = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    }
    return response;
}

+(NSString *)getStringFromJSONDictObj:(id)jsonDictObj{
    NSError * err;
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:jsonDictObj options:0 error:&err];
    NSString * jsonString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonString);
    return jsonString;
}
@end
