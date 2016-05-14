//
//  InformationDetailViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/11.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "InformationDetailViewController.h"
#import "UIViewController+AYCNavigationItem.h"

@interface InformationDetailViewController ()<UIWebViewDelegate>
@property(nonatomic,retain)UIWebView *myWeb;
@end

@implementation InformationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.isSkip == 1) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"skip" object:nil];
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
    }
}
-(void)backMethod
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)initView
{
   // self.view.backgroundColor = [UIColor blueColor];
    [self setTextTitleViewWithFrame:CGRectMake(180*ProportionWidth, 0, 120*ProportionWidth, 40*ProportionWidth) title:@"详情" fontSize:17.0];
    self.webUrl = @"http://www.baidu.com";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]];
    
    self.myWeb = [[UIWebView alloc]init];
    self.myWeb.frame = CGRectMake(0, 0, KWidth, KHeight);
    self.myWeb.delegate = self;
    [self.view addSubview:self.myWeb];
    [self.myWeb loadRequest:request];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  return YES;
}
@end
