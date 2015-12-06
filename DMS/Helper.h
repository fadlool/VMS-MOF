//
//  Helper.h
//  CRS
//
//  Created by Amr Abdelmonsef on 2/16/14.
//  Copyright (c) 2014 Compulink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Helper : NSObject
+ (Helper*)getInstance;
+ (NSDate *)dateFromDotNetJSONString:(NSString *)dateString;
+ (NSString*) getDotNetDate:(NSDate*) date;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (void) changeLanguageWithSegmentPosition;
+ (id) getJSONDictObjFromString:(NSString*)jsonString;
+ (NSString*) getStringFromJSONDictObj:(id)jsonDictObj;

@end
