//
//  LoginViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/9.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "LoginViewController.h"
#import "MianZeViewController.h"
@interface LoginViewController ()
{
    BOOL _isAgree;
}
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
    self.title = @"登录";
    [self.autoLoginSwitch setOn:NO];
}

// 自动登录按钮
- (IBAction)autoLoginAction:(id)sender {
    
}

// 同意免责
- (IBAction)agreeAction:(id)sender {
    
    self.agreeBtn.selected = !self.agreeBtn.selected;
    if (self.agreeBtn.selected) {
        [self.agreeBtn setImage:[UIImage imageNamed:@"agreeSelect"] forState:(UIControlStateNormal)];
    }else {
        [self.agreeBtn setImage:[UIImage imageNamed:@"agreeUnSelect"] forState:(UIControlStateNormal)];
    }
    
}

// 免责声明
- (IBAction)impunityAction:(id)sender {
    MianZeViewController *vc = [[MianZeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 登录
- (IBAction)loginAction:(id)sender {
    
    if (![self checkInput]) {
        return ;
    }
    __weak typeof(self) weakSelf = self;
    [MHNetworkManager postReqeustWithURL:kLoginAPI params:@{@"tel":self.userNameLabel.text,@"password":self.passWordLabel.text} successBlock:^(id returnData) {
        
        [User shareUser].isLogin = YES;
        if (weakSelf.autoLoginSwitch.isOn) {
            [Utility setLoginStates:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ZQdidLoginNotication object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];
}

- (BOOL )checkInput {
    
    
    if (self.userNameLabel.text.length <= 0) {
        [MBProgressHUD showError:@"用户名不能为空" toView:nil];
        return NO;
    }
    
    if (self.passWordLabel.text.length <= 0) {
        [MBProgressHUD showError:@"密码不能为空" toView:nil];
        return NO;
    }
    if (![Utility checkPassword:self.passWordLabel.text]) {
        [MBProgressHUD showError:@"密码格式不正确,密码为6-18位数字或字母" toView:nil];
        return NO;
    }
    if (!self.agreeBtn.selected) {
        [MBProgressHUD showError:@"请同意免责声明" toView:nil];
        return NO;
    }
    return YES;
    
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
