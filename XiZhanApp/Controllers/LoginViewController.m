//
//  LoginViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/9.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "LoginViewController.h"
#import "MianZeViewController.h"
#import "JPUSHService.h"

@interface LoginViewController ()
{
    BOOL _isAgree;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginTopInset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mianzeTopinset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tefHeght;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnHeght;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registTop;
@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passWordLabel;
@property (weak, nonatomic) IBOutlet UIButton *autoLoginSwitch;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
// 免责按钮
@property (weak, nonatomic) IBOutlet UIButton *impunityBtn;

@property(nonatomic,strong)UIImageView *backImgView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod)];
    [self.view addGestureRecognizer:tap];
    self.backImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.backImgView.image = [UIImage imageNamed:@"main_bg"];
    [self.view addSubview:self.backImgView];
    [self setupViews];
    [self.view sendSubviewToBack:self.backImgView];
}

- (void)setupViews {
    
    // 返回按钮
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    self.top.constant = 40 * ProportionHeight;
    self.loginTopInset.constant = 25 * ProportionHeight;
    self.mianzeTopinset.constant = 20 * ProportionHeight;
    self.tefHeght.constant = 40 * ProportionHeight;
    self.loginBtnHeght.constant = 45 * ProportionHeight;
    self.registTop.constant = 25 * ProportionHeight;
    
    self.userNameLabel.layer.borderWidth = 2.5;
    self.userNameLabel.layer.borderColor = colorref;
    self.userNameLabel.layer.cornerRadius = 20 * ProportionHeight;
    self.userNameLabel.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.userNameLabel.leftViewMode = UITextFieldViewModeAlways;
    
    self.passWordLabel.layer.borderWidth = 2.5;
    self.passWordLabel.layer.borderColor = colorref;
    self.passWordLabel.layer.cornerRadius = 20 * ProportionHeight;
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
    
//    NSString *pwd = [Utility md5:self.passWordLabel.text];
    NSString *pwd = self.passWordLabel.text;
    if (![self checkInput]) {
        return ;
    }
    __weak typeof(self) weakSelf = self;
    [RequestManager postRequestWithURL:kLoginAPI paramer:@{@"tel":self.userNameLabel.text,@"password":pwd} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"message"] isEqualToString:@"success"]) {
            
            [User shareUser].isLogin = YES;
            [[User shareUser] resetUserInfo:responseObject[@"user"]];
            if (weakSelf.autoLoginSwitch.selected) {
                [Utility setLoginStates:YES];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:ZQdidLoginNotication object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            NSString *userType = [Utility getTagWithuserType:[User shareUser].type];
            [JPUSHService setTags:[NSSet setWithObject:userType] alias:[User shareUser].tel fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                
            }];
            
        }else {
            [MBProgressHUD showError:@"密码与用户名不匹配" toView:nil];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showHUD:YES];
    
}

- (BOOL )checkInput {
    
    if (self.userNameLabel.text.length <= 0) {
        [MBProgressHUD showError:@"用户名不能为空" toView:nil];
        return NO;
    }
    
    if (self.passWordLabel.text.length <= 0) {
        [MBProgressHUD showError:@"亲输入密码" toView:nil];
        return NO;
    }
//    if (![Utility checkPassword:self.passWordLabel.text]) {
//        [MBProgressHUD showError:@"密码必须是6-18位数字和字母组合" toView:nil];
//        return NO;
//    }
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
