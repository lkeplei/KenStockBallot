//
//  KenUtils.m
//  KenRecorder
//
//  Created by 刘坤 on 15/1/21.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KenUtils.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#define KShowWeakBtnHeight          (40)
#define KShowWeakRemind             (1000)

@implementation KenUtils

+ (BOOL)isEmpty:(id)object {
    if (object == nil || ([object isKindOfClass:[NSString class]] && [object isEqualToString:@""]) ||
        [object isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;;
}

+ (BOOL)isNotEmpty:(id)object {
    return ![self isEmpty:object];
}

#pragma mark MAC
+(NSString *)getMacAddress{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = (char*)malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

+ (NSString *)getDeviceModel {
    return [[UIDevice currentDevice] model];
}

+ (NSString *)getDeviceSystemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

#pragma mark - static
+(UIButton*)buttonWithImg:(NSString*)buttonText off:(int)off zoomIn:(BOOL)zoomIn image:(UIImage*)image
                 imagesec:(UIImage*)imagesec target:(id)target action:(SEL)action{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    button.titleLabel.textColor = [UIColor whiteColor];
    //    button.titleLabel.shadowOffset = CGSizeMake(0,-1);
    //    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    
    if (buttonText != nil) {
        NSString* text = [NSString stringWithFormat:@"%@", buttonText];
        if (off > 0) {
            for (int i = 0; i < off; i++) {
                text = [NSString stringWithFormat:@" %@", text];
            }
        }
        [button setTitle:text forState:UIControlStateNormal];
        
        if (image == nil && imagesec == nil) {
            float width = [self getFontSize:buttonText font:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]].width;
            float height = [self getFontSize:buttonText font:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]].height;
            
            button.frame = CGRectMake(0.0, 0.0, width, height);
        }
    }
    
    if (zoomIn) {
        [button setImage:image forState:UIControlStateNormal];
        if (imagesec != nil) {
            [button setImage:imagesec forState:UIControlStateHighlighted];
            [button setImage:imagesec forState:UIControlStateSelected];
        }
    } else {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        if (imagesec != nil) {
            [button setBackgroundImage:imagesec forState:UIControlStateHighlighted];
            [button setBackgroundImage:imagesec forState:UIControlStateSelected];
        }
    }
    
    button.adjustsImageWhenHighlighted = NO;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+(UILabel*)labelWithTxt:(NSString *)buttonText frame:(CGRect)frame
                   font:(UIFont*)font color:(UIColor*)color{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.text = buttonText;
    label.font = font;
    label.textAlignment = KTextAlignmentCenter;
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

+(UITextField*)textFieldInit:(CGRect)frame color:(UIColor*)color bgcolor:(UIColor*)bgcolor
                        secu:(BOOL)secu font:(UIFont*)font text:(NSString*)text{
    UITextField* textField = [[UITextField alloc] initWithFrame:frame];
    textField.textColor = color;
    textField.font = font;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.backgroundColor = bgcolor;
    textField.placeholder = text;
    [textField setSecureTextEntry:secu];
    textField.returnKeyType = UIReturnKeyDone;
    
    return textField;
}

+(UINavigationBar*)navigationWithImg:(UIImage*)image{
    UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    
    //设置导般栏背景
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:navBar.frame];
    imageView.contentMode = UIViewContentModeLeft;
    imageView.image = image;
    if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
        [navBar insertSubview:imageView atIndex:0];
    } else {
        [navBar addSubview:imageView];
    }
    
    return navBar;
}

+(const CGFloat*)getRGBAFromColor:(UIColor *)color{
    CGColorRef colorRef = [color CGColor];
    size_t numComponents = CGColorGetNumberOfComponents(colorRef);
    
    if (numComponents >= 4){
        return CGColorGetComponents(colorRef);
    } else {
        return NULL;
    }
}

+(void)showRemindMessage:(NSString *)message{
    [[[UIAlertView alloc] initWithTitle:KenLocal(@"alert_remind_title")
                                message:message
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:KenLocal(@"ok"), nil] show];
}

+(NSNumber*)getNumberByBool:(BOOL)value{
    return [NSNumber numberWithBool:value];
}

+(NSNumber*)getNumberByInt:(int)value{
    return [NSNumber numberWithInt:value];
}

+(NSString*)getStringByStdString:(const char*)string{
    if (string) {
        return [NSString stringWithCString:string encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

+(NSString*)getStringByInt:(int)number{
    return [NSString stringWithFormat:@"%d", number];
}

+(NSString*)getStringByFloat:(float)number decimal:(int)decimal{
    if (decimal == -1) {
        return [@"" stringByAppendingFormat:@"%f",number];
    }else {
        NSString *format=[@"%." stringByAppendingFormat:@"%df", decimal];
        return [@"" stringByAppendingFormat:format,number];
    }
}

+(void)openUrl:(NSString*)url{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+(NSString*)getAppVersion{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    return versionNum;
}

+(NSString*)getAppName{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* appName =[infoDict objectForKey:@"CFBundleDisplayName"];
    return appName;
}

+(void)callPhoneNumber:(NSString *)number view:(UIView*)view{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",number]];
    UIWebView* phoneCallWebView = nil;
    
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
    [view addSubview:phoneCallWebView];
}

+(NSString*)getTimeString:(double)time format:(NSString*)format second:(BOOL)second{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    
    NSDate* date = nil;
    if (second) {
        date = [NSDate dateWithTimeIntervalSince1970:time];
    } else {
        date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    }
    
    return [dateFormatter stringFromDate:date];
}

+(NSDate*)getDateFromString:(NSString*)time format:(NSString*)format{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter dateFromString:time];
}

+(NSString*)getStringFromDate:(NSDate*)date format:(NSString*)format{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate:date];
}

+(NSDateComponents*)getComponentsFromDate:(NSDate*)date{
    return [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit |
            NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit
                                           fromDate:date];
}

+(NSDateComponents*)getSubFromTwoDate:(NSDate*)from to:(NSDate*)to{
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ;
    return [cal components:unitFlags fromDate:from toDate:to options:0];
}

+(NSString*)getFilePathInDocument:(NSString*)fileName{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                       , NSUserDomainMask
                                                       , YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
}

+(unsigned long long)getFileSize:(NSString*)filePath{
    unsigned long long fileSize = 0;
#if 1
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        fileSize = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
#else
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        fileSize = st.st_size;
    }
#endif
    return fileSize;
}

+(unsigned long long)getFolderSize:(NSString*)folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    unsigned long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self getFileSize:fileAbsolutePath];
    }
    return folderSize;
}

+(BOOL)deleteFileWithPath:(NSString*)path{
    if (path) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        return [fileManager removeItemAtPath:path error:nil];
    }
    
    return NO;
}

+(BOOL)fileExistsAtPath:(NSString*)path{
    if (path) {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        return [fileManager fileExistsAtPath:path];
    }
    
    return NO;
}

+(NSString *)bundlePath:(NSString *)fileName {
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}

+(NSString *)documentsPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+ (float)getCurrentVoice {
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerVolume"];
}

+ (void)setVoice:(float)value {
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:@"PlayerVolume"];
}

+ (void)alert:(NSString *)msg {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (NSString*)cleanPhoneNumber:(NSString*)phoneNumber {
    NSString* number = [NSString stringWithString:phoneNumber];
    NSString* number1 = [[[number stringByReplacingOccurrencesOfString:@" " withString:@""]
                          stringByReplacingOccurrencesOfString:@"(" withString:@""]
                         stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    return number1;
}

+ (void)makeCall:(NSString *)phoneNumber msg:(NSString *)msg {
    NSString* numberAfterClear = [KenUtils cleanPhoneNumber:phoneNumber];
    NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", numberAfterClear]];
    [[UIApplication sharedApplication] openURL:phoneNumberURL];
}

+ (void)sendSms:(NSString *)phoneNumber msg:(NSString *)msg {
    NSString* numberAfterClear = [KenUtils cleanPhoneNumber:phoneNumber];
    
    NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", numberAfterClear]];
    [[UIApplication sharedApplication] openURL:phoneNumberURL];
}

+ (void)sendEmail:(NSString *)phoneNumber {
    NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", phoneNumber]];
    [[UIApplication sharedApplication] openURL:phoneNumberURL];
}

+ (void)sendEmail:(NSString *)to cc:(NSString*)cc subject:(NSString*)subject body:(NSString*)body {
    //@"mailto:first@example.com?cc=second@example.com,third@example.com&subject=my email!";
    NSString* str = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@",
                     to, cc, subject, body];
    
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

+ (CGSize)getFontSize:(NSString*)text font:(UIFont*)font{
#ifdef __IPHONE_7_0
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil, NSForegroundColorAttributeName, nil];
    return [text sizeWithAttributes:attributes];
#else
    return [text sizeWithFont:font];
#endif
}

+ (NSArray*)getArrayFromStrByCharactersInSet:(NSString*)strResource character:(NSString*)character{
    return [strResource componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:character]];
}
@end