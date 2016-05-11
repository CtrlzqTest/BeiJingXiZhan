//
//  RegisterViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/10.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "RegisterViewController.h"
#import "MianZeViewController.h"
@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTef;
@property (weak, nonatomic) IBOutlet UITextField *passWordTef;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTef;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)setupViews {
    
    self.getCodeBtn.layer.cornerRadius = 5;
    self.getCodeBtn.layer.borderWidth = 0.2;
    self.getCodeBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.getCodeBtn.highlighted = NO;
    
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
    [MHNetworkManager postReqeustWithURL:kgetCodeAPI params:@{@"tel":self.phoneTef.text} successBlock:^(id returnData) {
        [MBProgressHUD showSuccess:@"获取验证码成功" toView:self.view];
        [weakSelf countDownTime:@60];
        weakSelf.checkCodeTef.text = returnData[@"smscode"];
    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];
    
}

- (IBAction)agreeAction:(id)sender {
    
    self.agreeBtn.selected = !self.agreeBtn.selected;
    if (self.agreeBtn.selected) {
        [self.agreeBtn setImage:[UIImage imageNamed:@"agreeSelect"] forState:(UIControlStateNormal)];
    }else {
        [self.agreeBtn setImage:[UIImage imageNamed:@"agreeUnSelect"] forState:(UIControlStateNormal)];
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
    [MHNetworkManager postReqeustWithURL:kRegisteAPI params:@{@"tel":self.phoneTef.text,@"smscode":self.checkCodeTef.text,@"password":self.passWordTef.text} successBlock:^(id returnData) {
        
        [MBProgressHUD showSuccess:@"注册成功" toView:weakSelf.view];
        [User shareUser].isLogin = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:ZQdidLoginNotication object:nil];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        
    } failureBlock:^(NSError *error) {
        
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
    if (self.checkCodeTef.text.length <= 0) {
        [MBProgressHUD showError:@"请输入验证码" toView:nil];
        return NO;
    }
    if (![Utility checkTelNumber:self.phoneTef.text]) {
        [MBProgressHUD showError:@"手机号格式不正确" toView:nil];
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
