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

@interface LeftSortsViewController ()<UITableViewDelegate,UITableViewDataSource>
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
    
    _dataArray = [NSMutableArray arrayWithArray:@[@"登录/注册",@"关于我们",@"意见反馈",@"我的消息",@"退出登录"]];
    
    self.tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.view.backgroundColor = [UIColor blackColor];
    self.tableview.dataSource = self;
    self.tableview.delegate  = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    
}

- (void)didLoginAction {
    _dataArray[0] = @"已登录";
    [self.tableview reloadData];
}

- (void)didLogoutAction {
    _dataArray[0] = @"登录/注册";
    [self.tableview reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = [UIImage imageNamed:@"user-icon5"];
    cell.textLabel.text = _dataArray[indexPath.row];
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
            LoginViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"loginVC"];
            [tempAppDelegate.mainNavi pushViewController:vc animated:NO];
        }
            break;
        case 3:
        {
            SuggestionsViewController *vc = [[SuggestionsViewController alloc]init];
            [tempAppDelegate.mainNavi pushViewController:vc animated:NO];
        }
            break;
        case 4:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:ZQdidLogoutNotication object:nil];
            });
            
        }
            break;
        default:
            break;
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
