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
    NSMutableArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ServeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.msgType;
    [self getDataFromLocal];
    [self setupViews];
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
        _dataArray = [NSMutableArray arrayWithArray:[[MessageModel shareTestModel] getDataWithCondition:[NSString stringWithFormat:@"msgtype = '%@' order by msgdate desc",self.msgType]]];
    }
    
}

-(void)requestData
{
    NSArray *resultArray = [[MessageModel shareTestModel] getDataWithCondition:@"msgDate = (select max(msgDate) from MessageModel)"];
    NSString *flag = nil;
    NSString *msgDate = nil;
    if (resultArray.count == 0) {
        flag = @"2"; msgDate = @"";
    }else {
        MessageModel *model = [[MessageModel mj_objectArrayWithKeyValuesArray:resultArray] firstObject];
        flag = @"1"; msgDate = [NSString stringWithFormat:@"%ld",model.msgdate];
    }
    
    [MHNetworkManager getRequstWithURL:kAllMessageAPI params:@{@"flag":flag,@"msgDate":msgDate} successBlock:^(id returnData) {
        
        if ([returnData[@"message"] isEqualToString:@"success"]) {
            NSArray *resultArray = [MessageModel mj_objectArrayWithKeyValuesArray:returnData[@"list"]];
            if (resultArray.count > 0) {
                for (MessageModel *model in resultArray) {
                    // 先添加到数组，同时保存到数据库
                    [_dataArray insertObject:model atIndex:0];
                    [model save];
                }
            }
            [self.tableView reloadData];
        }else {
            
        }
    } failureBlock:^(NSError *error) {
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
        [self requestData];
    }];
    
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestMoreData];
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
}

@end
