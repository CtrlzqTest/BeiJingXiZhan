//
//  ParkViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/14.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ParkViewController.h"
#import "ParkTabCell.h"
#import "MenuModel.h"
#import <MJRefresh.h>

@interface ParkViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UILabel *headLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ParkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupViews];
//    [self requstData];
}

- (void)setupViews {
    
    self.title = self.menuModel.menuTitle;
    
    _dataArray = [NSMutableArray array];
    
    self.headLabel.textColor = mainColor;
    self.headLabel.layer.cornerRadius = 15.0;
    self.headLabel.layer.masksToBounds = YES;
    self.headLabel.layer.borderWidth = 2.0;
    self.headLabel.layer.borderColor = colorref;

    __weak typeof(self) weakSelf = self;
    // 左侧按钮
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requstData];
    }];
    [self.tableView.mj_header beginRefreshing];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requstData {
    
    [RequestManager getRequestWithURL:kGetParkInfoNewAPI paramer:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            _dataArray = [ParkMsgModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.tableView reloadData];
            
        }else {
            [MBProgressHUD showError:@"获取列表失败" toView:self.view];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
    } showHUD:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParkTabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    ParkMsgModel *model = _dataArray[indexPath.row];
    [cell writeDataWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

-(void)dealloc {
    
    [_dataArray removeAllObjects];
    _dataArray = nil;
    
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
