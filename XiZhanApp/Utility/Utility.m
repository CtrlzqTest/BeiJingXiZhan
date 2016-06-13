//
//  Utility.m
//  OATest
//
//  Created by zhangqiang on 15/9/2.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#import "Utility.h"
//#import "User.h"
#import "GSKeychain.h"
#import <CommonCrypto/CommonDigest.h>

static User *user = nil;

@implementation Utility



+ (id)getControllerWithStoryBoardId:(NSString *)storyBoardId {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    id vc = [storyBoard instantiateViewControllerWithIdentifier:storyBoardId];
    return vc;
}

+ (void)saveMyMsgReadState:(BOOL)state {
    
    [[NSUserDefaults standardUserDefaults] setBool:state forKey:@"msgReadState"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (BOOL)getMyMsgReadState {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"msgReadState"];
}

+ (BOOL)isFirstLoadding {
    
    BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLoadding"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLoadding"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return !flag;
}

+(void)setLoginStates:(BOOL )isLogin {
    
    [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(BOOL )isLogin {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    
}

+(NSDictionary *)getUserInfoFromLocal
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"];
    return dict;
}

+(void)saveUserInfo:(NSDictionary *)dict
{
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// MD5加密
+ (NSString *) md5:(NSString *)str {
    
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02X", digest[i]];
    return result;
}

// SHA1加密
+ (NSString *) sha1:(NSString *)str {
    
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02X", digest[i]];
    }
    return output;
}

// 保存设备唯一标示
+ (void)saveDeviceToken:(NSString *)deviceToken {
    
    [[NSUserDefaults standardUserDefaults] setValue:deviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

// 获取设备唯一标识
+ (NSString *)getDeviceToken {
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    
}
+(void)checkNewVersion:(void(^)(BOOL hasNewVersion,NSDictionary *stringForUpdate))versionCheckBlock{
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    //    NSLog(@"%@",[infoDict objectForKey:@"CFBundleShortVersionString"]);
    __block double currentVersion = [[infoDict objectForKey:@"CFBundleShortVersionString"] doubleValue];
     NSMutableDictionary *dict = [NSMutableDictionary dictionary];
     [dict setObject:@"IOS" forKey:@"clientType"];
    
    [MHNetworkManager postReqeustWithURL:kCheckNewVersionAPI params:dict successBlock:^(id returnData) {
        NSDictionary *dict = [returnData objectForKey:@"list"];
        NSLog(@"\ncheckVersion%@\n",dict);
        double newVersion = [[dict objectForKey:@"versionNum"] doubleValue];
        BOOL flag = newVersion > currentVersion;
     //   NSString *str = [dict objectForKey:@"loadUrl"];
        versionCheckBlock(flag,dict);
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];

}

+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2478])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:telNumber] == YES)
        || ([regextestcm evaluateWithObject:telNumber] == YES)
        || ([regextestct evaluateWithObject:telNumber] == YES)
        || ([regextestcu evaluateWithObject:telNumber] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)checkPassword:(NSString *) password
{
//    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";// 包含字母
    NSString *pattern = @"^[a-zA-Z0-9]{6,18}";// 可不包含字母
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

+ (NSString *)timeFormat:(NSString *)date format:(NSString *)dateFormat
{
    NSTimeInterval time=([date doubleValue]+28800)/1000;//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:dateFormat];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}

+ (NSString *)getCurrentDateStr {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];//格式化
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

+(long )timeIntervalWithDateStr:(NSString *)dateStr {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];//格式化
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    NSTimeInterval time = [date timeIntervalSince1970];
    long time2 = (long )(time * 1000);
    return time2;
}

// 根据宽度计算文字高度
- (CGFloat )getHeightWithString:(NSString *)str width:(CGFloat )width fontSize:(CGFloat )fontSize{
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return size.height;
}

// 根据高度计算文字宽度
- (CGFloat )getWidthWithString:(NSString *)str height:(CGFloat )height fontSize:(CGFloat )fontSize {
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize size = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return size.width;
    
}

// 注册智信
+ (BOOL )registZhixin {

    NSString *uuidKey = [GSKeychain secretForKey:UUIDkey];
//    [self getSecretAPI:nil];
    if (uuidKey.length <= 0) {
        NSString * sysUUID = [UIDevice currentDevice].identifierForVendor.UUIDString;
        NSString *secret = [self createGuidKey];
        
        [MHNetworkManager getRequstWithURL:kRegistZhixinAPI params:@{@"appkey":sysUUID,@"appsecret":secret,@"clienttype":@"2"} successBlock:^(id returnData) {
            
            if ([returnData[@"code"] integerValue] == 0) {
                [GSKeychain setSecret:sysUUID forKey:UUIDkey];
                [GSKeychain setSecret:secret forKey:UUIDSecret];
            }
            
        } failureBlock:^(NSError *error) {
            
        } showHUD:NO];
    }
    return YES;


}

// 获得随机的GUID
+ (NSString *)createGuidKey {
    
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}

// 接口签名
+ (NSString *)getSecretAPI:(NSString *)keyAPI {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *apptimestamp = [NSString stringWithFormat:@"%.0f",time];
    NSString *appKey = [GSKeychain secretForKey:UUIDkey];
    [dict setValue:@"1" forKey:@"type"];
    [dict setValue:@"dog" forKey:@"action"];
    [dict setValue:@"31" forKey:@"appid"];
    [dict setValue:appKey forKey:@"appkey"];
    [dict setValue:apptimestamp forKey:@"apptimestamp"];
    
    NSArray *allKeys = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *str = [NSMutableString string];
    [str appendString:[GSKeychain secretForKey:UUIDSecret]];
    for (NSString *key in allKeys) {
        [str appendFormat:@"%@%@",key,dict[key]];
    }
    NSString *signStr = [self sha1:str];
    NSString *APIStr = [keyAPI stringByAppendingFormat:@"?type=1&action=dog&appid=31&appkey=%@&apptimestamp=%@&appsign=%@",appKey,apptimestamp,signStr];
    dict = nil;
    allKeys = nil;
    str = nil;
    return APIStr;
}

@end
