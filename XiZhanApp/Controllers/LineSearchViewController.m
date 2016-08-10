//
//  LineSearchViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/7/15.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "LineSearchViewController.h"
#import "MenuModel.h"
#import <MJRefresh.h>
#import "MenuType2TabCell.h"
#import "LineWebViewController.h"
#import "ParkViewController.h"
#import "MyInformationsViewController.h"
#import "InfoClassifyViewController.h"

@interface LineSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
    BOOL _shouldRefresh; // 是否需要刷新数据
    NSMutableArray *_dataArray;
}
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation LineSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.menuModel.menuTitle;
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)setupViews {
    
    _dataArray = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = CGRectMake(0, 0, KWidth, KHeight);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuType2TabCell" bundle:nil] forCellReuseIdentifier:cellId];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

-(void)tapNoDataView {
    [self.tableView.mj_header beginRefreshing];
}

- (void)addLocalData {
    
    MenuModel *menuModel1 = [[MenuModel alloc] init];
    menuModel1.menuTitle = @"公交线路查询";
    [_dataArray addObject:menuModel1];
    
    MenuModel *menuModel2 = [[MenuModel alloc] init];
    menuModel2.menuTitle = @"地铁线路查询";
    [_dataArray addObject:menuModel2];
    
    MenuModel *menuModel3 = [[MenuModel alloc] init];
    menuModel3.menuTitle = @"停车场信息";
    [_dataArray addObject:menuModel3];
    
    MenuModel *menuModel4 = [[MenuModel alloc] init];
    menuModel4.menuTitle = @"地图导航";
    [_dataArray addObject:menuModel4];
}

- (void)getData {
    
    // 判断是否有分类列表
    //    NSDictionary *dict = !self.menuModel ? nil : @{@"parentId":self.menuModel.menuId};
    [self removeNodataView];
    
    __weak typeof(self) weakSelf = self;
    [RequestManager getRequestWithURL:kMuenListAPI paramer:@{@"parentid":self.menuModel.menuId} success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            [_dataArray removeAllObjects];
            [weakSelf addLocalData];
            NSArray *resultArray = [MenuModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (resultArray.count <= 0) {
                
            }else {
                [_dataArray addObjectsFromArray:resultArray];
            }
        }else {
            [MBProgressHUD showError:@"获取列表失败" toView:self.view];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        if (_dataArray.count <= 0) {
            [self addNodataViewInView:self.tableView];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        //        [MBProgressHUD showError:@"网络不给力" toView:self.view];
        [self.tableView.mj_header endRefreshing];
        if (_dataArray.count <= 0) {
            [self addNodataViewInView:self.tableView];
        }
    } showHUD:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuType2TabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    MenuModel *model = _dataArray[indexPath.row];
    [cell writeDataWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuModel *model = _dataArray[indexPath.row];
    switch (indexPath.row) {
        case 0:{
            LineWebViewController *lineWebVC = [[LineWebViewController alloc] init];
            lineWebVC.title = model.menuTitle;
            lineWebVC.webUrl = @"http://www.bjbus.com/RTBus/app/c.html?op=x&openid=oBwutjrbTpDQOs3PagOpRPFPNpRk";
            [self.navigationController pushViewController:lineWebVC animated:YES];
        }
            break;
        case 1:{
    
            LineWebViewController *lineWebVC = [[LineWebViewController alloc] init];
            lineWebVC.title = model.menuTitle;
            lineWebVC.webUrl = @"http://www.bjsubway.com/mobile/station/";
            [self.navigationController pushViewController:lineWebVC animated:YES];
        }
            break;
        case 2:{
            ParkViewController *taxiMsgVC = [Utility getControllerWithStoryBoardId:parkVCId];
            taxiMsgVC.menuModel = model;
            [self.navigationController pushViewController:taxiMsgVC animated:YES];
        }
            break;
        case 3:{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://maps.apple.com/maps?q=&Z=13"]];
        }
            break;
        default:{
            
            if ([model.alias isEqualToString:@"bus_route"]) {
                // 后台数据模块
                InfoClassifyViewController *myInfoVC = [[InfoClassifyViewController alloc] init];
                myInfoVC.menuModel = model;
                [self.navigationController pushViewController:myInfoVC animated:YES];
            }else {
                MyInformationsViewController *myInfoVC = [Utility getControllerWithStoryBoardId:@"myInfoVC"];;
                myInfoVC.menuModel = model;
                [self.navigationController pushViewController:myInfoVC animated:YES];
            }
            
        }
            
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
