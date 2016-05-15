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
@interface ServeInfoViewController ()<UITableViewDelegate,UITableViewDataSource,PublishViewControllerDelegate>
{
    NSInteger _page;
    NSMutableArray *_dataArray;
    BOOL _shouldRefresh; // 是否需要刷新数据
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
        [self requestData];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
    }
    
  
}

#pragma mark -- PublishViewControllerDelegate
// 成功发布消息之后，设置需要刷新
-(void)noticeTableViewRefresh:(MessageModel *)model {
    _shouldRefresh = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_shouldRefresh) {
        [self.tableView.mj_header beginRefreshing];
    }
}

// 视图消失的时候，设置不需要刷新
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _shouldRefresh = NO;
}

- (void)setupViews {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ServeTabCell" bundle:nil] forCellReuseIdentifier:serveCellId];
    
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    [self.tableView.mj_header beginRefreshing];
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestDataWithRefreshType:RefreshTypePull];
    }];
}

//- (void)pubulishServe {
//    [self requestData];
//}

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
        publishVC.menuModel = self.menuModel;
        publishVC.delegate = self;
        [self.navigationController pushViewController:publishVC animated:YES];
    }
}

- (void)getDataFromLocal {
    
    // 本地数据库获取
    if (self.msgType != nil) {
        _dataArray = [NSMutableArray arrayWithArray:[MessageModel getDataWithCondition:[NSString stringWithFormat:@"msgtype = '%@'",self.msgType] page:_page orderBy:@"msgdate"]];
        if (_dataArray.count <= 0) {
            [self requestData];
        }else if (_dataArray.count < 15) {
            [self requestDataWithRefreshType:RefreshTypePull];
        }
    }
}

// 获取新数据
- (void)requestData {
    
    NSString *flag = nil;
    NSString *msgDate = nil;
    NSArray *resultArray = [[MessageModel shareTestModel] getDataWithCondition:@"msgdate = (select max(msgdate) from MessageModel)"];
    if (resultArray.count == 0) {
        flag = @"2"; msgDate = @"";
    }else{
        MessageModel *model = [[MessageModel mj_objectArrayWithKeyValuesArray:resultArray] firstObject];
        flag = @"1"; msgDate = [NSString stringWithFormat:@"%ld",model.msgdate];
    }
    [MHNetworkManager getRequstWithURL:kAllMessageAPI params:@{@"flag":flag,@"msgDate":msgDate} successBlock:^(id returnData) {
        
        if ([returnData[@"message"] isEqualToString:@"success"]) {
            NSArray *resultArray1 = [MessageModel mj_objectArrayWithKeyValuesArray:returnData[@"list"]];
            if (resultArray1.count > 0) {
                
                for (MessageModel *model in resultArray1) {
                    
                    [self.tableView.mj_footer endRefreshing];
                    NSArray *coutArr = [[MessageModel shareTestModel] getDataWithCondition:[NSString stringWithFormat:@"msgid = '%@'",model.msgid]];
                    if (coutArr.count <= 0) {
                        // 先添加到数组，同时保存到数据库
                        [_dataArray insertObject:model atIndex:0];
                        [model save];
                        [self.tableView reloadData];
                    }
                    
                }
            }else {
                
            }
            
        }else {
            // 请求失败
        }
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        [MBProgressHUD showError:@"网络不给力" toView:self.view];
        [self.tableView.mj_header endRefreshing];
    } showHUD:NO];
    
    
//    [self.tableView reloadData];
    
}

// 上拉加载
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
                    NSArray *coutArr = [[MessageModel shareTestModel] getDataWithCondition:[NSString stringWithFormat:@"msgid = '%@'",model.msgid]];
                    if (coutArr.count > 0) {
                        return ;
                    }
                    // 先添加到数组，同时保存到数据库
                    if (refreshType == RefreshTypeDrag) {
                        [_dataArray insertObject:model atIndex:0];
                    }else {
                        [_dataArray addObject:model];
                        [self.tableView.mj_footer endRefreshing];
                    }
                    if (coutArr.count <= 0) {
                        [model save];
                    }
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
    MessageModel *model = _dataArray[indexPath.row];
    if (!model.isread) {
        model.isread = YES;
        [self.tableView reloadData];
        [model updateWithCondition:[NSString stringWithFormat:@"msgid = '%@'",model.msgid]];
    }

   // SerVeDetailViewController *vc = [Utility getControllerWithStoryBoardId:ZQServeDetailViewControllerId];
    SerVeDetailViewController *vc = [[SerVeDetailViewController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
   }

@end
