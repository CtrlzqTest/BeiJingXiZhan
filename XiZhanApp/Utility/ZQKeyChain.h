//
//  ZQKeyChain.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/16.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQKeyChain : NSObject

/**
 *  保存UUID到钥匙串
 */
+(void)saveUUIDToKeyChain;

/**
 *  从钥匙串获取UUID
 *
 *  @return
 */
+(NSString *)readUUIDFromKeyChain;

@end
