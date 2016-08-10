//
//  CapacityListViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/7/19.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "CapacityListViewController.h"
#import "MenuType2TabCell.h"
#import "MessageModel.h"
#import "MenuModel.h"
#import <MJRefresh.h>
#import "LineWebViewController.h"
#import "MyInformationsViewController.h"

@interface CapacityListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *_dataArray;
}

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation CapacityListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.menuModel.menuTitle;
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)setupViews {
    
    _dataArray = [NSMutableArray array];
    MenuModel *menuModel1 = [[MenuModel alloc] init];
    menuModel1.menuTitle = @"余票查询";
    [_dataArray addObject:menuModel1];
    
    MenuModel *menuModel2 = [[MenuModel alloc] init];
    menuModel2.menuTitle = @"火车乘车消息";
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
    switch (indexPath.row) {
        case 0:{
            LineWebViewController *webVC = [[LineWebViewController alloc] init];
            webVC.webUrl = @"http://mobile.12306.cn/weixin/wxcore/init";
            webVC.title = self.menuModel.menuTitle;
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 1:{
            
            MyInformationsViewController *myInfoVC = [Utility getControllerWithStoryBoardId:@"myInfoVC"];;
            myInfoVC.menuModel = self.menuModel;
            [self.navigationController pushViewController:myInfoVC animated:YES];
        }
            break;
        default:{
            
        }
            break;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
