//
//  PublishViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/13.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "PublishViewController.h"

@interface PublishViewController ()<UITextFieldDelegate,UITextViewDelegate,LQPhotoPickerViewDelegate>

@property(nonatomic,retain)UIScrollView *ScrollofStatus;
@property(nonatomic,retain)UITextField *fieldOfUser;
@property(nonatomic,retain)UITextField *fieldOfCar;
@property(nonatomic,retain)UIButton *summitButton;
@property(nonatomic,retain)UITextView *miaoShuTextView;
@property(nonatomic,retain)UIButton *photoButton;
@property(nonatomic,strong) UILabel *explainLabel;


@property(nonatomic,strong)NSMutableString *imgString;
@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
}

#pragma mark setChoosePhotoViews

-(void)setchoosePhotoViews
{
    self.LQPhotoPicker_superView = self.ScrollofStatus;
    
    self.LQPhotoPicker_imgMaxCount = 3;
    
    [self LQPhotoPicker_initPickerView];
    
    self.LQPhotoPicker_delegate = self;
    
    _explainLabel = [[UILabel alloc]init];
    _explainLabel.text = @"添加图片不超过3张";
    _explainLabel.textColor = [UIColor whiteColor];
    _explainLabel.textAlignment = NSTextAlignmentCenter;
    _explainLabel.font = [UIFont boldSystemFontOfSize:12];
    
    [self.ScrollofStatus addSubview:_explainLabel];
}
#pragma mark initMethod
-(void)initView
{
    // 返回按钮
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self setRightTextBarButtonItemWithFrame:CGRectMake(330, 0, 40, 30) title:@"提交" titleColor:[UIColor whiteColor] backImage:nil selectBackImage:nil action:^(AYCButton *button) {
        [weakSelf postData];
    }];
    self.imgString = [NSMutableString stringWithFormat:@""];
    [self setTextTitleViewWithFrame:CGRectMake(180*ProportionWidth, 0, 120*ProportionWidth, 50*ProportionWidth)title:@"发布" fontSize:17.0];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.ScrollofStatus = [[UIScrollView alloc]init];
    self.ScrollofStatus.frame = CGRectMake(0,0, KWidth, KHeight);
    self.ScrollofStatus.backgroundColor = [UIColor clearColor];
    self.ScrollofStatus.showsHorizontalScrollIndicator = NO;
    self.ScrollofStatus.layer.cornerRadius = 6;
    self.ScrollofStatus.scrollEnabled = YES;
    self.ScrollofStatus.contentSize = CGSizeMake(0, KHeight);
    [self.view addSubview:self.ScrollofStatus];
    
    [self setchoosePhotoViews];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tapGr.cancelsTouchesInView = NO;
    [self.ScrollofStatus addGestureRecognizer:tapGr];
    [self.view addGestureRecognizer:tapGr];
    
    [self.view addSubview:self.ScrollofStatus];
    
    self.fieldOfUser = [[UITextField alloc]init];
    self.fieldOfUser.borderStyle = UITextBorderStyleRoundedRect;
    self.fieldOfUser.backgroundColor = [UIColor whiteColor];
    
    self.fieldOfUser.enabled = YES;
    self.fieldOfUser.layer.cornerRadius = 20.0;
    self.fieldOfUser.layer.masksToBounds = YES;
    self.fieldOfUser.layer.borderWidth = 3.0;
    self.fieldOfUser.layer.borderColor = colorref;
    self.fieldOfUser.placeholder = @"标题";
    //self.fieldOfUser.textColor = [UIColor colorWithRed:0 green:97.0/255 blue:167.0/255 alpha:1.0];
    self.fieldOfUser.autocapitalizationType = NO;
    self.fieldOfUser.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fieldOfUser.returnKeyType = UIReturnKeyDone;
    self.fieldOfUser.delegate = self;
    [self.ScrollofStatus addSubview:self.fieldOfUser];
    
    self.miaoShuTextView = [[UITextView alloc]init];
    self.miaoShuTextView.backgroundColor = [UIColor whiteColor];
    [self.miaoShuTextView setFont:[UIFont systemFontOfSize:17.0]];
    self.miaoShuTextView.layer.cornerRadius = 15.0;
    self.miaoShuTextView.layer.masksToBounds = YES;
    self.miaoShuTextView.layer.borderWidth = 3.0;
    self.miaoShuTextView.layer.borderColor = colorref;
    self.miaoShuTextView.autocapitalizationType = NO;
    self.miaoShuTextView.delegate = self;
    self.miaoShuTextView.returnKeyType = UIReturnKeyDone;
    [self.ScrollofStatus addSubview: self.miaoShuTextView];
    
    self.photoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.photoButton = self.pickButton;
    self.photoButton.layer.cornerRadius = 5.0;
    self.photoButton.layer.masksToBounds = YES;
    self.photoButton.layer.borderWidth = 0.0;
    self.photoButton.layer.borderColor = colorref;
    [self.photoButton setBackgroundImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
   // [self.photoButton addTarget:self action:@selector(postData) forControlEvents:UIControlEventTouchUpInside];
   // [self.photoButton setTintColor:[UIColor whiteColor]];
    //self.pickButton = self.photoButton;
    [self.ScrollofStatus addSubview:self.photoButton];
    
    self.summitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.summitButton.layer.cornerRadius = 5.0;
    self.summitButton.layer.masksToBounds = YES;
    self.summitButton.layer.borderWidth = 1.0;
    self.summitButton.layer.borderColor = colorref;
    [self.summitButton setBackgroundColor:[UIColor colorWithRed:248.0/255 green:84.0/255 blue:40.0/255 alpha:1]];
    [self.summitButton setTitle:@"发布" forState:UIControlStateNormal];
    [self.summitButton setTintColor:[UIColor whiteColor]];
    [self.summitButton addTarget:self action:@selector(postData) forControlEvents:UIControlEventTouchUpInside];
  //  [self.ScrollofStatus addSubview:self.summitButton];
    [self updateViewsFrame];
    
}
#pragma mark updateFrameMethod
-(void)updateViewsFrame
{
    [self LQPhotoPicker_updatePickerViewFrameY:0];
    
    CGFloat leftInset = 40 * ProportionWidth;
    //说明文字
    _explainLabel.frame = CGRectMake(leftInset, [self LQPhotoPicker_getPickerViewFrame].origin.y+[self LQPhotoPicker_getPickerViewFrame].size.height+10*ProportionHeight, KWidth-80, 20*ProportionHeight);
    // CGFloat height =  + [self LQPhotoPicker_getPickerViewFrame].size.height + 30 + 100;
    
    self.fieldOfUser.frame = CGRectMake(leftInset+10*ProportionWidth,CGRectGetMaxY(_explainLabel.frame) + 20*ProportionHeight, KWidth-100, 40*ProportionHeight);
    self.miaoShuTextView.frame = CGRectMake(leftInset,CGRectGetMaxY(self.fieldOfUser.frame) + 20*ProportionHeight, KWidth-80, 185*ProportionHeight);
    self.summitButton.frame = CGRectMake(leftInset,CGRectGetMaxY(self.miaoShuTextView.frame) + 20*ProportionHeight, KWidth-80, 60*ProportionHeight);
    self.photoButton.frame = CGRectMake(156*ProportionWidth,CGRectGetMaxY(self.summitButton.frame) + 20*ProportionHeight, 64*ProportionHeight, 56*ProportionHeight);
    self.ScrollofStatus.contentSize = CGSizeMake(0, 700*ProportionHeight);
    
}
#pragma mark - 上传数据到服务器前将图片转data
- (void)submitToServer{
    NSMutableArray *bigImageArray = [self LQPhotoPicker_getBigImageArray];
    for (UIImage *item in bigImageArray)
    {
        // CGSize size = CGSizeMake(80, 80);
        //item = [self imageByScalingAndCroppingForSize:size];
        NSData *data = UIImageJPEGRepresentation(item, 0.1f);
        NSString *str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [self.imgString appendString:str];
        [self.imgString appendString:@","];
    }
    NSLog(@"%@",self.imgString);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapAction
{
    [self.view endEditing:YES];
}
#pragma mark postDataMethod
-(void)postData
{
  //  [self submitToServer];
    
    if (![self checkInput]) {
        return;
    }
    if ([self.miaoShuTextView.text isEqualToString:@""]) {
        [MBProgressHUD showMessag:@"请输入详情" toView:self.view];
        return;
    }
    [self submitToServer];
    
  // NSString *str = @"4028900b54a7a7de0154a7a7e0270000";
    __weak typeof(self) weakSelf = self;
    [MHNetworkManager postReqeustWithURL:kMenuAdd params:@{@"msgTitle":self.fieldOfUser.text,@"msgContent":self.miaoShuTextView.text,@"userId":[Utility getUserInfoFromLocal][@"id"],@"parentId":self.parentIdString,@"imgUrl":self.imgString} successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
        
//        if ([self.menuModel.msgType isEqualToString:@"服务台消息"]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:ZQAddServeInfoNotication object:nil];
//        }else {
//            [[NSNotificationCenter defaultCenter] postNotificationName:ZQAddOtherInfoNotication object:nil];
//        }
        [MBProgressHUD showSuccess:@"编辑成功！" toView:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        // 通知列表需要刷新
        if ([self.delegate respondsToSelector:@selector(noticeTableViewRefresh:)]) {
            [self.delegate noticeTableViewRefresh:nil];
        }
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showError:@"发送失败！" toView:nil];
    } showHUD:YES];
}
- (BOOL )checkInput {
    
    if (self.fieldOfUser.text.length <= 0) {
        [MBProgressHUD showError:@"标题不能为空" toView:nil];
        return NO;
    }
    
    if (self.miaoShuTextView.text.length <= 0) {
        [MBProgressHUD showError:@"内容不能为空" toView:nil];
        return NO;
    }
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
@end
