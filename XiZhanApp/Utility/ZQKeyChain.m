//
//  ZQKeyChain.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/16.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ZQKeyChain.h"
#import "KeychainItemWrapper.h"

//static KeychainItemWrapper *kechain = nil;
@implementation ZQKeyChain

/**
 *  保存UUID到钥匙串
 */
+(void)saveUUIDToKeyChain{

    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.JinYeFeiLin.XiZhanApp" accessGroup:@"2936LQZ357.com.JinYeFeiLin.XiZhanApp"];
    NSString *string = [keychainItem objectForKey:(__bridge id)kSecValueData];
    if([string isEqualToString:@""] || !string){
        [keychainItem resetKeychainItem];
        [keychainItem setObject:@"MY_APP_CREDENTIALS" forKey:(id)kSecAttrAccount];
        [keychainItem setObject:[self getUUIDString] forKey:(__bridge id)kSecValueData];
    }
}

/**
 *  从钥匙串获取UUID
 */
+(NSString *)readUUIDFromKeyChain{
    KeychainItemWrapper *keychainItemm = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.JinYeFeiLin.XiZhanApp" accessGroup:@"2936LQZ357.com.JinYeFeiLin.XiZhanApp"];
    NSString *UUID = [keychainItemm objectForKey:(__bridge id)kSecValueData];
    return UUID;
}

+ (NSString *)getUUIDString
{
    NSString *uuidString = [UIDevice currentDevice].identifierForVendor.UUIDString;
    return uuidString;
}

@end
