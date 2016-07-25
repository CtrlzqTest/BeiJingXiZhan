//
//  ZQMapView.h
//  西站地图Test
//
//  Created by zhangqiang on 16/7/5.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapModel.h"

@class BubView;

@protocol ZQMapViewDelegate <NSObject>

- (void)tapMapAction;

@end

@interface ZQMapView : UIView

/**
 *  地图图片
 */
@property(nonatomic,strong)UIImage *mapImage;

@property(nonatomic,strong)BubView *bubView;

@property(nonatomic,assign)id<ZQMapViewDelegate> delegate;
/**
 *  地图图片类型
 */
@property(nonatomic,assign)MapImageType imageType;

/**
 *  初始化
 *
 *  @param frame frame
 *  @param image 地图纹理图片
 *
 *  @return self
 */
-(instancetype)initWithFrame:(CGRect)frame imageType:(MapImageType )imageType;

/**
 *  添加大头针
 *
 *  @param coordinate 坐标位置
 */
- (void)addPointAnnotation:(MapModel *)model;

/**
 *  设置地图显示初始比例
 *
 *  @param mapScale 比例
 */
- (void)setMapScale:(CGFloat )mapScale;
/**
 *  重新设置大头针
 *
 *  @param model 大头针模型
 *  @param index 大头针索引
 */
- (void)resetPointAnnotation:(MapModel *)model atIndex:(NSInteger )index;

/**
 *  重新设置地图
 *
 *  @param modelArray 坐标点数组
 */
- (void)resetMapView:(NSArray *)modelArray;

/**
 *  隐藏气泡
 */
- (void)hideBubView;
@end
