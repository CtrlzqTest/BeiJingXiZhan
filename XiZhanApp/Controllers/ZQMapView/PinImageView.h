//
//  PinImageView.h
//  西站地图Test
//
//  Created by zhangqiang on 16/7/4.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapModel.h"

@class PinImageView;

@protocol PinImageViewDelegate <NSObject>

- (void)tapPinView:(PinImageView *)pinView;

@end

@interface PinImageView : UIImageView

/**
 *  初始化
 *
 *  @param coordinate 坐标
 *
 *  @return self
 */
-(instancetype)initWithCoordinate:(CGPoint )coordinate;
/**
 *  大头针坐标
 */
@property(nonatomic,assign)CGPoint coordinate;

/**
 *  title
 */
@property(nonatomic,copy)NSString *title;

/**
 *  imageUrl
 */
@property(nonatomic,copy)NSString *imageUrl;

/**
 *  大头针模型
 */
@property(nonatomic,strong)MapModel *mapModel;

@property(nonatomic,assign)id<PinImageViewDelegate> delegate;

@end
