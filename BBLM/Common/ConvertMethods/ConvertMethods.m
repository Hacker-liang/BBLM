//
//  ConvertMethods.m
//  lvxingpai
//
//  Created by Luo Yong on 14-6-25.
//  Copyright (c) 2014年 aizou. All rights reserved.
//

#import "ConvertMethods.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ConvertMethods

+ (CLLocationDistance) getDistanceFrom:(CLLocationCoordinate2D)startPoint to:(CLLocationCoordinate2D)endPoint {
    MKMapPoint point1 = MKMapPointForCoordinate(startPoint);
    MKMapPoint point2 = MKMapPointForCoordinate(endPoint);
    return MKMetersBetweenMapPoints(point1,point2);
}

+ (NSDate *) stringToDate:(NSString *)string withFormat:(NSString *)format withTimeZone:(NSTimeZone *)zone {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format]; //@"HH:mm:ss"
    [dateFormatter setTimeZone:zone];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}


+ (NSString *)getCurrentDataWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)getCuttentData
{
    return [ConvertMethods getCurrentDataWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *) dateToString:(NSDate *)date withFormat:(NSString *)format withTimeZone:(NSTimeZone *)zone {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:zone];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *) timeIntervalToString:(long long)interval withFormat:(NSString *)format withTimeZone:(NSTimeZone *)zone
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    [dateFormatter setTimeZone:zone];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)RFC822DateWithDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [NSLocale localeWithLocaleIdentifier:@"en-us"];
    df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    df.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";
    
    return [df stringFromDate:date];
}

+ (UIImage*)createImageWithColor: (UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


@end
