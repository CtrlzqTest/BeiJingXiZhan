//
//  SerVeDetailViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/11.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "SerVeDetailViewController.h"
#import "MessageModel.h"

@interface SerVeDetailViewController ()<UIWebViewDelegate>
@property(nonatomic,copy)NSString *stringOftext;
@end

@implementation SerVeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}

//-(void)viewWillAppear:(BOOL)animated {
//    
//    [super viewWillAppear:YES];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    if (self.isSkip == 1) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"skip" object:nil];
//        //        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
//    }
//}
//-(void)backMethod
//{
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initView
{
    self.stringOftext = self.model.msgtitle;
    self.stringOftext = [self.stringOftext stringByAppendingString:@"\n"];
    self.stringOftext = [self.stringOftext stringByAppendingString:self.model.msgcontent];
    
    UIWebView *web = [[UIWebView alloc]init];
    web.delegate = self;
    web.frame = CGRectMake(0, 0, KWidth, KHeight);
    
    [self.view addSubview:web];
    [web loadHTMLString:self.stringOftext baseURL:nil];
}
@end
