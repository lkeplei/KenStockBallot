//
//  KenUtils.h
//  KenRecorder
//
//  Created by 刘坤 on 15/1/21.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <string.h>

@interface KenUtils : NSObject

+ (BOOL)isEmpty:(id)object;
+ (BOOL)isNotEmpty:(id)object;

//获取设备的mac地址
+ (NSString *)getMacAddress;
+ (NSString *)getDeviceModel;
+ (NSString *)getDeviceSystemVersion;

+ (UIButton*)buttonWithImg:(NSString*)buttonText off:(int)off zoomIn:(BOOL)zoomIn image:(UIImage*)image
                 imagesec:(UIImage*)imagesec target:(id)target action:(SEL)action;

+ (UILabel*)labelWithTxt:(NSString *)buttonText frame:(CGRect)frame
                   font:(UIFont*)font color:(UIColor*)color;

+ (UITextField*)textFieldInit:(CGRect)frame color:(UIColor*)color bgcolor:(UIColor*)bgcolor
                        secu:(BOOL)secu font:(UIFont*)font text:(NSString*)text;

+ (UINavigationBar*)navigationWithImg:(UIImage*)image;

+ (const CGFloat*)getRGBAFromColor:(UIColor*)color;

+ (void)showRemindMessage:(NSString*)message;

+ (NSNumber*)getNumberByBool:(BOOL)value;
+ (NSNumber*)getNumberByInt:(int)value;

+ (NSString*)getStringByStdString:(const char*)string;
+ (NSString*)getStringByInt:(int)number;
+ (NSString*)getStringByFloat:(float)number decimal:(int)decimal;

+ (void)openUrl:(NSString*)url;

+ (NSString*)getAppVersion;
+ (NSString*)getAppName;

+ (void)callPhoneNumber:(NSString*)number view:(UIView*)view;

+ (CGSize)getFontSize:(NSString*)text font:(UIFont*)font;
+ (NSArray*)getArrayFromStrByCharactersInSet:(NSString*)strResource character:(NSString*)character;

+ (NSString*)getTimeString:(double)time format:(NSString*)format second:(BOOL)second;
+ (NSDate*)getDateFromString:(NSString*)time format:(NSString*)format;
+ (NSString*)getStringFromDate:(NSDate*)date format:(NSString*)format;
+ (NSDateComponents*)getComponentsFromDate:(NSDate*)date;
+ (NSDateComponents*)getSubFromTwoDate:(NSDate*)from to:(NSDate*)to;

+ (NSString*)getFilePathInDocument:(NSString*)fileName;

//打电话发邮件
+ (void) makeCall:(NSString *)phoneNumber msg:(NSString *)msg;
+ (void) sendSms:(NSString *)phoneNumber msg:(NSString *)msg;
+ (void) sendEmail:(NSString *)phoneNumber;
+ (void) sendEmail:(NSString *)to cc:(NSString*)cc subject:(NSString*)subject body:(NSString*)body;

//file
+ (unsigned long long)getFileSize:(NSString*)filePath;
+ (unsigned long long)getFolderSize:(NSString*)folderPath;
+ (BOOL)deleteFileWithPath:(NSString*)path;
+ (BOOL)fileExistsAtPath:(NSString*)path;

+(NSString *)bundlePath:(NSString *)fileName;
+(NSString *)documentsPath:(NSString *)fileName;

//voice
+ (float)getCurrentVoice;
+ (void)setVoice:(float)value;

//正则
+ (BOOL)validateEmail:(NSString *)email;

//^[1-9]d*$　 　 //匹配正整数
//^-[1-9]d*$ 　 //匹配负整数
//^-?[1-9]d*$　　 //匹配整数
//^[1-9]d*|0$　 //匹配非负整数（正整数 + 0）
//^-[1-9]d*|0$　　 //匹配非正整数（负整数 + 0）
//^[1-9]d*.d*|0.d*[1-9]d*$　　 //匹配正浮点数
//^-([1-9]d*.d*|0.d*[1-9]d*)$　 //匹配负浮点数
//^-?([1-9]d*.d*|0.d*[1-9]d*|0?.0+|0)$　 //匹配浮点数
//^[1-9]d*.d*|0.d*[1-9]d*|0?.0+|0$　　 //匹配非负浮点数（正浮点数 + 0）
//^(-([1-9]d*.d*|0.d*[1-9]d*))|0?.0+|0$　　//匹配非正浮点数（负浮点数 + 0）
+ (BOOL)validateNumber:(NSString *)number;
+ (BOOL)validateInteger:(NSString *)number;

@end