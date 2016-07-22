//
//  ZQPickerView.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/7/22.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^hidePickerViewBlock)(NSInteger index);

@interface ZQPickerView : UIView

/**
 *  数据源
 */
@property(nonatomic,strong)NSArray *dataArray;
/**
 *  pickerView
 */
@property(nonatomic,strong)UIPickerView *pickerView;

/**
 *  蒙版
 */
@property(nonatomic,strong)UIView *maskView;

/**
 *  初始化
 *
 *  @param dataArray 数据源
 *
 *  @return self
 */
-(instancetype)initWithDataArray:(NSArray *)dataArray;

/**
 *  显示
 *
 *  @param block
 */
- (void)showPickViewAnimated:(hidePickerViewBlock )block;
@end
