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
    [self initView2];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initView2
{
    // 返回按钮
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self setTextTitleViewWithFrame:CGRectMake(180*ProportionWidth, 0, 120*ProportionWidth, 50*ProportionWidth)title:@"关于我们" fontSize:17.0];
    self.view.backgroundColor = [UIColor whiteColor];
    _web = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _web.backgroundColor = [UIColor clearColor];
    _web.delegate = self;
   // _web.scalesPageToFit = YES;
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
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
     [MBProgressHUD showError:@"网络不给力！" toView:nil];
}
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    //修改服务器页面的meta的值
////    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
////    [webView stringByEvaluatingJavaScriptFromString:meta];
//    
//    [webView stringByEvaluatingJavaScriptFromString:
//     @"var tagHead =document.documentElement.firstChild;"
//     "var tagMeta = document.createElement(\"meta\");"
//     "tagMeta.setAttribute(\"http-equiv\", \"Content-Type\");"
//     "tagMeta.setAttribute(\"content\", \"text/html; charset=utf-8\");"
//     "var tagHeadAdd = tagHead.appendChild(tagMeta);"];
//    
//    [webView stringByEvaluatingJavaScriptFromString:
//     @"var tagHead =document.documentElement.firstChild;"
//     "var tagStyle = document.createElement(\"style\");"
//     "tagStyle.setAttribute(\"type\", \"text/css\");"
//     "tagStyle.appendChild(document.createTextNode(\"img{width:100% !important;height:auto !important;}\"));"
//     "var tagHeadAdd = tagHead.appendChild(tagStyle);"];
//}
@end
