//
//  InformationDetailViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/11.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "InformationDetailViewController.h"
#import "UIViewController+AYCNavigationItem.h"
#import "MessageModel.h"
#import "DJPhotoBrowser.h"
#import "ImgCell.h"
#import <UIImageView+WebCache.h>
#import "WQLPaoMaView.h"

static NSString *indentify = @"proCellX";
#define BIG_IMG_WIDTH 300
#define BIG_IMG_HEIGHT 300
@interface InformationDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DJPhotoBrowserDelegate,UIWebViewDelegate>
@property(nonatomic,retain)UICollectionView *myCollectionV;
@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,retain)UIWebView *web;
@property(nonatomic,retain)UITextField *titleTF;
@property(nonatomic,retain)UITextView *contentTV;
@property(nonatomic,retain)WQLPaoMaView *paoma;
@end

@implementation InformationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 出租车运力消息签到
    if ([self.model.nodeid isEqualToString:@"d5af4d6b_180e_4ac7_a562_f3ae0a585e02"] && [[User shareUser].type isEqualToString:@"5"]) {
        self.isShowSign = YES;
    }else{
        self.isShowSign = NO;
    }
    
    if ([self.model.submitclient isEqualToString:@"2"]) {
        [self initView];
    }
    else if([self.model.submitclient isEqualToString:@"1"])
    {
        [self initWebView];
    }
    
    //[self initWebView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark webMethod
-(void)initWebView
{
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
//    [self setTextTitleViewWithFrame:CGRectMake(180*ProportionWidth, 0, 120*ProportionWidth, 40*ProportionWidth) title:@"详情" fontSize:17.0];
    self.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
  
    _paoma = [[WQLPaoMaView alloc]initWithFrame:CGRectMake(50*ProportionWidth,80*ProportionHeight, KWidth-100*ProportionWidth, 40*ProportionHeight) withTitle:self.model.msgtitle];
    [self.view addSubview:_paoma];
    
    _web = [[UIWebView alloc]initWithFrame:CGRectMake(20*ProportionWidth,CGRectGetMaxY(_paoma.frame)+10*ProportionHeight, KWidth-40*ProportionWidth, 450*ProportionHeight)];
    [self addWebMethod];
}
#pragma mark uiwebviewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)initView
{
    // 返回按钮
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];

    self.imageArray = [NSMutableArray array];

    if (![self.model.imgurl isEqualToString: @"1"])
    {
        NSArray *array = [self.model.imgurl componentsSeparatedByString:@","];
        
        for (NSInteger i = 0; i < array.count; i++) {
            NSString *item = [BaseXiZhanImgAPI stringByAppendingString:array[i]];
            [self.imageArray addObject:item];
        }
    }
   self.view.backgroundColor = [UIColor whiteColor];
    [self setTextTitleViewWithFrame:CGRectMake(180*ProportionWidth, 0, 120*ProportionWidth, 40*ProportionWidth) title:@"详情" fontSize:17.0];
    if (self.imageArray.count == 0) {
        UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc]init];
        
        //创建一个UICollectionView
        _myCollectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0,70, 0, 0) collectionViewLayout:flowL];
        _myCollectionV.delegate = self;
        _myCollectionV.dataSource = self;
        //设置背景
        _myCollectionV.backgroundColor = [UIColor clearColor];
        
        //[_myCollectionV registerClass:[ImgCell class] forCellWithReuseIdentifier:indentify];
        [_myCollectionV registerNib:[UINib nibWithNibName:@"ImgCell" bundle:nil] forCellWithReuseIdentifier:indentify];
        [self.view addSubview:_myCollectionV];
    }
    else
    {
        [self addCollectionView];
    }

    CGFloat leftInset = 40*ProportionWidth;
    
    _paoma = [[WQLPaoMaView alloc]initWithFrame:CGRectMake(leftInset+10*ProportionWidth,CGRectGetMaxY(_myCollectionV.frame)+5*ProportionHeight, KWidth-100*ProportionWidth, 40*ProportionHeight) withTitle:self.model.msgtitle];
   // _paoma.myLable.textColor = mainColor;
    //_paoma.behindLabel.textColor = mainColor;
    [self.view addSubview:_paoma];
    
    _web = [[UIWebView alloc]init];
    _web.frame = CGRectMake(leftInset,CGRectGetMaxY(_paoma.frame) + 20*ProportionHeight, KWidth-2*leftInset, 185*ProportionHeight);
    [self addWebMethod];
    }
-(void)addWebMethod
{
    _web.layer.cornerRadius = 15.0;
    _web.layer.masksToBounds = YES;
    _web.layer.borderWidth = 3.0;
    _web.layer.borderColor = colorref;
    _web.delegate = self;
    [_web setOpaque:NO];
    _web.backgroundColor = [UIColor clearColor];
    _web.scalesPageToFit = YES;
    NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
                            "<head> \n"
                            "<meta name='viewport' content='user-scalable=yes, width=device-width,maximum-scale = 3.0, minimum-scale=1.0' />\n"
                            "<style type=\"text/css\"> \n"
                            "body {font-size: %d; font-family: \"%@\"; color: %@;}\n"
                            "img{display: block;padding:0;margin:0;width:%@;max-width: %@;height: auto !important;}\n"
                            "</style> \n"
                            "</head> \n"
                            "<body>%@</body> \n"
                            "</html>",14, @"FZLTXHK", @"rgb(0, 0, 0)",@"100% !important",@"100% !important",self.model.msgcontent];
    [_web loadHTMLString:htmlString baseURL:nil];
    [self.view addSubview: _web];
    
    if (!self.isShowSign) {
        return;
    }
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    signBtn.frame = CGRectMake(0, CGRectGetMaxY(_web.frame) + 20, 80, 35);
    if (self.model.issign) {
        signBtn.backgroundColor = [UIColor colorWithWhite:0.758 alpha:0.649];
        signBtn.userInteractionEnabled = NO;
    }else {
        signBtn.backgroundColor = mainColor;
    }
    
    [signBtn setTitleColor:[UIColor colorWithRed:1.000 green:0.873 blue:0.377 alpha:1.000] forState:UIControlStateNormal];
    signBtn.layer.cornerRadius = 5;
    [signBtn setTitle:@"签到" forState:UIControlStateNormal];
    signBtn.center = CGPointMake(KWidth / 2.0, signBtn.center.y);
    [self.view addSubview:signBtn];
    
    [signBtn addTarget:self action:@selector(signAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)signAction:(UIButton *)sender {
    
    [RequestManager getRequestWithURL:kTaxiSignInAPI paramer:@{@"contentid":self.model.msgid} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            self.model.issign = YES;
            [self.model updateWithCondition:[NSString stringWithFormat:@"msgid = '%@'",self.model.msgid]];
            [MBProgressHUD showSuccess:@"签到成功" toView:self.view];
            sender.backgroundColor = [UIColor colorWithWhite:0.758 alpha:0.649];
            sender.userInteractionEnabled = NO;
        }else if([responseObject[@"code"] integerValue] == -1){
            self.model.issign = YES;
            [self.model updateWithCondition:[NSString stringWithFormat:@"msgid = '%@'",self.model.msgid]];
            [MBProgressHUD showSuccess:@"已过期" toView:self.view];
            sender.backgroundColor = [UIColor colorWithWhite:0.758 alpha:0.649];
            sender.userInteractionEnabled = NO;

        }
    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showHUD:YES];
    

}


-(void)addCollectionView
{
    UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc]init];
    
    //创建一个UICollectionView
    _myCollectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0,10*ProportionHeight, KWidth, 190*ProportionHeight) collectionViewLayout:flowL];
    //设置代理为当前控制器
    _myCollectionV.delegate = self;
    _myCollectionV.dataSource = self;
    //设置背景
    _myCollectionV.backgroundColor = [UIColor clearColor];
    
    //[_myCollectionV registerClass:[ImgCell class] forCellWithReuseIdentifier:indentify];
    [_myCollectionV registerNib:[UINib nibWithNibName:@"ImgCell" bundle:nil] forCellWithReuseIdentifier:indentify];
    //添加视图
    [self.view addSubview:_myCollectionV];
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section有多少个元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imageArray count];
}
//每个单元格的数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImgCell *cell = (ImgCell *)[collectionView dequeueReusableCellWithReuseIdentifier:indentify forIndexPath:indexPath];
   // [cell.imgOfCell sd_setImageWithURL:[NSURL URLWithString:self.imageArray[indexPath.row]]];
    [cell.imgOfCell sd_setImageWithURL:[NSURL URLWithString:self.imageArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"default"]];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100*ProportionWidth, 100*ProportionWidth);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //return UIEdgeInsetsMake(5*ProportionWidth, 5*ProportionWidth, 5*ProportionWidth, 5*ProportionWidth);
    return UIEdgeInsetsMake(5, 20, 5,10);
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *str = self.imageArray[indexPath.row];
//    str = [str stringByReplacingOccurrencesOfString:@"http://192.168.16.147:8080/oa/" withString:@""];
//    NSLog(@"%@",str);
//    CheckImageViewController *view = [[CheckImageViewController alloc]init];
//    view.imgURLString = str;
//    [self.navigationController pushViewController:view animated:YES];
//}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DJPhotoBrowser *browser = [[DJPhotoBrowser alloc] init];
    browser.currentImageIndex = indexPath.row;
    browser.sourceImagesContainerView = self.myCollectionV;
    browser.imageCount = self.imageArray.count;
    browser.delegate = self;
    [browser show];
}

- (NSURL *)photoBrowser:(DJPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = self.imageArray[index];
    return [NSURL URLWithString:urlStr];
}

- (UIImage *)photoBrowser:(DJPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    
    int newRow = index % 3;
    __weak ImgCell *cell = (ImgCell *)[self.myCollectionV cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (newRow == 2) {
        CGRect rect = [self.myCollectionV convertRect:cell.frame toView:self.view];
        if (rect.origin.y <= 250) {
            NSInteger row = index - 3;
            if (row>=0) {
                [self.myCollectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            }
        }
        if (rect.origin.y >= self.view.frame.size.height-250) {
            NSInteger row = index + 1;
            if (row < self.imageArray.count) {
                [self.myCollectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            }
        }
    }
    return cell.imgOfCell.image;
}

@end
