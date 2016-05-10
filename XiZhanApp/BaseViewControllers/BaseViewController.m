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

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self canSlideMenu:NO];
    // Do any additional setup after loading the view.
}

- (void)canSlideMenu:(BOOL )isSlide {
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSliderVC setPanEnabled:isSlide];
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
