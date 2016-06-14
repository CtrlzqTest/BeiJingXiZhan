//
//  ZQChooseView.h
//  JinYeFeiLinOA
//
//  Created by zhangqiang on 16/4/7.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickBtnBlock)(NSInteger selectIndex);

typedef enum : NSUInteger {
    ZQChooseTypeSingle,     // 单选
    ZQChooseTypeMore,       // 多选
} ZQChooseType;

@interface ZQChooseView : UIView

/**
 *  初始化
 */
-(instancetype)initWithDataSource:(NSArray *)titleArray chooseType:(ZQChooseType )chooseType;

/**
 *  显示
 */
- (void)showChooseViewCallBack:(clickBtnBlock )clickBtn;

@end
