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

+(void)saveUUIDToKeyChain{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"UUID" accessGroup:@"com.jinyefeilin.GenericKeychain"];
    NSString *string = [keychainItem objectForKey: (__bridge id)kSecAttrGeneric];
    if([string isEqualToString:@""] || !string){
        [keychainItem setObject:[self getUUIDString] forKey:(__bridge id)kSecAttrGeneric];
    }
}

+(NSString *)readUUIDFromKeyChain{
    KeychainItemWrapper *keychainItemm = [[KeychainItemWrapper alloc] initWithIdentifier:@"UUID" accessGroup:@"com.jinyefeilin.GenericKeychain"];
    NSString *UUID = [keychainItemm objectForKey: (__bridge id)kSecAttrGeneric];
    return UUID;
}

+ (NSString *)getUUIDString
{
    NSString *uuidString = [UIDevice currentDevice].identifierForVendor.UUIDString;
    return uuidString;
}

@end
