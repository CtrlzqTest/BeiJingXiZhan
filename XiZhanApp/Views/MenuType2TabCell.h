//
//  MenuType2TabCell.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/31.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuModel;
static NSString *cellId = @"menuType2";

@interface MenuType2TabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pointImgView;

/**
 *  赋值
 *
 *  @param msgModel MenuModel description
 */
- (void)writeDataWithModel:(MenuModel *)menuModel;
@end
