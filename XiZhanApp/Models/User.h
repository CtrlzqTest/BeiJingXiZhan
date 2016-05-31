//
//  User.h
//  OnePage
//
//  Created by zhangqiang on 15/12/8.
//  Copyright © 2015年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *pwd;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *tel;
@property (nonatomic,assign)BOOL isLogin;

+ (User *)shareUser;

- (NSDictionary *)dictionaryWithModel:(User *)user;

@end
