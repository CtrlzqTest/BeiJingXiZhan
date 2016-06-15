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

- (void)resetUserInfo:(NSDictionary *)dict {
    
    BOOL loginState = user.isLogin;
    user = [User mj_objectWithKeyValues:dict];
    user.isLogin = loginState;
    [Utility saveUserInfo:[self dictionaryWithModel:user]];
    
}

- (NSDictionary *)dictionaryWithModel:(User *)user {
    
    return [user mj_keyValues];
    
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"userId" : @"id",
             };
}
@end
