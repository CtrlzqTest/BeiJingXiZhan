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
   self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initView
{
    NSInteger leftSpace = 40*ProportionWidth;
    NSInteger lineSpace = 25*ProportionHeight;
    
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod)];
    [self.view addGestureRecognizer:tap];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.textView = [[UITextView alloc]init];
    self.textView.frame = CGRectMake(leftSpace, 130*ProportionHeight, KWidth-80, 120);
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.editable = YES;
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.layer.cornerRadius = 15.0;
    self.textView.layer.borderWidth = 3.0;
    self.textView.layer.borderColor = colorref;
    self.textView.autocapitalizationType = NO;
    self.textView.delegate = self;
    
    [self.view addSubview:self.textView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change:) name:UITextViewTextDidChangeNotification object:nil];

    
    self.countTextLabel = [[UILabel alloc]init];
    self.countTextLabel.frame = CGRectMake(KWidth-100*ProportionWidth, CGRectGetMaxY(self.textView.frame) + lineSpace, 60, 15);
    self.countTextLabel.textAlignment = NSTextAlignmentRight;
    self.countTextLabel.font = [UIFont boldSystemFontOfSize:12];
    self.countTextLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    self.countTextLabel.backgroundColor = [UIColor whiteColor];
    self.countTextLabel.text = @"0/100    ";
    [self.view addSubview:self.countTextLabel];
    
    self.yesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.yesButton.frame = CGRectMake(40*ProportionWidth, CGRectGetMaxY(self.countTextLabel.frame) + lineSpace, 30*ProportionWidth, 30*ProportionHeight);
    //self.yesButton.layer.cornerRadius = 5.0;
    //self.yesButton.layer.masksToBounds = YES;
    //self.yesButton.layer.borderWidth = 0.0;
    //self.yesButton.layer.borderColor = colorref;
    
   // self.yesButton.tintColor = [UIColor lightGrayColor];
     [self.yesButton setImage:[UIImage imageNamed:@"autoLogin_unsel"]forState:UIControlStateNormal];
   
    [self.yesButton addTarget:self action:@selector(yesButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.yesButton];

    self.detailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.detailButton.frame = CGRectMake(CGRectGetMaxX(self.yesButton.frame)+10*ProportionWidth, CGRectGetMaxY(self.countTextLabel.frame) + lineSpace, 250*ProportionWidth, 30*ProportionHeight);
    self.detailButton.layer.cornerRadius = 15.0;
    self.detailButton.layer.masksToBounds = YES;
    self.detailButton.layer.borderWidth = 2.0;
    self.detailButton.layer.borderColor = colorref;
    [self.detailButton setTitleColor:[UIColor colorWithRed:0 green:97.0/255 blue:167.0/255 alpha:1.0] forState:UIControlStateNormal];
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
    
    return YES;
}
-(void)change:(NSNotification *)ch
{
    if (self.textView.text.length > textNum) {
        self.countTextLabel.textColor = [UIColor redColor];
        self.textView.text = [self.textView.text substringToIndex:textNum];
    }
    else{
        self.countTextLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }

}
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    self.countTextLabel.text = [NSString stringWithFormat:@"%lu/100    ",(unsigned long)self.textView.text.length];
}
#pragma mark yesButtonMethod
-(void)yesButtonMethod:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (self.yesButton.selected) {
        [self.yesButton setImage:[UIImage imageNamed:@"autoLogin_sel"]forState:UIControlStateNormal];
    }else {
        [self.yesButton setImage:[UIImage imageNamed:@"autoLogin_unsel"]forState:UIControlStateNormal];
    }
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
    [MHNetworkManager postReqeustWithURL:kAppopinion params:@{@"tel":[Utility getUserInfoFromLocal][@"tel"],@"comment":self.textView.text} successBlock:^(id returnData) {
        
        [MBProgressHUD showSuccess:@"意见成功发送" toView:weakSelf.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [weakSelf.navigationController popViewControllerAnimated:YES];
        });
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showSuccess:@"意见发送失败" toView:weakSelf.view];
    } showHUD:YES];

}

-(void)tapMethod
{
    [self.view endEditing:YES];
}

- (BOOL )checkInput {
    
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
