//
//  InfoClassifyViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/27.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "InfoClassifyViewController.h"
#import "UIViewController+AYCNavigationItem.h"
#import "LoginViewController.h"
#import "InformationDetailViewController.h"
#import "MJRefresh.h"
//#import "PublishInfoViewController.h"
#import "ZQChooseView.h"
#import "AreaOfXiZhan.h"
#import "MessageModel.h"
#import "MenuType2TabCell.h"
#import "PublishViewController.h"
#import "MyInformationsViewController.h"

@interface InfoClassifyViewController ()<UITableViewDelegate,UITableViewDataSource,PublishViewControllerDelegate>
{
    NSInteger _page;
    BOOL _shouldRefresh; // 是否需要刷新数据
    NSMutableArray *_dataArray;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *newsArray;
@property(nonatomic,copy)NSMutableArray *areaArray;
@property(nonatomic,assign)BOOL isFirstTouch;
@property(nonatomic,retain)UIButton *resignButton;
@end

@implementation InfoClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    [self initView];
    self.title = self.menuModel.menuTitle;
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
-(void)getAreaData
{
    [RequestManager getRequestWithURL:kGetAreaAPI paramer:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            _areaArray = [AreaOfXiZhan mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        }
        else
        {
            // [MBProgressHUD showError:@"网络错误！" toView:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showHUD:NO];
    
}
#pragma mark initMethod
-(void)initView
{
    _isFirstTouch = YES;
    _dataArray = [NSMutableArray array];
    // 返回按钮
    _areaArray = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    // 左侧按钮
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    if ([[User shareUser].type isEqualToString:@"2"]&&[self.menuModel.alias isEqualToString:@"volunteer"])//type = 2志愿者,type = 1普通用户
    {
        //[self getAreaData];
        // 右侧按钮
        __block UIButton *rightBtn = nil;
        
        _resignButton = rightBtn;
        if (![Utility getVolunteerState]) {
           // [weakSelf getAreaData];
        _resignButton = [self setRightTextBarButtonItemWithFrame:CGRectMake(0, 0, 80, 30) title:@"签到" titleColor:[UIColor whiteColor] backImage:nil selectBackImage:nil action:^(AYCButton *button) {
            if (weakSelf.isFirstTouch) {
                if (_dataArray.count == 0) {
                    [MBProgressHUD showError:@"网络不给力" toView:nil];
                }
                else
                {
                ZQChooseView *choosView = [[ZQChooseView alloc] initWithDataSource:weakSelf.areaArray chooseType:ZQChooseTypeSingle];
                [choosView showChooseViewCallBack:^(NSInteger selectIndex) {
                    AreaOfXiZhan *model = weakSelf.areaArray[selectIndex];
                    [weakSelf requestOnline:model];
                }];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认签退？" message:nil delegate:weakSelf cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                [alert show];
            }
        }];
        }
        else
        {
           // [weakSelf getAreaData];
            _resignButton = [self setRightTextBarButtonItemWithFrame:CGRectMake(0, 0, 80, 30) title:@"已签到" titleColor:[UIColor whiteColor] backImage:nil selectBackImage:nil action:^(AYCButton *button) {
                if (weakSelf.isFirstTouch) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认签退？" message:nil delegate:weakSelf cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                    [alert show];
                }
                else
                {
                    if (_dataArray.count == 0) {
                        [MBProgressHUD showError:@"网络不给力" toView:nil];
                    }
                    else
                    {
                    ZQChooseView *choosView = [[ZQChooseView alloc] initWithDataSource:weakSelf.areaArray chooseType:ZQChooseTypeSingle];
                    [choosView showChooseViewCallBack:^(NSInteger selectIndex) {
                        AreaOfXiZhan *model = weakSelf.areaArray[selectIndex];
                        [weakSelf requestOnline:model];
                    }];
                    }
                }
            }];
        }
    }
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = CGRectMake(0, 0, KWidth, KHeight);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuType2TabCell" bundle:nil] forCellReuseIdentifier:cellId];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //
        [RequestManager postRequestWithURL:kPostOffLine paramer:@{@"userid":[User shareUser].zid,@"time":[Utility getCurrentDateStr]} success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] isEqualToString:@"false"]) {
                    [MBProgressHUD showError:responseObject[@"errmsg"] toView:self.view];
                    return ;
                }
                _isFirstTouch = !_isFirstTouch;
                [_resignButton setTitle:@"已签退" forState:UIControlStateNormal];
                [Utility saveVolunteerState:NO];
            }
            else
            {
                [MBProgressHUD showError:@"网络错误，未签退!" toView:nil];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            [MBProgressHUD showError:@"网络错误，未签退!" toView:nil];
        } showHUD:YES];
        
    }
}

-(void)requestOnline:(AreaOfXiZhan *)areaOfXiZhan
{
    [RequestManager postRequestWithURL:kPostOnLine paramer:@{@"userid":[User shareUser].zid,@"areaid":areaOfXiZhan.AreaID,@"time":[Utility getCurrentDateStr]} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            if ([responseObject[@"data"] isEqualToString:@"false"]) {
                [MBProgressHUD showError:responseObject[@"errmsg"] toView:self.view];
                return ;
            }
            [Utility  saveVolunteerState:YES];
            [_resignButton setTitle:@"已签到" forState:UIControlStateNormal];
            _isFirstTouch = !_isFirstTouch;
        }else{
            [MBProgressHUD showError:@"网络错误，未签到!" toView:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [MBProgressHUD showError:@"网络错误，未签退!" toView:nil];
    } showHUD:YES];
    
}
#pragma mark 点击刷新
-(void)tapNoDataView {
    [self getData];
}

- (void)getData {
    
    // 判断是否有分类列表
//    NSDictionary *dict = !self.menuModel ? nil : @{@"parentId":self.menuModel.menuId};
    [self removeNodataView];
    [RequestManager getRequestWithURL:kMuenListAPI paramer:@{@"parentid":self.menuModel.menuId} success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            _dataArray = [MenuModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.tableView reloadData];
            if ([[User shareUser].type isEqualToString:@"2"]&&[self.menuModel.menuTitle isEqualToString:@"志愿者服务"])
            {
                [self getAreaData];
            }
        }else {
            [MBProgressHUD showError:@"获取列表失败" toView:self.view];
        }
        [self.tableView.mj_header endRefreshing];
        if (_dataArray.count <= 0) {
            [self addNodataViewInView:self.tableView];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
//        [MBProgressHUD showError:@"网络不给力" toView:self.view];
        [self.tableView.mj_header endRefreshing];
        if (_dataArray.count <= 0) {
            [self addNodataViewInView:self.tableView];
        }
    } showHUD:YES];
    
}

- (IBAction)editAction:(id)sender {
    
    if (![User shareUser].isLogin) {
        LoginViewController *loginVC = [Utility getControllerWithStoryBoardId:ZQLoginViewCotrollerId];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else {
        // PublishInfoViewController *publishVC = [Utility getControllerWithStoryBoardId:ZQPublishInfoViewControllerId];
        PublishViewController *publishVC = [[PublishViewController alloc]init];
//        publishVC.parentIdString = self.parentIdString;
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
    MenuType2TabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    MenuModel *model = _dataArray[indexPath.row];
    [cell writeDataWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuModel *model = _dataArray[indexPath.row];
    model.alias = self.menuModel.alias;
    MyInformationsViewController *myInfoVC = [Utility getControllerWithStoryBoardId:@"myInfoVC"];;
    myInfoVC.menuModel = model;
    [self.navigationController pushViewController:myInfoVC animated:YES];
    
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
