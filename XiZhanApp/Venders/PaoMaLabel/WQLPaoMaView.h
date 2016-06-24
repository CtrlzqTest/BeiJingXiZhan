//
//  WQLPaoMaView.h
//  WQLPaoMaView
//
//  Created by WQL on 15/12/28.
//  Copyright © 2015年 WQL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQLPaoMaView : UIView

@property(nonatomic,strong)UILabel *myLable;
@property(nonatomic,strong)UILabel *behindLabel;

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title;

- (void)start;

- (void)stop;

@end
