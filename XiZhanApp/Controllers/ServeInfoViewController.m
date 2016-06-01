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
    
    [self setupViews];
    [self getData];

//    if (self.isSkip == 1) {
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"skip" object:nil];
//       // [self requestData];
//         _shouldRefresh = YES;
//        [self.navigationController.navigationBar setGradientLayerStartColor:[UIColor colorWithRed:0.110 green:0.690 blue:0.859 alpha:1.000] endColor:[UIColor colorWithRed:0.067 green:0.388 blue:0.635 alpha:1.000]];
//        __weak typeof(self) weakSelf = self;
//        [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
//            [weakSelf backMethod];
//        }];
//
//    }
    
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
    
    // 返回按钮
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self setTextTitleViewWithFrame:CGRectMake(180*ProportionWidth, 0, 120*ProportionWidth, 40*ProportionWidth) title: self.msgType fontSize:17.0];
    _dataArray = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ServeTabCell" bundle:nil] forCellReuseIdentifier:serveCellId];
    
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
//    [self.tableView.mj_header beginRefreshing];
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [self requestDataWithRefreshType:RefreshTypePull];
        [self getMoreData];
    }];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
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
        publishVC.parentIdString = self.menuModel.menuId;
        publishVC.menuModel = self.menuModel;
        publishVC.delegate = self;
        [self.navigationController pushViewController:publishVC animated:YES];
    }
}

- (void)getData {
    
    [MHNetworkManager getRequstWithURL:kAllMessageAPI params:@{@"parentId":self.menuModel.menuId} successBlock:^(id returnData) {
        
        if ([returnData[@"message"] isEqualToString:@"success"]) {
            NSArray *resultArray1 = [MessageModel mj_objectArrayWithKeyValuesArray:returnData[@"list"]];
            if (resultArray1.count > 0) {
                
                for (MessageModel *model in resultArray1) {
                    
                    // 判断数据库是否已存在该条消息
                    NSArray *coutArr = [[MessageModel shareTestModel] getDataWithCondition:[NSString stringWithFormat:@"msgid = '%@'",model.msgid]];
                    if (coutArr.count <= 0) {
                        // 先添加到数组，同时保存到数据库
//                        [_dataArray insertObject:model atIndex:0];
                        [model save];
                    }
                }
            }
            _dataArray = [NSMutableArray arrayWithArray:[MessageModel getDataWithCondition:[NSString stringWithFormat:@"msgtype = '%@'",self.menuModel.menuTitle] page:1 orderBy:@"msgdate"]];
            [self.tableView reloadData];
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
        
    } showHUD:YES];

}

- (void)getMoreData {
    
    __block MessageModel *lastMsgModel = [_dataArray lastObject];
    NSString *lastMsgDate = [NSString stringWithFormat:@"%ld",lastMsgModel.msgdate];
    [MHNetworkManager getRequstWithURL:kAllMessageAPI params:@{@"flag":@"0",@"msgDate":lastMsgDate,@"parentId":self.menuModel.menuId} successBlock:^(id returnData) {
        
        if ([returnData[@"message"] isEqualToString:@"success"]) {
            NSArray *resultArray1 = [MessageModel mj_objectArrayWithKeyValuesArray:returnData[@"list"]];
            if (resultArray1.count > 0) {
                
                for (MessageModel *model in resultArray1) {
                    
                    // 判断数据库是否已存在该条消息
                    NSArray *coutArr = [[MessageModel shareTestModel] getDataWithCondition:[NSString stringWithFormat:@"msgid = '%@'",model.msgid]];
                    if (coutArr.count <= 0) {
                        // 先添加到数组，同时保存到数据库
                        //  [_dataArray insertObject:model atIndex:0];
                        [model save];
                    }
                }
            }else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            NSArray *moreArray = [MessageModel getDataWithCondition:[NSString stringWithFormat:@"msgdate < '%ld' and msgtype = '%@'",lastMsgModel.msgdate,self.menuModel.menuTitle] page:1 orderBy:@"msgdate"];
            [_dataArray addObjectsFromArray:moreArray];
            
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
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
        
    } showHUD:YES];

    
}

- (void)requestMoreData {
    
    [self.tableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
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
