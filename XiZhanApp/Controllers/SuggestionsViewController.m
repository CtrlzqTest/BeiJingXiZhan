//
//  SuggestionsViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/10.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "SuggestionsViewController.h"
#import "UIViewController+AYCNavigationItem.h"
#import "MianZeViewController.h"

#define textNum 100
@interface SuggestionsViewController ()<UITextViewDelegate>

@property(nonatomic,retain)UITextField *phoneField;
@property(nonatomic,retain)UITextView *textView;
@property(nonatomic,retain)UILabel *countTextLabel;
@property(nonatomic,retain)UIButton *yesButton;
@property(nonatomic,retain)UIButton *detailButton;
@property(nonatomic,retain)UIButton *registerButton;

@end

@implementation SuggestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setTextTitleViewWithFrame:CGRectMake(180*ProportionWidth, 0, 120*ProportionWidth, 50*ProportionWidth)title:@"意见反馈" fontSize:17.0];
//    self.view.backgroundColor = [UIColor colorWithRed:0.773 green:0.153 blue:0.384 alpha:1.000];
    self.view.backgroundColor = [UIColor blueColor];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initView
{
    NSInteger leftSpace = 40*ProportionWidth;
    NSInteger lineSpace = 25*ProportionHeight;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod)];
    [self.view addGestureRecognizer:tap];
    
    self.phoneField = [[UITextField alloc]init];
    self.phoneField.frame = CGRectMake(leftSpace, 80*ProportionHeight, KWidth-80*ProportionWidth, 40*ProportionHeight);
    self.phoneField.placeholder = @"手机号";
    self.phoneField.returnKeyType = UIReturnKeyDone;
    self.phoneField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneField.backgroundColor = [UIColor whiteColor];
    self.phoneField.enabled = YES;
    self.phoneField.font = [UIFont systemFontOfSize:17];
    self.phoneField.layer.cornerRadius = 5.0;
    self.phoneField.layer.masksToBounds = YES;
    self.phoneField.layer.borderWidth = 1.0;
    self.phoneField.layer.borderColor = colorref;
    self.phoneField.autocapitalizationType = NO;
    self.phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:self.phoneField];
    
    self.textView = [[UITextView alloc]init];
    self.textView.frame = CGRectMake(leftSpace, CGRectGetMaxY(self.phoneField.frame) + lineSpace, KWidth-80, 120);
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.editable = YES;
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.layer.cornerRadius = 5.0;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.borderColor = colorref;
    self.textView.autocapitalizationType = NO;
    self.textView.delegate = self;
    
    [self.view addSubview:self.textView];
    
    self.countTextLabel = [[UILabel alloc]init];
    self.countTextLabel.frame = CGRectMake(KWidth-100*ProportionWidth, CGRectGetMaxY(self.textView.frame) + lineSpace, 60, 15);
    self.countTextLabel.textAlignment = NSTextAlignmentRight;
    self.countTextLabel.font = [UIFont boldSystemFontOfSize:12];
    self.countTextLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    self.countTextLabel.backgroundColor = [UIColor whiteColor];
    self.countTextLabel.text = @"0/100    ";
    [self.view addSubview:self.countTextLabel];
    
    self.yesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.yesButton.frame = CGRectMake(40*ProportionWidth, CGRectGetMaxY(self.countTextLabel.frame) + lineSpace, 30*ProportionWidth, 30*ProportionHeight);
    self.yesButton.layer.cornerRadius = 5.0;
    self.yesButton.layer.masksToBounds = YES;
    self.yesButton.layer.borderWidth = 0.0;
    self.yesButton.layer.borderColor = colorref;
    
    [self.yesButton setImage:[UIImage imageNamed:@"agreeUnSelect.png"] forState:UIControlStateNormal];
    
    [self.yesButton setImage:[UIImage imageNamed:@"agreeSelect.png"] forState:UIControlStateSelected];
    [self.yesButton addTarget:self action:@selector(yesButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.yesButton];

    self.detailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.detailButton.frame = CGRectMake(CGRectGetMaxX(self.yesButton.frame)+10*ProportionWidth, CGRectGetMaxY(self.countTextLabel.frame) + lineSpace, 250*ProportionWidth, 30*ProportionHeight);
    self.detailButton.layer.cornerRadius = 5.0;
    self.detailButton.layer.masksToBounds = YES;
    self.detailButton.layer.borderWidth = 1.0;
    self.detailButton.layer.borderColor = colorref;
    [self.detailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.detailButton setTitle:@"同意《免责申明和隐私权条款》" forState:UIControlStateNormal];
    [self.detailButton addTarget:self action:@selector(detailButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.detailButton];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.registerButton.frame = CGRectMake(80*ProportionWidth, CGRectGetMaxY(self.detailButton.frame) + 40*ProportionHeight, 200*ProportionWidth, 50*ProportionHeight);
    self.registerButton.layer.cornerRadius = 5.0;
    self.registerButton.layer.masksToBounds = YES;
    self.registerButton.layer.borderWidth = 1.0;
    self.registerButton.layer.borderColor = colorref;
    
    [self.registerButton setBackgroundColor:[UIColor orangeColor]];
    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registerButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(registerButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
    
}
#pragma mark textViewMethod
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    self.countTextLabel.text = [NSString stringWithFormat:@"%lu/100    ",(unsigned long)self.textView.text.length];
    if (self.textView.text.length >= textNum) {
         self.countTextLabel.textColor = [UIColor redColor];
         NSString *str = [self.textView.text substringToIndex:textNum];
         self.textView.text = str;
    }
    else{
         self.countTextLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    self.countTextLabel.text = [NSString stringWithFormat:@"%lu/100    ",(unsigned long)self.textView.text.length];
    if (self.textView.text.length >= textNum) {
         self.countTextLabel.textColor = [UIColor redColor];
        NSString *str = [self.textView.text substringToIndex:textNum];
        self.textView.text = str;
    }
    else{
         self.countTextLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
}
#pragma mark yesButtonMethod
-(void)yesButtonMethod:(UIButton *)sender
{
    sender.selected = !sender.selected;
}
#pragma mark detailButtonMethod
-(void)detailButtonMethod:(UIButton *)sender
{
    MianZeViewController *vc = [[MianZeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark registerButtonMethod
-(void)registerButtonMethod:(UIButton *)sender
{
    
    if (![self checkInput]) {
        return ;
    }
    __weak typeof(self) weakSelf = self;
    [MHNetworkManager postReqeustWithURL:kAppopinion params:@{@"tel":self.phoneField.text,@"comment":self.textView.text} successBlock:^(id returnData) {
        
        [MBProgressHUD showSuccess:@"意见成功发送" toView:weakSelf.view];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showSuccess:@"意见发送失败" toView:weakSelf.view];
    } showHUD:YES];

}

-(void)tapMethod
{
    [self.view endEditing:YES];
}

- (BOOL )checkInput {
    
    
    if (self.phoneField.text.length <= 0) {
        [MBProgressHUD showError:@"手机号不能为空" toView:nil];
        return NO;
    }
    if (![Utility checkTelNumber:self.phoneField.text]) {
        [MBProgressHUD showError:@"手机号格式不正确" toView:nil];
        return NO;
    }
    if (self.textView.text.length <= 0) {
        [MBProgressHUD showError:@"意见不能为空" toView:nil];
        return NO;
    }
    if (!self.yesButton.selected) {
        [MBProgressHUD showError:@"请同意免责声明" toView:nil];
        return NO;
    }
    return YES;
}


@end
