//
//  ConvertMethods.h
//  lvxingpai
//
//  Created by Luo Yong on 14-6-25.
//  Copyright (c) 2014年 aizou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

/**
 地图类型
 */
typedef enum {
    kBaiduMap = 1,
    kAMap,
    kAppleMap
} MAP_PLATFORM;

@interface ConvertMethods : NSObject

+ (CLLocationDistance) getDistanceFrom:(CLLocationCoordinate2D)startPoint to:(CLLocationCoordinate2D)endPoint;

+ (NSString *)getCurrentDataWithFormat:(NSString *)format;
+ (NSString *)getCuttentData;
+ (NSDate *)stringToDate:(NSString *)string withFormat:(NSString *)format withTimeZone:(NSTimeZone *)zone;
+ (NSString *)dateToString:(NSDate *)date withFormat:(NSString *)format withTimeZone:(NSTimeZone *)zone;
+ (NSString *)timeIntervalToString:(long long)interval withFormat:(NSString *)format withTimeZone:(NSTimeZone *)zone;

/**
 *  将 date 转成 RFC822格式的字符串 如Sun, 06 Nov 1994 08:49:37 GMT
 *
 *  @param date
 *
 *  @return 
 */
+ (NSString *)RFC822DateWithDate:(NSDate *)date;

+ (UIImage*) createImageWithColor: (UIColor*)color;




@end
