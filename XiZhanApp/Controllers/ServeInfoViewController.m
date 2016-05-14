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

static NSString *serveCellId = @"serveTabCellId";
@interface ServeInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ServeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}


- (IBAction)editAction:(id)sender {
    
    if (![User shareUser].isLogin) {
        LoginViewController *loginVC = [Utility getControllerWithStoryBoardId:ZQLoginViewCotrollerId];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else {
      //  PublishInfoViewController *publishVC = [Utility getControllerWithStoryBoardId:ZQPublishInfoViewControllerId];
       PublishViewController *publishVC = [[PublishViewController alloc]init];
        [self.navigationController pushViewController:publishVC animated:YES];
    }
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

// 数据请求
- (void)requestData {
    
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
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ServeTabCell *cell = [tableView dequeueReusableCellWithIdentifier:serveCellId forIndexPath:indexPath];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SerVeDetailViewController *vc = [Utility getControllerWithStoryBoardId:ZQServeDetailViewControllerId];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
