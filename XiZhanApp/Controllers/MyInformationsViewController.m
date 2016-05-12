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
#import "PublishInfoViewController.h"

static NSString *cellIndentifer = @"newsCell";
@interface MyInformationsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)UITableView *newsList;
@property(nonatomic,strong)NSMutableArray *newsArray;

@end

@implementation MyInformationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView
{
    //[self setTextTitleViewWithFrame:CGRectMake(180, 0, 120, 50) title:@"我的消息" fontSize:17.0];
    self.newsArray = [NSMutableArray array];
    
    self.newsList = [[UITableView alloc]init];
    self.newsList.frame = CGRectMake(0, 0, KWidth, KHeight);
    self.newsList.dataSource = self;
    self.newsList.delegate = self;
    [self.view addSubview:self.newsList];
    self.newsList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.newsList.mj_header beginRefreshing];
    
    self.newsList.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestMoreData];
    }];
}

-(void)getData
{
    [self.newsList.mj_header endRefreshing];
    [self.newsList reloadData];
}

-(void)requestMoreData
{
    [self.newsList.mj_footer endRefreshing];
}
- (IBAction)editAction:(id)sender {
    
    if (![User shareUser].isLogin) {
        LoginViewController *loginVC = [Utility getControllerWithStoryBoardId:ZQLoginViewCotrollerId];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else {
        PublishInfoViewController *publishVC = [Utility getControllerWithStoryBoardId:ZQPublishInfoViewControllerId];
        [self.navigationController pushViewController:publishVC animated:YES];
    }
}

#pragma mark listMethod
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.newsList dequeueReusableCellWithIdentifier:cellIndentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [NSString stringWithFormat:@"标题%ld",(long)indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationDetailViewController *vc = [[InformationDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
