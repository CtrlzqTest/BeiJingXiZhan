//
//  TaxiMsgCellEdit.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/6.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "TaxiMsgCellEdit.h"

@interface TaxiMsgCellEdit ()

@property (nonatomic, strong) UIView *bgView;

@end
@implementation TaxiMsgCellEdit

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)show
{
    if (self.bgView) return;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.bgView addGestureRecognizer:tap];
    
    self.bgView.userInteractionEnabled = YES;
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.2;
    [window addSubview:self.bgView];
    
    [window addSubview:self];
    
}

- (void)close
{
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    [self removeFromSuperview];
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    [self close];
}

@end
