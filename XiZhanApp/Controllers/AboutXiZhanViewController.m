//
//  AboutXiZhanViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/26.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "AboutXiZhanViewController.h"

@interface AboutXiZhanViewController ()<UIWebViewDelegate>
@property(nonatomic,retain)UIImageView *imgV;
@property(nonatomic,retain)UIWebView *web;
@end

@implementation AboutXiZhanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self initView];
    [self initView2];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initView
{
    // 返回按钮
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self setTextTitleViewWithFrame:CGRectMake(180*ProportionWidth, 0, 120*ProportionWidth, 50*ProportionWidth)title:@"关于我们" fontSize:17.0];
    // self.view.backgroundColor = [UIColor colorWithRed:0.773 green:0.153 blue:0.384 alpha:1.000];
  //  self.view.backgroundColor = [UIColor blueColor];
    _imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60*ProportionHeight, KWidth, KHeight-60*ProportionHeight)];
    _imgV.image = [UIImage imageNamed:@"about_info.png"];
    [self.view addSubview:_imgV];
}
-(void)initView2
{
    // 返回按钮
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self setTextTitleViewWithFrame:CGRectMake(180*ProportionWidth, 0, 120*ProportionWidth, 50*ProportionWidth)title:@"关于我们" fontSize:17.0];
    _web = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _web.delegate = self;
    
    [self.view addSubview:_web];
    NSString *strUrl = [BaseAPI stringByAppendingString:kAboutUs];
    [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]]];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return NO;
    }
    else
    {
        return YES;
    }
}
@end
