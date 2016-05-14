//
//  InformationDetailViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/11.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "InformationDetailViewController.h"
#import "UIViewController+AYCNavigationItem.h"
#import "MessageModel.h"
#import "UIImageView+AFNetworking.h"
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

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    if (self.isSkip == 1) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"skip" object:nil];
////        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
//    }
//}
//-(void)backMethod
//{
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//}
-(void)initView
{
   self.view.backgroundColor = [UIColor whiteColor];
    [self setTextTitleViewWithFrame:CGRectMake(180*ProportionWidth, 0, 120*ProportionWidth, 40*ProportionWidth) title:@"详情" fontSize:17.0];
    
    self.webUrl = self.model.msgtitle;
    self.webUrl = [self.webUrl stringByAppendingString:@"   "];
    self.webUrl = [self.webUrl stringByAppendingString:self.model.msgcontent];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 0, KWidth, KHeight*1.0/3);
    label.text = [NSString stringWithFormat:@"%@",self.webUrl];
    [self.view addSubview:label];
    
    NSArray *array = [self.model.imgurl componentsSeparatedByString:@","];
    if (array.count == 0) {
        
    }
    else
    {
        for (int i = 0;i < array.count ;i++) {
            UIImageView *imgv = [[UIImageView alloc]init];
            imgv.frame = CGRectMake(i*1.0/3*KWidth, 1.0/3*KHeight, 1.0/3*KWidth-20*ProportionWidth, 1.0/3*KHeight);
           [imgv setImageWithURL:[NSURL URLWithString:array[i]]];
            [self.view addSubview:imgv];
        }
    }
}

@end
