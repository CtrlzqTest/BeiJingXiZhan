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
    int tag = 100;
    for (NSDictionary *dict in array) {
        tag ++;
        MapModel *model = [[MapModel alloc] init];
        
        CGFloat coord_X = [dict[@"LocateinfoX"] floatValue];
        CGFloat coord_Y = [dict[@"LocateinfoY"] floatValue];
        CGFloat scale = (3508.0 / kImageWidth);
        model.coordinate = CGPointMake(coord_X / scale, coord_Y / scale);
        model.describe = dict[@"Describe"];
        model.Imagesurl = dict[@"Imagesurl"];
        if ([dict[@"Floor"] isEqualToString:@"01B1"]) {
            model.imageType = MapImageType1;
            model.title = [dict[@"Name"] stringByAppendingString:@"(负一层)"];
        }else if([dict[@"Floor"] isEqualToString:@"01B2"]) {
            model.imageType = MapImageType2;
            model.title = [dict[@"Name"] stringByAppendingString:@"(负二层)"];
        }else if([dict[@"Floor"] isEqualToString:@"01F1"]){
            model.imageType = MapImageType3;
            model.title = [dict[@"Name"] stringByAppendingString:@"(南北广场)"];
        }
        model.pinTag = tag;
        [tmpArray addObject:model];
    }
    return tmpArray;
}

@end
