//
//  Constants.h
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//


#define kWindowWidth   [UIApplication sharedApplication].keyWindow.frame.size.width
#define kWindowHeight  [UIApplication sharedApplication].keyWindow.frame.size.height

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define COLOR_TEXT_I                    UIColorFromRGB(0x323232)
#define COLOR_TEXT_II                   UIColorFromRGB(0x646464)
#define COLOR_TEXT_III                  UIColorFromRGB(0x969696)
#define COLOR_LINE                      UIColorFromRGB(0xe2e2e2)
#define APP_PAGE_COLOR                  UIColorFromRGB(0xdbdbdb)
#define APP_THEME_COLOR                 UIColorFromRGB(0xFF2144)


//#define BASE_API    @"http://jtest.babilama.com/"
#define BASE_API    @"http://app.babilama.com/"

#define JPushAppKey         @"980accd495131a358bb90ed2"
#define UMengKey            @"572c3f20e0f55a46e200214c"
#define WechatAppId         @"wxf002ea2189fae2b0"
#define WechatAppSecret     @"d848584b13832673860715c1dbc4877f"
