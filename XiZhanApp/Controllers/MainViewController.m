//
//  MainViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/9.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "LeftSlideViewController.h"
#import "MainCollCell.h"
#import "MyInformationsViewController.h"
#import "MessageModel.h"
#import "MenuModel.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import "InfoClassifyViewController.h"
#import "TaxiClassifyViewController.h"
#import "LineSearchViewController.h"
#import "MapViewController.h"

static NSString *collCellId = @"MainCell";
@interface MainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *_dataArray;
}
@property (nonatomic,strong)IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *redPointImgView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addNotices];
    [self setupViews];
    
    // 消息提示
    if ([User shareUser].isLogin && [Utility getMyMsgReadState]) {
        self.redPointImgView.hidden = NO;
    }else {
        self.redPointImgView.hidden = YES;
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self canSlideMenu:YES];
}

// 添加通知
- (void)addNotices {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldShowRedPoint) name:ZQReadStateDidChangeNotication object:nil];
}

- (void)shouldShowRedPoint {
    
    if ([User shareUser].isLogin && [Utility getMyMsgReadState]) {
        self.redPointImgView.hidden = NO;
    }else {
        self.redPointImgView.hidden = YES;
    }
}

- (void)initData {
    
    [self removeNodataView];
    
    [RequestManager getRequestWithURL:kMuenListAPI paramer:@{@"parentid":@""} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            
            _dataArray = [MenuModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            MenuModel *menuModel = [[MenuModel alloc] init];
            menuModel.menuTitle = @"交通引导";
            menuModel.imageName = @"taxi";
            [_dataArray addObject:menuModel];
            
            MenuModel *menuModel1 = [[MenuModel alloc] init];
            menuModel1.menuTitle = @"交通换乘";
            menuModel1.imageName = @"transfer";
            [_dataArray addObject:menuModel1];
            
            MenuModel *menuModel2 = [[MenuModel alloc] init];
            menuModel2.menuTitle = @"设施查询";
            menuModel2.imageName = @"facilities";
            [_dataArray addObject:menuModel2];
            
        }else if([responseObject[@"code"] integerValue] == 10001){
            [Utility checkIsRegisteruuid];
        }else {
            [MBProgressHUD showError:@"网络不给力" toView:self.view];
        }
        
        if (_dataArray.count <= 0) {
            [self addNodataViewInView:self.collectionView];
        }
        
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        if (_dataArray.count <= 0) {
            [self addNodataViewInView:self.collectionView];
        }
    } showHUD:YES];
//    _dataArray = [NSMutableArray arrayWithArray:@[@"志愿者消息",@"站内公告消息",@"服务台消息"]];

}

-(void)tapNoDataView {
    [super tapNoDataView];
    [self.collectionView.mj_header beginRefreshing];
}
// 显示菜单
- (IBAction)menuAction:(id)sender {
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSliderVC openLeftView];
    
}

- (void)setupViews {
    
//    // 返回按钮
//    __weak typeof(self) weakSelf = self;
//    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"user" selectImage:nil action:^(AYCButton *button) {
//        [weakSelf menuAction:nil];
//    }];

    
    self.view.backgroundColor = [UIColor whiteColor];
    // 和maincolcell统一
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(KWidth / 2.0 - 40, (KWidth / 2.0 - 40) * 1.2);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    self.collectionView.collectionViewLayout = flowLayout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MainCollCell" bundle:nil] forCellWithReuseIdentifier:collCellId];
    
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    [self.collectionView.mj_header beginRefreshing];
    
//    // 上拉加载
//    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
////        [self requestMoreData];
//    }];
}

#pragma mark --UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collCellId forIndexPath:indexPath];
    MenuModel *model = _dataArray[indexPath.row];
    cell.titleLabel.text = model.menuTitle;
//    if (indexPath.row >= _dataArray.count - 1) {
//        
//        cell.headImageView.image = [UIImage imageNamed:@"taxi"];
//        
//    }else {
//        NSString *imgUrl = [NSString stringWithFormat:@"%@%@",BaseXiZhanImgAPI,model.imgUrl];
//        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default"]];
//    }
    if (model.imgUrl.length <= 0) {
        cell.headImageView.image = [UIImage imageNamed:model.imageName];
    }else {
        NSString *imgUrl = [NSString stringWithFormat:@"%@%@",BaseXiZhanImgAPI,model.imgUrl];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuModel *model = _dataArray[indexPath.row];
    
    if (indexPath.row == _dataArray.count - 3) {
        // 交通引导
        TaxiClassifyViewController *taxiMsgVC = [[TaxiClassifyViewController alloc] init];
        taxiMsgVC.menuModel = model;
        [self.navigationController pushViewController:taxiMsgVC animated:YES];
        
    }else if(indexPath.row == _dataArray.count - 2){
        
        // 换成查询
        LineSearchViewController *lineVC = [[LineSearchViewController alloc] init];
        lineVC.menuModel = model;
        [self.navigationController pushViewController:lineVC animated:YES];
        
    }else if(indexPath.row == _dataArray.count - 1){
        
        // 设施查询
        MapViewController *mapVC = [Utility getControllerWithStoryBoardId:@"mapViewController"];
        mapVC.title = model.menuTitle;
        [self.navigationController pushViewController:mapVC animated:YES];
        
    }else{
        
        if ([model.alias isEqualToString:@"taxi_capacity"] || [model.alias isEqualToString:@"important_notice"]) {
            MyInformationsViewController *myInfoVC = [Utility getControllerWithStoryBoardId:@"myInfoVC"];;
            myInfoVC.menuModel = model;
            [self.navigationController pushViewController:myInfoVC animated:YES];
        }else {
            // 后台数据模块
            InfoClassifyViewController *myInfoVC = [[InfoClassifyViewController alloc] init];
            myInfoVC.menuModel = model;
            [self.navigationController pushViewController:myInfoVC animated:YES];
        }
    }
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
