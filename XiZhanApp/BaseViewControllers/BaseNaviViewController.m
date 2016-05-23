//
//  BaseNaviViewController.m
//  91Demo
//
//  Created by zhangqiang on 16/1/15.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "BaseNaviViewController.h"
#import "UIViewController+AYCNavigationItem.h"
#import "UIView+ZQExtention.h"

@interface BaseNaviViewController ()

@end

@implementation BaseNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"naviBack"]];
    [self.navigationBar setGradientLayerStartColor:[UIColor colorWithRed:0.110 green:0.690 blue:0.859 alpha:1.000] endColor:[UIColor colorWithRed:0.067 green:0.388 blue:0.635 alpha:1.000]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
