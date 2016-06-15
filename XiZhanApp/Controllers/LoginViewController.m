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
@property (weak, nonatomic) IBOutlet UIButton *autoLoginSwitch;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
// 免责按钮
@property (weak, nonatomic) IBOutlet UIButton *impunityBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod)];
    [self.view addGestureRecognizer:tap];
    [self setupViews];
}

- (void)setupViews {
    
    // 返回按钮
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    self.userNameLabel.layer.borderWidth = 2.5;
    self.userNameLabel.layer.borderColor = colorref;
    self.userNameLabel.layer.cornerRadius = 20;
    self.userNameLabel.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.userNameLabel.leftViewMode = UITextFieldViewModeAlways;
    
    self.passWordLabel.layer.borderWidth = 2.5;
    self.passWordLabel.layer.borderColor = colorref;
    self.passWordLabel.layer.cornerRadius = 20;
    self.passWordLabel.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.passWordLabel.leftViewMode = UITextFieldViewModeAlways;
    
    NSDictionary *infoDict = [Utility getUserInfoFromLocal];
    if ([infoDict[@"tel"] length] > 0) {
        self.userNameLabel.text = infoDict[@"tel"];
    }
    
}

-(void)tapMethod
{
    [self.view endEditing:YES];
}
// 自动登录按钮
- (IBAction)autoLoginAction:(id)sender {
    
    self.autoLoginSwitch.selected = !self.autoLoginSwitch.selected;
    if (self.autoLoginSwitch.selected) {
        [self.autoLoginSwitch setImage:[UIImage imageNamed:@"autoLogin_sel"] forState:(UIControlStateNormal)];
    }else {
        [self.autoLoginSwitch setImage:[UIImage imageNamed:@"autoLogin_unsel"] forState:(UIControlStateNormal)];
    }
    
}

// 忘记密码
- (IBAction)resetPwdAction:(id)sender {
    
    
    
}


// 同意免责
- (IBAction)agreeAction:(id)sender {
    
    self.agreeBtn.selected = !self.agreeBtn.selected;
    if (self.agreeBtn.selected) {
        [self.agreeBtn setImage:[UIImage imageNamed:@"autoLogin_sel"] forState:(UIControlStateNormal)];
    }else {
        [self.agreeBtn setImage:[UIImage imageNamed:@"autoLogin_unsel"] forState:(UIControlStateNormal)];
    }
    
}

// 免责声明
- (IBAction)impunityAction:(id)sender {
    
    MianZeViewController *vc = [[MianZeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 登录
- (IBAction)loginAction:(id)sender {
    
    NSString *pwd = [Utility md5:self.passWordLabel.text];
    if (![self checkInput]) {
        return ;
    }
    __weak typeof(self) weakSelf = self;
//    NSString *pwd = [Utility md5:self.passWordLabel.text];
    [MHNetworkManager postReqeustWithURL:kLoginAPI params:@{@"tel":self.userNameLabel.text,@"password":pwd} successBlock:^(id returnData) {
        
        if ([returnData[@"message"] isEqualToString:@"success"]) {
            
//            [Utility saveUserInfo:returnData[@"user"]];
            [User shareUser].isLogin = YES;
            [[User shareUser] resetUserInfo:returnData[@"user"]];
            if (weakSelf.autoLoginSwitch.selected) {
                [Utility setLoginStates:YES];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:ZQdidLoginNotication object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }else {
            [MBProgressHUD showError:@"密码与用户名不匹配" toView:nil];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showError:@"服务器异常" toView:nil];
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
