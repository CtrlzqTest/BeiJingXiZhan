//
//  BaseViewController.m
//  91Demo
//
//  Created by zhangqiang on 16/1/15.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"
#import "LeftSlideViewController.h"
#import "AppDelegate.h"

@interface BaseViewController ()
{
    UIImageView *_imgView;
    UILabel *_label;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航栏标题颜色,和字体大小
    [self setNavigationBarTitleColor:[UIColor whiteColor]];
//    // 返回按钮
//    __weak typeof(self) weakSelf = self;
//    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//    }];
    
    [self canSlideMenu:NO];
}

- (void)addNodataViewInView:(UIView *)view {
    
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth/2-30, KHeight/2-80, 75, 85)];
        _imgView.image = [UIImage imageNamed:@"pix2"];
        _imgView.userInteractionEnabled = YES;
        [_imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNoDataView)]];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-20, KHeight/2+10, 60, 25)];
        _label.text = @"暂无数据";
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor lightGrayColor];
    }
    
    [view addSubview:_label];
    [view addSubview:_imgView];
}

- (void)tapNoDataView {
    [self removeNodataView];
}

- (void)removeNodataView {
    [_imgView removeFromSuperview];
    [_label removeFromSuperview];
}

- (void)canSlideMenu:(BOOL )isSlide {
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSliderVC setPanEnabled:isSlide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    _imgView = nil;
    _label = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
