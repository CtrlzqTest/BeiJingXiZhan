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

static NSString *collCellId = @"MainCell";
@interface MainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *_dataArray;
}
@property (nonatomic,strong)IBOutlet UICollectionView *collectionView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setFlowLayout];
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self canSlideMenu:YES];
}

- (void)initData {
    _dataArray = [NSMutableArray arrayWithArray:@[@"志愿者消息",@"站内公告消息",@"服务台消息"]];
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
}

#pragma mark --UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collCellId forIndexPath:indexPath];
    cell.titleLabel.text = _dataArray[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
            MyInformationsViewController *myInfoVC = [Utility getControllerWithStoryBoardId:@"myInfoVC"];
            myInfoVC.title = _dataArray[indexPath.row];
            [self.navigationController pushViewController:myInfoVC animated:YES];
        }
            break;
        case 1:
        {
            MyInformationsViewController *myInfoVC = [Utility getControllerWithStoryBoardId:@"myInfoVC"];
            myInfoVC.title = _dataArray[indexPath.row];
            [self.navigationController pushViewController:myInfoVC animated:YES];
        }
            break;
        case 2:
        {
            ServeInfoViewController *serveVC = [Utility getControllerWithStoryBoardId:ZQServeTabViewControllerId];
            serveVC.title = _dataArray[indexPath.row];
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
