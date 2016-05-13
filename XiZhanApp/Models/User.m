//
//  User.m
//  OnePage
//
//  Created by zhangqiang on 15/12/8.
//  Copyright © 2015年 zhangqiang. All rights reserved.
//

#import "User.h"
#import <MJExtension.h>

static User *user = nil;
@implementation User

+ (User *)shareUser {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *infoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        user = [User mj_objectWithKeyValues:infoDict];
        if (!user) {
            user = [[User alloc] init];
        }
    });
    return user;
}

- (NSDictionary *)dictionaryWithModel:(User *)user {
    
    return [user mj_keyValues];
    
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"USER_ID" : @"id",
             @"NAME":@"name",
             @"USERNAME":@"nickname",
             @"CREATE_TIME":@"createTime",
             @"TEL":@"tel",
             };
}
@end
