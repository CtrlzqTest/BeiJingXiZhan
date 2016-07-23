//
//  MapModel.h
//  西站地图Test
//
//  Created by zhangqiang on 16/7/11.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    MapImageType1 = 1,
    MapImageType2,
    MapImageType3,
} MapImageType;

@interface MapModel : NSObject

@property(nonatomic,copy)NSString *title;

@property(nonatomic,assign)CGPoint coordinate;

@property(nonatomic,assign)BOOL isMark;

@property(nonatomic,copy)NSString *describe;

@property(nonatomic,assign)MapImageType imageType;

+ (NSMutableArray *)setDataWithArray:(NSArray *)array;

@end
