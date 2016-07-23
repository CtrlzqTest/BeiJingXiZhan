//
//  RegisterViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/10.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "RegisterViewController.h"
#import "MianZeViewController.h"
#import "ZQPickerView.h"
#import "JPUSHService.h"

@interface RegisterViewController (){
    NSArray *_userTypeArray;
    NSInteger _chooseIndex;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneTef;
@property (weak, nonatomic) IBOutlet UITextField *passWordTef;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTef;
@property (weak, nonatomic) IBOutlet UIButton *userTypeBtn;

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@property (nonatomic,strong)ZQPickerView *pickerView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self setupViews];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod)];
    [self.view addGestureRecognizer:tap];
}
-(void)tapMethod
{
    [self.view endEditing:YES];
}
- (void)setupViews {
    
    // 返回按钮
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];

//    self.getCodeBtn.layer.cornerRadius = 20;
//    self.getCodeBtn.layer.borderWidth = 2.5;
//    self.getCodeBtn.layer.borderColor = colorref;
//    self.getCodeBtn.highlighted = NO;
    
    self.phoneTef.layer.borderWidth = 2.5;
    self.phoneTef.layer.borderColor = colorref;
    self.phoneTef.layer.cornerRadius = 20;
    self.phoneTef.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.phoneTef.leftViewMode = UITextFieldViewModeAlways;
    
    self.passWordTef.layer.borderWidth = 2.5;
    self.passWordTef.layer.borderColor = colorref;
    self.passWordTef.layer.cornerRadius = 20;
    self.passWordTef.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.passWordTef.leftViewMode = UITextFieldViewModeAlways;
    
    self.checkCodeTef.layer.borderWidth = 2.5;
    self.checkCodeTef.layer.borderColor = colorref;
    self.checkCodeTef.layer.cornerRadius = 20;
    self.checkCodeTef.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.checkCodeTef.leftViewMode = UITextFieldViewModeAlways;
    
    self.userTypeBtn.layer.borderWidth = 0.5;
    self.userTypeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.userTypeBtn.layer.cornerRadius = 3;
    [self.userTypeBtn addTarget:self action:@selector(userTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _userTypeArray = @[@"旅客",@"出租车司机"];
    
}

- (void)userTypeAction:(UIButton *)sender {
    
    [self resignKeyBoardInView:self.view];
    
    __block ZQPickerView *pickerView = [[ZQPickerView alloc] initWithDataArray:_userTypeArray];
    
    __weak typeof(self) weakSelf = self;
    [pickerView showPickViewAnimated:^(NSInteger index) {
        _chooseIndex = index + 1;
        [weakSelf.userTypeBtn setTitle:_userTypeArray[index] forState:UIControlStateNormal];
//        [weakSelf.userTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        pickerView = nil;
    }];
    
}

- (IBAction)getCodeAction:(id)sender {
    
    if (self.phoneTef.text.length <= 0) {
        [MBProgressHUD showError:@"手机号不能为空" toView:nil];
        return;
    }
    if (![Utility checkTelNumber:self.phoneTef.text]) {
        [MBProgressHUD showError:@"手机号格式不正确" toView:nil];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [RequestManager postRequestWithURL:kgetCodeAPI paramer:@{@"tel":self.phoneTef.text} success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD showSuccess:@"获取验证码成功" toView:self.view];
        [weakSelf countDownTime:@60];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showSuccess:@"获取验证码失败" toView:self.view];
    } showHUD:YES];
    
}

- (IBAction)agreeAction:(id)sender {
    
    self.agreeBtn.selected = !self.agreeBtn.selected;
    if (self.agreeBtn.selected) {
        [self.agreeBtn setImage:[UIImage imageNamed:@"autoLogin_sel"] forState:(UIControlStateNormal)];
    }else {
        [self.agreeBtn setImage:[UIImage imageNamed:@"autoLogin_unsel"] forState:(UIControlStateNormal)];
    }
    
}

// 免责
- (IBAction)showImpunityAction:(id)sender {
    MianZeViewController *vc = [[MianZeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 注册
- (IBAction)registerAction:(id)sender {
    
    if (![self checkInput]) {
        return ;
    }
    __weak typeof(self) weakSelf = self;
    NSString *type = nil;
    if (_chooseIndex == 2) {
        type = @"5";
    }else {
        type = @"1";
    }
    
    [RequestManager postRequestWithURL:kRegisteAPI paramer:@{@"tel":self.phoneTef.text,@"smscode":self.checkCodeTef.text,@"password":self.passWordTef.text,@"type":type} success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"error_code"] isEqualToString:@"20000"]) {
            [MBProgressHUD showSuccess:@"服务器异常" toView:weakSelf.view];
            return ;
        }
        
        if ([responseObject[@"message_code"] isEqualToString:@"10000"]) {
            
            [MBProgressHUD showSuccess:@"注册成功" toView:nil];
            [User shareUser].isLogin = YES;
            [[User shareUser] resetUserInfo:responseObject[@"user"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:ZQdidLoginNotication object:nil];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            
            NSString *userType = [[User shareUser].type isEqualToString:@"1"] ? @"passenger" : @"taxi_driver";
            [JPUSHService setTags:[NSSet setWithObject:userType] alias:[User shareUser].tel fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                
            }];
        }else {
            [MBProgressHUD showSuccess:responseObject[@"errmsg"] toView:weakSelf.view];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showHUD:YES];
    
}

- (BOOL )checkInput {
    
    
    if (self.phoneTef.text.length <= 0) {
        [MBProgressHUD showError:@"手机不能为空" toView:nil];
        return NO;
    }
    if (self.passWordTef.text.length <= 0) {
        [MBProgressHUD showError:@"密码不能为空" toView:nil];
        return NO;
    }
    if (![Utility checkPassword:self.passWordTef.text]) {
        [MBProgressHUD showError:@"密码格式不正确,密码为6-18位数字或字母" toView:nil];
        return NO;
    }
    if (self.checkCodeTef.text.length <= 0) {
        [MBProgressHUD showError:@"请输入验证码" toView:nil];
        return NO;
    }
    if (![Utility checkTelNumber:self.phoneTef.text]) {
        [MBProgressHUD showError:@"手机号格式不正确" toView:nil];
        return NO;
    }
    if (!_chooseIndex) {
        [MBProgressHUD showError:@"请选择用户类型" toView:nil];
        return NO;
    }
    if (!self.agreeBtn.selected) {
        [MBProgressHUD showError:@"请同意免责声明" toView:nil];
        return NO;
    }

    return YES;
    
}

/**
 *  倒计时函数
 */
-(void)countDownTime:(NSNumber *)sourceDate{
    
    [self.getCodeBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    self.getCodeBtn.enabled = NO;
    __block int timeout = sourceDate.intValue; //倒计时时间
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatchQueue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 1){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //界面的设置
                [weakSelf.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.getCodeBtn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
                weakSelf.getCodeBtn.enabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //界面的设置
                NSString *numStr=[NSString stringWithFormat:@"剩余%d秒",timeout];
//                [weakSelf.getCodeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [weakSelf.getCodeBtn setTitle:numStr forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
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
