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
#import "MessageModel.h"
#import "MsgType1TabCell.h"

static NSString *cellIndentifer = @"msgType1";
@interface MyInformationsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)UITableView *newsList;
@property(nonatomic,strong)NSMutableArray *newsArray;

@end

@implementation MyInformationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.title = self.msgType;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView
{
    //[self setTextTitleViewWithFrame:CGRectMake(180, 0, 120, 50) title:@"我的消息" fontSize:17.0];
//    self.newsArray = [NSMutableArray array];
    
    // 本地数据库获取
//    self.newsArray = [NSMutableArray arrayWithArray:[[MessageModel shareTestModel] getDataWithPage:1]];
    if (self.msgType != nil) {
        self.newsArray = [NSMutableArray arrayWithArray:[[MessageModel shareTestModel] getDataWithCondition:[NSString stringWithFormat:@"msgtype = '%@'",self.msgType]]];
    }else {
        self.newsArray = [NSMutableArray arrayWithArray:[[MessageModel shareTestModel] getDataWithPage:1]];
    }
    
    self.newsList = [[UITableView alloc]init];
    self.newsList.frame = CGRectMake(0, 0, KWidth, KHeight);
    self.newsList.dataSource = self;
    self.newsList.delegate = self;
    [self.view addSubview:self.newsList];
    // 注册cell
    [self.newsList registerNib:[UINib nibWithNibName:@"MsgType1TabCell" bundle:nil] forCellReuseIdentifier:cellIndentifer];
    
    self.newsList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
//    [self.newsList.mj_header beginRefreshing];
    
    self.newsList.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestMoreData];
    }];
}

-(void)getData
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
                    [self.newsArray addObject:model];
                    [model save];
                }
            }
            [self.newsList reloadData];
        }else {
            
        }
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    
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
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgType1TabCell *cell = [self.newsList dequeueReusableCellWithIdentifier:cellIndentifer];
    
    MessageModel *model = self.newsArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationDetailViewController *vc = [[InformationDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
