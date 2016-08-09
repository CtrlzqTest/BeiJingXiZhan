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
#import "ZQKeyChain.h"
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

/**
 *  保存志愿者上线状态
 */
+ (void)saveVolunteerState:(BOOL)state
{
    [[NSUserDefaults standardUserDefaults] setBool:state forKey:@"isOnline"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 *  获取志愿者状态
 */
+ (BOOL)getVolunteerState
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isOnline"];
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
    
    NSData *data2 = [str dataUsingEncoding:NSUTF8StringEncoding];
    
//    const char *cstr = [str cStringUsingEncoding:NSUnicodeStringEncoding];
//    NSData *data = [NSData dataWithBytes:cstr length:str.length];
//    NSLog(@"%@",data2.bytes);
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data2.bytes, (CC_LONG)data2.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02x", digest[i]];
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
     NSMutableDictionary *param = [NSMutableDictionary dictionary];
     [param setObject:@"IOS" forKey:@"clientType"];
    

    [RequestManager postRequestWithURL:kCheckNewVersionAPI paramer:param success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"message"] isEqualToString:@"success"]) {
            NSDictionary *dict = [responseObject objectForKey:@"list"];
            NSLog(@"\ncheckVersion%@\n",dict);
            double newVersion = [[dict objectForKey:@"versionNum"] doubleValue];
            BOOL flag = newVersion > currentVersion;
            versionCheckBlock(flag,dict);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
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

+(long long)timeIntervalWithDateStr:(NSString *)dateStr {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];//格式化
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    NSTimeInterval time = [date timeIntervalSince1970];
    long long time2 = (long long)(time * 1000);
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
//+ (void)registZhixin {
//
//    NSString *uuidKey = [GSKeychain secretForKey:UUIDkey];
//    
//    if ([self getSecretWithKey:UUIDSecret].length <= 0) {
//        if (uuidKey.length <= 0) {
//            uuidKey = [UIDevice currentDevice].identifierForVendor.UUIDString;
//            NSString *secret = [self createGuidKey];
//            __weak typeof(self) weakSelf = self;
//            [MHNetworkManager postReqeustWithURL:kRegistZhixinAPI params:@{@"appkey":uuidKey,@"appsecret":secret,@"clienttype":@"2"} successBlock:^(id returnData) {
//                NSLog(@"%@",returnData);
//                if ([returnData[@"code"] integerValue] == 0) {
//                    [GSKeychain setSecret:uuidKey forKey:UUIDkey];
//                    [GSKeychain setSecret:secret forKey:UUIDSecret];
//                    [weakSelf saveSecret:uuidKey key:UUIDkey];
//                    [weakSelf saveSecret:secret key:UUIDSecret];
//                }else if([returnData[@"code"] integerValue] == -1)
//                {
////                    [weakSelf checkIsRegisteruuid];
//                }else {
//                    [weakSelf registZhixin];
//                }
//                
//            } failureBlock:^(NSError *error) {
//                
//            } showHUD:NO];
//        }else {
//            NSString *secret = [GSKeychain secretForKey:UUIDSecret];
//            [self saveSecret:uuidKey key:UUIDkey];
//            [self saveSecret:secret key:UUIDSecret];
//        }
//    }
//}


+ (void)registZhixin {
    
        NSString *uuidKey = [UIDevice currentDevice].identifierForVendor.UUIDString;
        NSString *secret = [self createGuidKey];
        __weak typeof(self) weakSelf = self;

    [RequestManager postRequestWithURL:kRegistZhixinAPI paramer:@{@"appkey":uuidKey,@"appsecret":secret,@"clienttype":@"2"} success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            [weakSelf saveSecret:uuidKey key:UUIDkey];
            [weakSelf saveSecret:secret key:UUIDSecret];
        }else if([responseObject[@"code"] integerValue] == -1){
            //[weakSelf checkIsRegisteruuid];
        }else {
            [weakSelf registZhixin];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showHUD:NO];
}

// 检查是否已注册设备
+ (void)checkIsRegisteruuid {
    
    NSString *uuidKey = [self getSecretWithKey:UUIDkey];
    if (uuidKey.length <= 0) {
        uuidKey = [UIDevice currentDevice].identifierForVendor.UUIDString;
        __weak typeof(self) weakSelf = self;
        
        [RequestManager getRequestWithURL:kGetUUIDSecretAPI paramer:@{@"appkey":uuidKey} success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *secretStr = responseObject[@"data"];
            if ([responseObject[@"code"] integerValue] == 0 && secretStr.length > 0) {
                
                //                [GSKeychain setSecret:returnData[@"data"] forKey:UUIDSecret];
                [weakSelf saveSecret:uuidKey key:UUIDkey];
                [weakSelf saveSecret:responseObject[@"data"] key:UUIDSecret];
                
            }else {
                
                //[GSKeychain removeAllSecrets];
                [weakSelf saveSecret:@"" key:UUIDkey];
                [weakSelf saveSecret:@"" key:UUIDSecret];
                [weakSelf registZhixin];
            }

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        } showHUD:NO];

    }
    
    
}

// 保存智信secret
+ (void)saveSecret:(NSString *)secret key:(NSString *)key{
    
    [[NSUserDefaults standardUserDefaults] setValue:secret forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

// 是否需要注册UUID
+ (NSString *)getSecretWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
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

// 检查是否需要接口签名
+ (BOOL )checkToSign:(NSString *)APIStr {
    
    NSString *matchStr = @".*/((appversion)|(GetDeviceRegisterInfo)|(RegisterDevice)|(getSmsCode)|(app.)|(register)|(login)).*";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", matchStr];
    if ([regextestmobile evaluateWithObject:APIStr]) {
        return NO;
    }
    return YES;

}

// 接口签名(直接访问智信)
+ (NSString *)getSecretAPI:(NSString *)keyAPI paramDict:(NSDictionary *)tempDict{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    if (tempDict.count) {
        dict = [NSMutableDictionary dictionaryWithDictionary:tempDict];
    }
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *apptimestamp = [NSString stringWithFormat:@"%.0f",time];
    NSString *appKey = [self getSecretWithKey:UUIDkey];
    [dict setValue:@"31" forKey:@"appid"];
    [dict setValue:apptimestamp forKey:@"apptimestamp"];
    [dict setValue:appKey forKey:@"appkey"];
    NSMutableArray *allKeys_low = [NSMutableArray array];
    NSArray *allKeys = [dict allKeys];
    for (NSString *key in allKeys) {
        [allKeys_low addObject:[key lowercaseString]];
        [dict2 setValue:dict[key] forKey:[key lowercaseString]];
    }
    
    [allKeys_low sortUsingSelector:@selector(compare:)];
    NSMutableString *str = [NSMutableString string];
    NSString *secretStr = [self getSecretWithKey:UUIDSecret].length <= 0 ? @"" : [self getSecretWithKey:UUIDSecret];
    [str appendString:secretStr];
    for (int i = 0; i < allKeys_low.count; i ++) {
        NSString *key = allKeys_low[i];
        [str appendFormat:@"%@%@",allKeys_low[i],dict2[key]];
    }
    
    NSString *signStr = [self sha1:str];
    [dict setValue:signStr forKey:@"appsign"];
    
    NSMutableString *APIStr = [NSMutableString string];
    [APIStr appendString:@"?"];
    for (NSString *key in [dict allKeys]) {
        [APIStr appendFormat:@"%@=%@&",key,dict[key]];
    }
    dict = nil;
    dict2 = nil;
    allKeys = nil;
    allKeys_low = nil;
    str = nil;
    return [NSString stringWithFormat:@"%@%@",keyAPI,[APIStr substringToIndex:APIStr.length - 1]];
}

/**
 *  ***************** 其他 ********************
 */
+ (NSString *)getTagWithuserType:(NSString *)userType {
    
    NSInteger index = [userType integerValue];
    NSString *tag = nil;
    switch (index) {
        case 1:
            tag =  @"passenger";
            break;
        case 2:
            tag =  @"volunteer";
            break;
        case 3:
            tag =  @"service";
            break;
        case 4:
            tag =  @"guide";
            break;
        case 5:
            tag =  @"taxi_driver";
            break;
        case 6:
            tag =  @"army";
            break;
        case 7:
            tag =  @"police";
            break;
        case 8:
            tag =  @"cmps";
            break;
        case 9:
            tag =  @"super_user";
            break;
        case 10:
            tag =  @"city_mgr";
            break;
        default:
            break;
    }
    return tag;
}

+ (NSString *)getNameWithuserType:(NSString *)userType {
    
    NSInteger index = [userType integerValue];
    NSString *tag = nil;
    switch (index) {
        case 1:
            tag =  @"旅客";
            break;
        case 2:
            tag =  @"志愿者";
            break;
        case 3:
            tag =  @"服务台";
            break;
        case 4:
            tag =  @"交通引导员";
            break;
        case 5:
            tag =  @"出租车司机";
            break;
        case 6:
            tag =  @"军";
            break;
        case 7:
            tag =  @"警";
            break;
        case 8:
            tag =  @"综治办";
            break;
        case 9:
            tag = @"高级用户";
            break;
        case 10:
            tag =  @"城管";
            break;
        default:
            break;
    }
    return tag;
}

@end
