//
//  MyInformationsViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/10.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "MyInformationsViewController.h"
#import "UIViewController+AYCNavigationItem.h"
#import "LoginViewController.h"
#import "InformationDetailViewController.h"
#import "MJRefresh.h"
//#import "PublishInfoViewController.h"
#import "MessageModel.h"
#import "MsgType1TabCell.h"
#import "PublishViewController.h"


@interface MyInformationsViewController ()<UITableViewDelegate,UITableViewDataSource,PublishViewControllerDelegate>
{
    NSInteger _page;
    BOOL _shouldRefresh; // 是否需要刷新数据
    NSMutableArray *_dataArray;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *newsArray;

@end

@implementation MyInformationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    [self initView];
    self.title = self.menuModel.menuTitle;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOtherInfo) name:ZQAddOtherInfoNotication object:nil];
    
//    if (self.isSkip == 1) {
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"skip" object:nil];
//        _shouldRefresh = YES;
//        [self.navigationController.navigationBar setGradientLayerStartColor:[UIColor colorWithRed:0.110 green:0.690 blue:0.859 alpha:1.000] endColor:[UIColor colorWithRed:0.067 green:0.388 blue:0.635 alpha:1.000]];
//        __weak typeof(self) weakSelf = self;
//        [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
//            
//            [weakSelf backMethod];
//        }];
//    }
    [self getData];
}

-(void)backMethod
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
#pragma mark 添加消息后刷新列表
//-(void)addOtherInfo
//{
//    [self requestData];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark initMethod
-(void)initView
{
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
    [self.tableView registerNib:[UINib nibWithNibName:@"MsgType1TabCell" bundle:nil] forCellReuseIdentifier:cellIndentifer];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
//    [self.tableView.mj_header beginRefreshing];
    MJRefreshBackNormalFooter *autoFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getMoreData];
    }];
//    [autoFooter setTitle:@"正在加载更多数据..." forState:MJRefreshStateRefreshing];
    [autoFooter setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = autoFooter;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

// 点击加载更多
-(void)tapNoDataView {
    [self getData];
}

- (void)getData {
    
    [self removeNodataView];
//    NSDictionary *dict = !self.menuModel ? nil : @{@"parentId":self.menuModel.menuId};
    NSString *nodeId = !self.menuModel ? @"" : self.menuModel.menuId;
    NSString *pageIndex = [NSString stringWithFormat:@"%ld",_page];
    [MHNetworkManager getRequstWithURL:kMessageListAPI params:@{@"nodeid":nodeId,@"pageIndex":pageIndex,@"pageSize":@"15"} successBlock:^(id returnData) {
        
        if ([returnData[@"code"] integerValue] == 0) {

            NSArray *resultArray1 = [MessageModel mj_objectArrayWithKeyValuesArray:returnData[@"data"]];
            if (resultArray1.count > 0) {
                _page ++;
                for (MessageModel *model in resultArray1) {
                    
                    // 判断数据库是否已存在该条消息
                    NSArray *coutArr = [[MessageModel shareTestModel] getDataWithCondition:[NSString stringWithFormat:@"msgid = '%@'",model.msgid]];
                    if (coutArr.count <= 0) {
                        // 先添加到数组，同时保存到数据库
                        model.msgdate = [Utility timeIntervalWithDateStr:model.msgdatestr];
                        // [_dataArray insertObject:model atIndex:0];
                        [model save];
                    }
                }
            }
            NSString *condition = !self.menuModel ? nil : [NSString stringWithFormat:@"nodeid = '%@'",self.menuModel.menuId];
            _dataArray = [NSMutableArray arrayWithArray:[MessageModel getDataWithCondition:condition page:1 orderBy:@"msgdate"]];
            if (_dataArray.count <= 0) {
//                [MBProgressHUD showMessag:@"" toView:nil];
                [self addNodataViewInView:self.tableView];
            }
            [self.tableView reloadData];
            
        }else {
            // 请求失败
        }
        [self.tableView.mj_header endRefreshing];
        
    } failureBlock:^(NSError *error) {
        if (_dataArray.count <= 0) {
            [self addNodataViewInView:self.tableView];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        [MBProgressHUD showError:@"网络不给力" toView:self.view];
        [self.tableView.mj_header endRefreshing];
        
    } showHUD:YES];
    
}

// 加载更多
- (void)getMoreData {
    
    [self removeNodataView];
    __block MessageModel *lastMsgModel = [_dataArray lastObject];
    NSString *nodeId = !self.menuModel ? @"" : self.menuModel.menuId;
    NSString *pageIndex = [NSString stringWithFormat:@"%ld",_page];
    [MHNetworkManager getRequstWithURL:kMessageListAPI params:@{@"nodeid":nodeId,@"pageIndex":pageIndex,@"pageSize":@"15"} successBlock:^(id returnData) {
        
        if ([returnData[@"code"] integerValue] == 0) {
            NSArray *resultArray1 = [MessageModel mj_objectArrayWithKeyValuesArray:returnData[@"list"]];
            if (resultArray1.count > 0) {
                _page ++;
                for (MessageModel *model in resultArray1) {
                    
                    // 判断数据库是否已存在该条消息
                    NSArray *coutArr = [[MessageModel shareTestModel] getDataWithCondition:[NSString stringWithFormat:@"msgid = '%@'",model.msgid]];
                    if (coutArr.count <= 0) {
                        // 先添加到数组，同时保存到数据库
                        model.msgdate = [Utility timeIntervalWithDateStr:model.msgdatestr];
                        //  [_dataArray insertObject:model atIndex:0];
                        [model save];
                    }
                }
            }else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            NSString *condition = !self.menuModel ? [NSString stringWithFormat:@"msgdate < '%ld'",lastMsgModel.msgdate] : [NSString stringWithFormat:@"msgdate < '%ld' and nodeid = '%@'",lastMsgModel.msgdate,self.menuModel.menuId];
            NSArray *moreArray = [MessageModel getDataWithCondition:condition page:1 orderBy:@"msgdate"];
            [_dataArray addObjectsFromArray:moreArray];
            if (_dataArray.count <= 0) {
                [self addNodataViewInView:self.tableView];
            }
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            
        }else {
            // 请求失败
        }
        [self.tableView.mj_header endRefreshing];
        
    } failureBlock:^(NSError *error) {
        if (_dataArray.count <= 0) {
            [self addNodataViewInView:self.tableView];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        [MBProgressHUD showError:@"网络不给力" toView:self.view];
        [self.tableView.mj_header endRefreshing];
        
    } showHUD:YES];
    
}

- (void)requestMoreData {
    
    
    
}


- (IBAction)editAction:(id)sender {
    
    if (![User shareUser].isLogin) {
        LoginViewController *loginVC = [Utility getControllerWithStoryBoardId:ZQLoginViewCotrollerId];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else {
       // PublishInfoViewController *publishVC = [Utility getControllerWithStoryBoardId:ZQPublishInfoViewControllerId];
        PublishViewController *publishVC = [[PublishViewController alloc]init];
        publishVC.parentIdString = self.menuModel.menuId;
        publishVC.menuModel = self.menuModel;
        publishVC.delegate = self;
        [self.navigationController pushViewController:publishVC animated:YES];
    }
}

#pragma mark listMethod
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
    MsgType1TabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer forIndexPath:indexPath];
    MessageModel *model = _dataArray[indexPath.row];
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

    InformationDetailViewController *vc = [[InformationDetailViewController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
