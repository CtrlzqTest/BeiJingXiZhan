//
//  ServeInfoViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/10.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ServeInfoViewController.h"
#import "ServeTabCell.h"
#import <MJRefresh.h>
#import "SerVeDetailViewController.h"
#import "LoginViewController.h"
//#import "PublishInfoViewController.h"
#import "PublishViewController.h"
#import "MessageModel.h"

static NSString *serveCellId = @"serveTabCellId";
@interface ServeInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
    NSMutableArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ServeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    self.title = self.msgType;
    
    [self getDataFromLocal];
    [self setupViews];

    if (self.isSkip == 1) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"skip" object:nil];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
    }
}
-(void)backMethod
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editAction:(id)sender {
    
    if (![User shareUser].isLogin) {
        LoginViewController *loginVC = [Utility getControllerWithStoryBoardId:ZQLoginViewCotrollerId];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else {
      //  PublishInfoViewController *publishVC = [Utility getControllerWithStoryBoardId:ZQPublishInfoViewControllerId];
       PublishViewController *publishVC = [[PublishViewController alloc]init];
        publishVC.parentIdString = self.parentIdString;
        [self.navigationController pushViewController:publishVC animated:YES];
    }
}

- (void)getDataFromLocal {
    
    // 本地数据库获取
    if (self.msgType != nil) {
        _dataArray = [NSMutableArray arrayWithArray:[MessageModel getDataWithCondition:[NSString stringWithFormat:@"msgtype = '%@'",self.msgType] page:_page orderBy:@"msgdate"]];
    }    
}

-(void)requestDataWithRefreshType:(RefreshType )refreshType
{
    NSString *flag = nil;
    NSString *msgDate = nil;
    NSArray *resultArray = [[MessageModel shareTestModel] getDataWithCondition:@"msgDate = (select max(msgDate) from MessageModel)"];
    if (resultArray.count == 0) {
        flag = @"2"; msgDate = @"";
    }else if(refreshType == RefreshTypeDrag){
        // 数据库有数据，下拉先刷新
        MessageModel *model = [[MessageModel mj_objectArrayWithKeyValuesArray:resultArray] firstObject];
        flag = @"1"; msgDate = [NSString stringWithFormat:@"%ld",model.msgdate];
    }else if(refreshType == RefreshTypePull){
        // 上拉加载
        // 1,从数据库取数据
        _page ++;
        NSArray *tempArray = [NSMutableArray arrayWithArray:[MessageModel getDataWithCondition:[NSString stringWithFormat:@"msgtype = '%@'",self.msgType] page:_page orderBy:@"msgdate"]];
        if (tempArray.count > 0) {
            [_dataArray addObjectsFromArray:tempArray];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            return;
        }
        // 2,没有的话,请求后台数据
        NSArray *resultArray_min = [[MessageModel shareTestModel] getDataWithCondition:@"msgDate = (select min(msgDate) from MessageModel)"];
        MessageModel *model = [[MessageModel mj_objectArrayWithKeyValuesArray:resultArray_min] firstObject];
        msgDate = [NSString stringWithFormat:@"%ld",model.msgdate];
        flag = @"0";
    }
    
    [MHNetworkManager getRequstWithURL:kAllMessageAPI params:@{@"flag":flag,@"msgDate":msgDate} successBlock:^(id returnData) {
        
        if ([returnData[@"message"] isEqualToString:@"success"]) {
            NSArray *resultArray = [MessageModel mj_objectArrayWithKeyValuesArray:returnData[@"list"]];
            if (resultArray.count > 0) {
                for (MessageModel *model in resultArray) {
                    // 先添加到数组，同时保存到数据库
                    if (refreshType == RefreshTypeDrag) {
                        [_dataArray insertObject:model atIndex:0];
                    }else {
                        [_dataArray addObject:model];
                        [self.tableView.mj_footer endRefreshing];
                    }
                    [model save];
                }
            }else {
                if (refreshType == RefreshTypeDrag) {
                    _page = 1;
                    _dataArray = [NSMutableArray arrayWithArray:[MessageModel getDataWithCondition:[NSString stringWithFormat:@"msgtype = '%@'",self.msgType] page:_page orderBy:@"msgdate"]];
                }else {
                    // 上拉没有跟多数据
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            [self.tableView reloadData];
        }else {
            // 请求失败
        }
        
    } failureBlock:^(NSError *error) {
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        [MBProgressHUD showError:@"网络不给力" toView:self.view];
    } showHUD:NO];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

- (void)setupViews {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ServeTabCell" bundle:nil] forCellReuseIdentifier:serveCellId];
    
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestDataWithRefreshType:RefreshTypeDrag];
    }];
    
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestDataWithRefreshType:RefreshTypePull];
    }];
}

- (void)requestMoreData {
    
    [self.tableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageModel *model = _dataArray[indexPath.row];
    ServeTabCell *cell = [tableView dequeueReusableCellWithIdentifier:serveCellId forIndexPath:indexPath];
    [cell writeDataWithModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SerVeDetailViewController *vc = [Utility getControllerWithStoryBoardId:ZQServeDetailViewControllerId];
    [self.navigationController pushViewController:vc animated:YES];
    MessageModel *model = _dataArray[indexPath.row];
    if (!model.isread) {
        model.isread = YES;
        [self.tableView reloadData];
        [model updateWithCondition:[NSString stringWithFormat:@"msgid = '%@'",model.msgid]];
    }
}

@end
