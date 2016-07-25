//
//  MapModel.m
//  西站地图Test
//
//  Created by zhangqiang on 16/7/11.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "MapModel.h"

@implementation MapModel

+ (NSMutableArray *)setDataWithArray:(NSArray *)array {
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        MapModel *model = [[MapModel alloc] init];
        model.title = dict[@"Name"];
        CGFloat coord_X = [dict[@"LocateinfoX"] floatValue];
        CGFloat coord_Y = [dict[@"LocateinfoY"] floatValue];
        CGFloat scale = (3508.0 / ([UIScreen mainScreen].bounds.size.height - 64));
        model.coordinate = CGPointMake(coord_X / scale, coord_Y / scale);
        model.describe = dict[@"Describe"];
        if ([dict[@"Floor"] isEqualToString:@"01B1"]) {
            model.imageType = MapImageType1;
        }
        [tmpArray addObject:model];
    }
    return tmpArray;
}

@end
