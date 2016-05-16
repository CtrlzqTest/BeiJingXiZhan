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

static NSString *cellIndentifer = @"msgType1";
@interface MyInformationsViewController ()<UITableViewDelegate,UITableViewDataSource,PublishViewControllerDelegate>
{
    NSInteger _page;
    BOOL _shouldRefresh; // 是否需要刷新数据
}
@property(nonatomic,strong)UITableView *newsList;
@property(nonatomic,strong)NSMutableArray *newsArray;

@end

@implementation MyInformationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    [self initView];
    self.title = self.msgType;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOtherInfo) name:ZQAddOtherInfoNotication object:nil];
    
    if (self.isSkip == 1) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"skip" object:nil];
        //        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
       // [self requestData];
        _shouldRefresh = YES;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
    }
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
        [self.newsList.mj_header beginRefreshing];
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
    
    // 本地数据库获取
    if (self.msgType != nil) {
        self.newsArray = [NSMutableArray arrayWithArray:[MessageModel getDataWithCondition:[NSString stringWithFormat:@"msgtype = '%@'",self.msgType] page:_page orderBy:@"msgdate"]];
//        if (self.newsArray.count < 15) {
//            [self requestDataWithRefreshType:RefreshTypePull];
//        }
    }else {
        self.newsArray = self.newsArray = [NSMutableArray arrayWithArray:[MessageModel getDataWithCondition:nil page:_page orderBy:@"msgdate"]];
//        if (self.newsArray.count < 15) {
//            [self requestDataWithRefreshType:RefreshTypePull];
//        }
    }
    
    self.newsList = [[UITableView alloc]init];
    self.newsList.frame = CGRectMake(0, 0, KWidth, KHeight);
    self.newsList.dataSource = self;
    self.newsList.delegate = self;
    [self.view addSubview:self.newsList];
    // 注册cell
    [self.newsList registerNib:[UINib nibWithNibName:@"MsgType1TabCell" bundle:nil] forCellReuseIdentifier:cellIndentifer];
    
    self.newsList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    [self.newsList.mj_header beginRefreshing];
    
    self.newsList.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestDataWithRefreshType:RefreshTypePull];
    }];
    
}

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
                    [self.newsList.mj_footer endRefreshing];
                    NSArray *coutArr = [[MessageModel shareTestModel] getDataWithCondition:[NSString stringWithFormat:@"msgid = '%@'",model.msgid]];
                    if (coutArr.count <= 0) {
                        // 先添加到数组，同时保存到数据库
                        [self.newsArray insertObject:model atIndex:0];
                        [model save];
                        [self.newsList reloadData];
                    }
                }
            }else {
                
            }
            
        }else {
            // 请求失败
        }
        [self.newsList.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        if ([self.newsList.mj_footer isRefreshing]) {
            [self.newsList.mj_footer endRefreshing];
        }
        [MBProgressHUD showError:@"网络不给力" toView:self.view];
        [self.newsList.mj_header endRefreshing];
    } showHUD:NO];
    
    
//    [self.newsList reloadData];

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
            [_newsArray addObjectsFromArray:tempArray];
            [self.newsList.mj_footer endRefreshing];
            [self.newsList reloadData];
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
                        [self.newsArray insertObject:model atIndex:0];
                    }else {
                        [self.newsArray addObject:model];
                        [self.newsList.mj_footer endRefreshing];
                    }
                    NSArray *coutArr = [[MessageModel shareTestModel] getDataWithCondition:[NSString stringWithFormat:@"msgid = '%@'",model.msgid]];
                    if (coutArr.count <= 0) {
                        [model save];
                    }
                }
            }else {
                if (refreshType == RefreshTypeDrag) {
                    _page = 1;
                    if (self.msgType != nil) {
                        self.newsArray = [NSMutableArray arrayWithArray:[MessageModel getDataWithCondition:[NSString stringWithFormat:@"msgtype = '%@'",self.msgType] page:_page orderBy:@"msgdate"]];
                    }else {
                        self.newsArray = self.newsArray = [NSMutableArray arrayWithArray:[MessageModel getDataWithCondition:nil page:_page orderBy:@"msgdate"]];
                    }
                }else {
                    // 上拉没有跟多数据
                    [self.newsList.mj_footer endRefreshingWithNoMoreData];
                }
            }
            [self.newsList reloadData];
        }else {
           // 请求失败
        }
        
        
        
    } failureBlock:^(NSError *error) {
        if ([self.newsList.mj_footer isRefreshing]) {
            [self.newsList.mj_footer endRefreshing];
        }
        [MBProgressHUD showError:@"网络不给力" toView:self.view];
    } showHUD:NO];
    
    [self.newsList.mj_header endRefreshing];
    [self.newsList reloadData];
}

- (IBAction)editAction:(id)sender {
    
    if (![User shareUser].isLogin) {
        LoginViewController *loginVC = [Utility getControllerWithStoryBoardId:ZQLoginViewCotrollerId];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else {
       // PublishInfoViewController *publishVC = [Utility getControllerWithStoryBoardId:ZQPublishInfoViewControllerId];
        PublishViewController *publishVC = [[PublishViewController alloc]init];
        publishVC.parentIdString = self.parentIdString;
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
    return self.newsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgType1TabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer forIndexPath:indexPath];
    MessageModel *model = self.newsArray[indexPath.row];
    [cell writeDataWithModel:model];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *model = self.newsArray[indexPath.row];
    if (!model.isread) {
        model.isread = YES;
        [self.newsList reloadData];
        [model updateWithCondition:[NSString stringWithFormat:@"msgid = '%@'",model.msgid]];
    }

    InformationDetailViewController *vc = [[InformationDetailViewController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    }
@end
