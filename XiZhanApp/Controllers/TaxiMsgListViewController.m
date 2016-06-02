//
//  TaxiMsgListViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/2.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "TaxiMsgListViewController.h"
#import "MsgType1TabCell.h"
#import "TaxiMsgModel.h"
#import <MJRefresh.h>

@interface TaxiMsgListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
    BOOL _shouldRefresh; // 是否需要刷新数据
    NSMutableArray *_dataArray;
}
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation TaxiMsgListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)initView
{
    // 返回按钮
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self setRightImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"edit" selectImage:nil action:^(AYCButton *button) {
        
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
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
    }];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)getData {
    
//    NSString *pageIndex = [NSString stringWithFormat:@"%ld",_page];
    [MHNetworkManager getRequstWithURL:kGetTaxiRankInfoAPI params:nil successBlock:^(id returnData) {
        
        if ([returnData[@"code"] integerValue] == 0) {
            
            NSArray *resultArray1 = [TaxiMsgModel mj_objectArrayWithKeyValuesArray:returnData[@"data"]];
            if (resultArray1.count > 0) {
                _page ++;
                for (TaxiMsgModel *model in resultArray1) {
                    
                    // 判断数据库是否已存在该条消息
//                    NSArray *coutArr = [TaxiMsgModel getDataWithCondition:;
                    NSArray *coutArr = [TaxiMsgModel getDataWithCondition:[NSString stringWithFormat:@"msgid = '%@'",model.msgid] page:0 orderBy:nil];
                    if (coutArr.count <= 0) {
                        // 先添加到数组，同时保存到数据库
                        model.msgdate = [Utility timeIntervalWithDateStr:model.msgdatestr];
                        // [_dataArray insertObject:model atIndex:0];
                        [model save];
                    }
                }
            }
            _dataArray = [NSMutableArray arrayWithArray:[TaxiMsgModel getDataWithCondition:nil page:1 orderBy:@"msgdate"]];
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

#pragma mark -- UITableViewDataSource
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
    TaxiMsgModel *model = _dataArray[indexPath.row];
    [cell writeDataWithTaxiModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
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
