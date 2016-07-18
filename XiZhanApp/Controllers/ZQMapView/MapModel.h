//
//  MapModel.h
//  西站地图Test
//
//  Created by zhangqiang on 16/7/11.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MapModel : NSObject

@property(nonatomic,copy)NSString *title;

@property(nonatomic,assign)CGPoint coordinate;

@property(nonatomic,assign)BOOL isMark;

@end
