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
@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,retain)UIWebView *web;
@end

@implementation InformationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark webMethod
-(void)initWebView
{
    _web = [[UIWebView alloc]initWithFrame:CGRectMake(20*ProportionWidth, 134*ProportionHeight, KWidth-40*ProportionWidth, 450*ProportionHeight)];
    _web.delegate = self;
    
    [self.view addSubview:_web];
    [_web loadHTMLString:self.webUrl baseURL:nil];
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
    self.imageArray = [self.model.imgurl componentsSeparatedByString:@","];
   self.view.backgroundColor = [UIColor whiteColor];
    [self setTextTitleViewWithFrame:CGRectMake(180*ProportionWidth, 0, 120*ProportionWidth, 40*ProportionWidth) title:@"详情" fontSize:17.0];
    
    self.webUrl = self.model.msgtitle;
    self.webUrl = [self.webUrl stringByAppendingString:@"   "];
    self.webUrl = [self.webUrl stringByAppendingString:self.model.msgcontent];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 1.0/3*KHeight, KWidth, KHeight*1.0/3);
    label.text = [NSString stringWithFormat:@"%@",self.webUrl];
    [self.view addSubview:label];
    
    if (self.imageArray.count == 0) {
        UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc]init];
        
        //创建一个UICollectionView
        _myCollectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, 0, 0) collectionViewLayout:flowL];
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
}
-(void)addCollectionView
{
    UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc]init];
    
    //创建一个UICollectionView
    _myCollectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, KWidth, 1.0/3*KHeight) collectionViewLayout:flowL];
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
