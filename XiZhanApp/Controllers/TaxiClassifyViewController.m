//
//  TaxiClassifyViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/2.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "TaxiClassifyViewController.h"
#import "TaxiMsgListViewController.h"
#import "MenuModel.h"
#import "MenuType2TabCell.h"
#import <MJRefresh.h>

@interface TaxiClassifyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
    BOOL _shouldRefresh; // 是否需要刷新数据
    NSMutableArray *_dataArray;
}
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation TaxiClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.menuModel.menuTitle;
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)setupViews {
    
    _dataArray = [NSMutableArray array];
    MenuModel *menuModel2 = [[MenuModel alloc] init];
    menuModel2.menuTitle = @"获取出租车每个站点的最新数据";
    [_dataArray addObject:menuModel2];

    // 返回按钮
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

- (void)getData {
    
//    MenuModel *menuModel1 = [[MenuModel alloc] init];
//    menuModel1.menuTitle = @"获取出租车站点信息";
//    [_dataArray addObject:menuModel1];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
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
//    MenuModel *model = _dataArray[indexPath.row];
    TaxiMsgListViewController *taxiStationVC = [[TaxiMsgListViewController alloc] init];
    [self.navigationController pushViewController:taxiStationVC animated:YES];
    
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
