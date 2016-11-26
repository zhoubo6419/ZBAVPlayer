//
//  Header.h
//  Traindemo
//
//  Created by 周波 on 16/11/24.
//  Copyright © 2016年 周波. All rights reserved.
//

#ifndef PrefixHeader_pch
#define PrefixHeader_pch

// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.
//#define ROOT_URL @"http://222.240.234.21:8080/ESCloudInterface"
//#define ROOT_URL @"http://222.240.234.21:8090/ESCloudInterface"
//#define ROOT_URL @"http://192.168.1.108:8080/ESCloudInterface"
#define ROOT_URL @"http://www.rainfo.cn/ESCloudInterface"


#import "MBProgressHUD+Add.h"
#define KisLogin @"KisLogin"
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHight [UIScreen mainScreen].bounds.size.height
#endif /* PrefixHeader_pch */
#ifndef __IPHONE_3_0
#warning "This project uses features only available in iOS SDK 3.0 and later."
#endif

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//#import "LYLoginInfo.h"

#   define DTLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#define SHOW_ALERT(_msg_)  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_msg_ delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];\
[alert show];

//#import "UIImage+Color.h"
//#import "UIAlertView+Blocks.h"
//#import "LYTool.h"
//#import "FrameManager.h"
//#import "LYAPi.h"
//#import "UIImageView+WebCache.h"
//#import "NotificationMacro.h"
#endif
#define iOS7  ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
#define IF_IOS7_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1) \
{ \
__VA_ARGS__ \
}
#define ABCrray  @[@"A",@"B",@"C",@"D",@"E",@"F",@"G"]


#define viewcolor [UIColor whiteColor]
#define userTypes    [[NSUserDefaults standardUserDefaults] objectForKey:@"userType"]
#define usrename    [[NSUserDefaults standardUserDefaults] objectForKey:@"usrename"]
#define UserID     [[NSUserDefaults standardUserDefaults] objectForKey:@"ID"]
#define Name     [[NSUserDefaults standardUserDefaults] objectForKey:@"name"]
#define KW     [[[NSUserDefaults standardUserDefaults] objectForKey:@"KW"] floatValue]//适配宽度大小
#define KH     [[[NSUserDefaults standardUserDefaults] objectForKey:@"KH"] floatValue]//适配高度大小
#define font1 [[[NSUserDefaults standardUserDefaults] objectForKey:@"font1"] floatValue] //字体1
#define font2 [[[NSUserDefaults standardUserDefaults] objectForKey:@"font2"] floatValue]//字体2
#define Dstatus [[NSUserDefaults standardUserDefaults] objectForKey:@"DriverStatus"]//发布状态

#define setaccounts [[NSUserDefaults standardUserDefaults] objectForKey:@"nameText"]//用户名
#define setpasswords [[NSUserDefaults standardUserDefaults] objectForKey:@"passWordText"]//密码


#else
#define IF_IOS7_OR_GREATER(...)
#endif
#define forbackColor YRGBColor(241, 243, 247)
#define MainRedColor YRGBColor(228, 95, 83)
#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]
#define YRGBColor(r,g,b) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0]
#define tableviewbackcorlor   YRGBColor(237, 240, 245)
#define textlightcorlor   YRGBColor(163, 165, 165)
#define  ESTgreenColor   YRGBColor(3, 101, 28)
#define  TextgreenColor   YRGBColor(43, 125, 52)


#define DLog( s, ... ) NSLog( @"<%@:(%d)> %@",  [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

//@neeWeakSelf 或者 @neeStrongSelf

#define WEAK_SELF __weak __typeof(&*self)weakSelf = self

#ifndef	neeWeakSelf
#if __has_feature(objc_arc)
#define neeWeakSelf( x )	autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x;
#else	// #if __has_feature(objc_arc)
#define neeWeakSelf( x )	autoreleasepool{} __block __typeof__(x) __block_##x##__ = x;
#endif	// #if __has_feature(objc_arc)
#endif	// #ifndef	neeWeakSelf

#ifndef	neeStrongSelf
#if __has_feature(objc_arc)
#define neeStrongSelf( x )	try{} @finally{} __typeof__(x) x = __weak_##x##__;
#else	// #if __has_feature(objc_arc)
#define neeStrongSelf( x )	try{} @finally{} __typeof__(x) x = __block_##x##__;
#endif	// #if __has_feature(objc_arc)
#endif	// #ifndef	@neeStrongSelf

#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width

#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}
#define fengexianColor YRGBColor(241, 243, 247)
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SINGLETON(classname)                            \
+ (classname *)sharedInstance{                              \
static dispatch_once_t pred;                            \
__strong static classname *shared##classname=nil;       \
dispatch_once(&pred,^(void){                            \
shared##classname=[[self alloc]init];               \
});                                                     \
return shared##classname;                               \
}


#define RGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
//转换
#define I2S(number) [NSString stringWithFormat:@"%d",number]
#define F2S(number) [NSString stringWithFormat:@"%f",number]
#define DATE(stamp) [NSDate dateWithTimeIntervalSince1970:[stamp intValue]];

#define WEAK_SELF __weak __typeof(&*self)weakSelf = self


#define RSAPubKey @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQD0Lohb/8xL3kUJnzSzb1bCyQBTYBeS1XCS7AFkrScpDFD4LpMIElAo2cVlhXH+L7UTCBo1K17xAdLj0DxGyhaE8xU1idrW625BF1vQ6n9hf3GsXMqY0LDQxGeudUtqFEBB9Y7cH9NMnllD/OS/yB3XZb04y48nXyftOPuPj3sT9QIDAQAB-----END PUBLIC KEY-----"
#define LIST_PAGESIZE 10

