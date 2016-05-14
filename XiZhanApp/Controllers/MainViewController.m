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
#import "ServeInfoViewController.h"
#import "MessageModel.h"
#import "MenuModel.h"
#import <MJRefresh.h>

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
    [self setFlowLayout];
    [self initData];
    
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
    
    [MHNetworkManager getRequstWithURL:kMuenListAPI params:nil successBlock:^(id returnData) {
        
        if ([returnData[@"message"] isEqualToString:@"success"]) {
            _dataArray = [MenuModel mj_objectArrayWithKeyValuesArray:returnData[@"list"]];
        }else {
            [MBProgressHUD showError:@"获取列表失败" toView:self.view];
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        
    } failureBlock:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [MBProgressHUD showError:@"网络不给力" toView:self.view];
    } showHUD:YES];
    
//    _dataArray = [NSMutableArray arrayWithArray:@[@"志愿者消息",@"站内公告消息",@"服务台消息"]];

}

// 显示菜单
- (IBAction)menuAction:(id)sender {
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSliderVC openLeftView];
    
}

- (void)setFlowLayout {
    
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
    cell.titleLabel.text = model.msgType;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuModel *model = _dataArray[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            MyInformationsViewController *myInfoVC = [Utility getControllerWithStoryBoardId:@"myInfoVC"];
            myInfoVC.msgType = model.msgType;
            [self.navigationController pushViewController:myInfoVC animated:YES];
        }
            break;
        case 1:
        {
            MyInformationsViewController *myInfoVC = [Utility getControllerWithStoryBoardId:@"myInfoVC"];
            myInfoVC.msgType = model.msgType;
            [self.navigationController pushViewController:myInfoVC animated:YES];
        }
            break;
        case 2:
        {
            ServeInfoViewController *serveVC = [Utility getControllerWithStoryBoardId:ZQServeTabViewControllerId];
            serveVC.title = model.msgType;
            [self.navigationController pushViewController:serveVC animated:YES];
        }
            break;
        default:
            break;
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
