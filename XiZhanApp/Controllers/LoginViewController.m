//
//  LoginViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/9.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passWordLabel;
@property (weak, nonatomic) IBOutlet UISwitch *autoLoginSwitch;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
// 免责按钮
@property (weak, nonatomic) IBOutlet UIButton *impunityBtn;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

// 自动登录按钮
- (IBAction)autoLoginAction:(id)sender {
    
    
}

// 同意免责
- (IBAction)agreeAction:(id)sender {
    
    
}

// 免责声明
- (IBAction)impunityAction:(id)sender {
    
    
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
