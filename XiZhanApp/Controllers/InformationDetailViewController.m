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
#import "UIImageView+AFNetworking.h"
#import "DJPhotoBrowser.h"
#import "ImgCell.h"

static NSString *indentify = @"proCellX";
@interface InformationDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DJPhotoBrowserDelegate,UIWebViewDelegate>
@property(nonatomic,retain)UICollectionView *myCollectionV;
@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,retain)UIWebView *web;
@property(nonatomic,retain)UITextField *titleTF;
@property(nonatomic,retain)UITextView *contentTV;
@end

@implementation InformationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self setTextTitleViewWithFrame:CGRectMake(180*ProportionWidth, 0, 120*ProportionWidth, 40*ProportionWidth) title:@"详情" fontSize:17.0];
    self.view.backgroundColor = [UIColor whiteColor];
  
    _titleTF = [[UITextField alloc]init];
    _titleTF.frame = CGRectMake(50*ProportionWidth,80*ProportionHeight, KWidth-100, 40*ProportionHeight);
    _titleTF.borderStyle = UITextBorderStyleRoundedRect;
    _titleTF.backgroundColor = [UIColor whiteColor];
    _titleTF.enabled = NO;
    _titleTF.layer.cornerRadius = 20.0;
    _titleTF.layer.masksToBounds = YES;
    _titleTF.layer.borderWidth = 3.0;
    _titleTF.layer.borderColor = colorref;
    _titleTF.text = self.model.msgtitle;
    _titleTF.adjustsFontSizeToFitWidth = YES;
    _titleTF.textColor = mainColor;
    
    [self.view addSubview:_titleTF];
    
    _web = [[UIWebView alloc]initWithFrame:CGRectMake(20*ProportionWidth,CGRectGetMaxY(_titleTF.frame)+10*ProportionHeight, KWidth-40*ProportionWidth, 450*ProportionHeight)];
    _web.layer.cornerRadius = 20.0;
    _web.layer.masksToBounds = YES;
    _web.layer.borderWidth = 3.0;
    _web.layer.borderColor = colorref;
    _web.delegate = self;
    _web.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_web];
    [_web loadHTMLString:self.model.msgcontent baseURL:nil];
}
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

//    self.webUrl = self.model.msgtitle;
//    self.webUrl = [self.webUrl stringByAppendingString:@"\n"];
//    self.webUrl = [self.webUrl stringByAppendingString:self.model.msgcontent];
//    
//    _web = [[UIWebView alloc]initWithFrame:CGRectMake(20*ProportionWidth, 1.0/3*KHeight, KWidth-40*ProportionWidth, 2.0/3*KHeight)];
//    _web.delegate = self;
//    _web.backgroundColor = [UIColor clearColor];
//   // [self.view addSubview:_web];
//    [_web loadHTMLString:self.webUrl baseURL:nil];
    CGFloat leftInset = 40*ProportionWidth;
    
    _titleTF = [[UITextField alloc]init];
    _titleTF.frame = CGRectMake(leftInset+10*ProportionWidth,CGRectGetMaxY(_myCollectionV.frame)+10*ProportionHeight, KWidth-100, 40*ProportionHeight);
    _titleTF.borderStyle = UITextBorderStyleRoundedRect;
    _titleTF.backgroundColor = [UIColor whiteColor];
    _titleTF.enabled = NO;
    _titleTF.layer.cornerRadius = 20.0;
    _titleTF.layer.masksToBounds = YES;
   _titleTF.layer.borderWidth = 3.0;
    _titleTF.layer.borderColor = colorref;
    _titleTF.text = self.model.msgtitle;
    _titleTF.textColor = mainColor;
   
    [self.view addSubview:_titleTF];

    _contentTV = [[UITextView alloc]init];
        _contentTV.frame = CGRectMake(leftInset,CGRectGetMaxY(_titleTF.frame) + 20*ProportionHeight, KWidth-80, 185*ProportionHeight);
    _contentTV.backgroundColor = [UIColor whiteColor];
    [_contentTV setFont:[UIFont systemFontOfSize:17.0]];
    _contentTV.layer.cornerRadius = 15.0;
    _contentTV.layer.masksToBounds = YES;
    _contentTV.layer.borderWidth = 3.0;
    _contentTV.layer.borderColor = colorref;
    _contentTV.editable = NO;
    _contentTV.textColor = mainColor;
    _contentTV.text = self.model.msgcontent;
    [self.view addSubview: _contentTV];
    
    
    }
-(void)addCollectionView
{
    UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc]init];
    
    //创建一个UICollectionView
    _myCollectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0,60*ProportionHeight, KWidth, 1.0/3*KHeight) collectionViewLayout:flowL];
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
    [cell.imgOfCell setImageWithURL:[NSURL URLWithString:self.imageArray[indexPath.row]]];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(KWidth/4, 100*ProportionHeight);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //return UIEdgeInsetsMake(5*ProportionWidth, 5*ProportionWidth, 5*ProportionWidth, 5*ProportionWidth);
    return UIEdgeInsetsMake(5, 25, 5,25);
    
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
