//
//  MianZeViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/10.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "MianZeViewController.h"

#import "UIViewController+AYCNavigationItem.h"

@interface MianZeViewController ()<UIWebViewDelegate>
@property(nonatomic,retain)UIImageView *imgV;
@property(nonatomic,retain)UIWebView *web;
@end

@implementation MianZeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWebView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark webMethod
-(void)initWebView
{
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
//    [self setTextTitleViewWithFrame:CGRectMake(180*ProportionWidth, 0, 120*ProportionWidth, 50*ProportionWidth)title:@"免责申明条款" fontSize:17.0];
    self.title = @"免责申明条款";
    self.view.backgroundColor = [UIColor whiteColor];

    _web = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _web.delegate = self;
    
    [self.view addSubview:_web];
    NSString *strUrl = [BaseAPI stringByAppendingString:kMianzeAPI];
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
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
@end
