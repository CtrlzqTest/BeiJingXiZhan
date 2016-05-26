//
//  LeftSortsViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/9.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "AppDelegate.h"
#import "BaseNaviViewController.h"
#import "LeftSlideViewController.h"
#import "LoginViewController.h"
#import "SuggestionsViewController.h"
#import "MyInformationsViewController.h"
#import "AboutXiZhanViewController.h"
#import "LeftSortsTabCell.h"
#import "MessageModel.h"

static NSString *leftSortsCellId = @"leftSortsCellId";
@interface LeftSortsViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray *_dataArray;
}
@end

@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self addNotices];
}

- (void)addNotices {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginAction) name:ZQdidLoginNotication object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogoutAction) name:ZQdidLogoutNotication object:nil];
    
}

- (void)setupViews {
    
    NSString *loginStr = nil;
    // 免登陆
    if ([Utility isLogin]) {
        [User shareUser].isLogin = YES;
        loginStr = @"已登录";
    }else {
        loginStr = @"登录/注册";
    }
    [self requestData];
    _dataArray = [NSMutableArray arrayWithArray:@[loginStr,@"关于我们",@"意见反馈",@"我的消息",@"退出登录"]];
    
    self.tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.view.backgroundColor = [UIColor colorWithWhite:0.898 alpha:1.000];
    self.tableview.dataSource = self;
    self.tableview.delegate  = self;
//    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableview registerNib:[UINib nibWithNibName:@"LeftSortsTabCell" bundle:nil] forCellReuseIdentifier:leftSortsCellId];
    
}

// 获取我的消息列表（所有消息）
- (void)requestData {
    
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
                [Utility saveMyMsgReadState:YES];  // 显示小圆点
                // 通知首页显示小圆点
                [[NSNotificationCenter defaultCenter] postNotificationName:ZQReadStateDidChangeNotication object:nil];
                for (MessageModel *model in resultArray) {
                    NSArray *coutArr = [[MessageModel shareTestModel] getDataWithCondition:[NSString stringWithFormat:@"msgid = '%@'",model.msgid]];
                    if (coutArr.count <= 0) {
                        [model save];
                    }
                    
                }
            }else{
//                [Utility saveMyMsgReadState:NO];
            }
            [self.tableview reloadData];
        }else {
            
        }
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];

}

- (void)didLoginAction {
    _dataArray[0] = @"已登录";
    [self requestData];
    [self.tableview reloadData];
}

- (void)didLogoutAction {
    _dataArray[0] = @"登录/注册";
    [Utility saveMyMsgReadState:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:ZQReadStateDidChangeNotication object:nil];
    [self.tableview reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LeftSortsTabCell *cell = [tableView dequeueReusableCellWithIdentifier:leftSortsCellId forIndexPath:indexPath];
//    cell.imgView.image = [UIImage imageNamed:@"user-icon5"];
    cell.imgView.hidden = YES;
    cell.titleLabel.text = _dataArray[indexPath.row];
    if (indexPath.row == 3 && [Utility getMyMsgReadState] && [User shareUser].isLogin) {
        cell.rightImgView.hidden = NO;
    }else {
        cell.rightImgView.hidden = YES;
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSliderVC closeLeftView];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    switch (indexPath.row) {
        case 0:
        {
            if ([_dataArray[indexPath.row] isEqualToString:@"已登录"]) {
                return;
            }
            LoginViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:ZQLoginViewCotrollerId];
            [tempAppDelegate.mainNavi pushViewController:vc animated:NO];
        }
            break;
            case 1:
        {
            AboutXiZhanViewController *vc = [[AboutXiZhanViewController alloc]init];
            [tempAppDelegate.mainNavi pushViewController:vc animated:NO];
        }
            break;
        case 2:
        {
            if ([User shareUser].isLogin) {
                SuggestionsViewController *vc = [[SuggestionsViewController alloc]init];
                [tempAppDelegate.mainNavi pushViewController:vc animated:NO];
            }
            else
            {
                LoginViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:ZQLoginViewCotrollerId];
                [tempAppDelegate.mainNavi pushViewController:vc animated:NO];
            }
        }
            break;
        case 3:
        {
            [Utility saveMyMsgReadState:NO];
            // 是否已读状态
            [[NSNotificationCenter defaultCenter] postNotificationName:ZQReadStateDidChangeNotication object:nil];
            [self.tableview reloadData];
            if ([User shareUser].isLogin) {
                MyInformationsViewController *vc = [[MyInformationsViewController alloc]init];
                [tempAppDelegate.mainNavi pushViewController:vc animated:NO];
            }else {
                LoginViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:ZQLoginViewCotrollerId];
                [tempAppDelegate.mainNavi pushViewController:vc animated:NO];
            }
        }
            break;
        case 4:
        {
            if ([Utility isLogin]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认退出？" message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                [alert show];
            }
        }
            break;
        default:
            break;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // 退出登录
        [Utility setLoginStates:NO];
        [User shareUser].isLogin = NO;
        [Utility saveUserInfo:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:ZQdidLogoutNotication object:nil];
        });

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 180)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


@end
