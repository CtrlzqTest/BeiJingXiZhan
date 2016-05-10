//
//  SuggestionsViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/10.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "SuggestionsViewController.h"
#import "UIView+SDAutoLayout.h"
#import "UIViewController+AYCNavigationItem.h"
#import "MianZeViewController.h"

@interface SuggestionsViewController ()
@property(nonatomic,retain)UITextField *phoneField;
@property(nonatomic,retain)UITextView *textView;
@property(nonatomic,retain)UIButton *yesButton;
@property(nonatomic,retain)UIButton *detailButton;
@property(nonatomic,retain)UIButton *registerButton;

@end

@implementation SuggestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setTextTitleViewWithFrame:CGRectMake(180*ProportionWidth, 0, 120*ProportionWidth, 50*ProportionWidth)title:@"意见反馈" fontSize:17.0];
    self.view.backgroundColor = [UIColor colorWithRed:0.773 green:0.153 blue:0.384 alpha:1.000];
    
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.textView.layer.cornerRadius = 5.0;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.borderColor = colorref;
    self.textView.autocapitalizationType = NO;
    
    [self.view addSubview:self.textView];
    
    self.yesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.yesButton.frame = CGRectMake(40*ProportionWidth, CGRectGetMaxY(self.textView.frame) + lineSpace, 30*ProportionWidth, 30*ProportionHeight);
    self.yesButton.layer.cornerRadius = 5.0;
    self.yesButton.layer.masksToBounds = YES;
    self.yesButton.layer.borderWidth = 0.0;
    self.yesButton.layer.borderColor = colorref;
    
    [self.yesButton setImage:[UIImage imageNamed:@"agreeUnSelect.png"] forState:UIControlStateNormal];
    
    [self.yesButton setImage:[UIImage imageNamed:@"agreeSelect.png"] forState:UIControlStateSelected];
    [self.yesButton addTarget:self action:@selector(yesButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.yesButton];

    self.detailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.detailButton.frame = CGRectMake(CGRectGetMaxX(self.yesButton.frame)+10*ProportionWidth, CGRectGetMaxY(self.textView.frame) + lineSpace, 250*ProportionWidth, 30*ProportionHeight);
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

-(void)yesButtonMethod:(UIButton *)sender
{
    sender.selected = !sender.selected;
}
-(void)detailButtonMethod:(UIButton *)sender
{
    MianZeViewController *vc = [[MianZeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)registerButtonMethod:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tapMethod
{
    [self.view endEditing:YES];
}
@end
