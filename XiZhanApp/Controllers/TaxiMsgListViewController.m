//
//  TaxiMsgListViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/2.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "TaxiMsgListViewController.h"
#import "TaxiMsgModel.h"
#import "TaxiMsgTableCell.h"

#import <MJRefresh.h>

@interface TaxiMsgListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
    BOOL _shouldRefresh; // 是否需要刷新数据
    NSMutableArray *_dataArray;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *header;
@property(nonatomic,retain)UILabel *peoplCountLabel;
@property(nonatomic,retain)UILabel *carCountLabel;
@end

@implementation TaxiMsgListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}
#pragma mark  initheaderUI
-(void)initHeaderView
{
    _header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KWidth, 200*ProportionHeight)];
    _header.backgroundColor = [UIColor orangeColor];
    
    CGFloat leftSide = 20.0;
    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KWidth, 40)];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.text = @"出租车待客数量消息";
    [_header addSubview:headerLabel];
    
    UILabel *subHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headerLabel.frame), KWidth, 40)];
    subHeaderLabel.textAlignment = NSTextAlignmentCenter;
    subHeaderLabel.text = @"待客出租车与候车旅客统计数量";
    [_header addSubview:subHeaderLabel];
    
    UILabel *carAllCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftSide, CGRectGetMaxY(subHeaderLabel.frame), 200*ProportionWidth, 40)];
    carAllCountLabel.text = @"待客出租车总数";
    [_header addSubview:carAllCountLabel];
    
    _carCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(carAllCountLabel.frame), CGRectGetMaxY(subHeaderLabel.frame), 50*ProportionWidth, 40)];
    _carCountLabel.text = @"xxx";
    [_header addSubview:_carCountLabel];
    
    UILabel *carDanWeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_carCountLabel.frame), CGRectGetMaxY(subHeaderLabel.frame), 60*ProportionWidth, 40)];
    carDanWeiLabel.text = @"辆";
    [_header addSubview:carDanWeiLabel];
    
    UILabel *peopleAllCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftSide, CGRectGetMaxY(carAllCountLabel.frame), 200*ProportionWidth, 40)];
    peopleAllCountLabel.text = @"候车旅客总数";
    [_header addSubview:peopleAllCountLabel];
    
    _peoplCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(carAllCountLabel.frame), CGRectGetMaxY(carAllCountLabel.frame), 50*ProportionWidth, 40)];
    _peoplCountLabel.text = @"xxx";
    [_header addSubview:_peoplCountLabel];
    
    UILabel *peoplDanWeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_carCountLabel.frame), CGRectGetMaxY(carAllCountLabel.frame), 60*ProportionWidth, 40)];
    peoplDanWeiLabel.text = @"人";
    [_header addSubview:peoplDanWeiLabel];
}
#pragma mark updateHeaderData

-(void)updateHeaderDataMethod
{
    _peoplCountLabel.text = [NSString stringWithFormat:@"%d",arc4random() % 100];
    _carCountLabel.text = [NSString stringWithFormat:@"%d",arc4random() % 100];
}
-(void)initView
{
    [self initHeaderView];
    // 返回按钮
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [self setRightImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"edit" selectImage:nil action:^(AYCButton *button) {
        
    }];
    [self setTextTitleViewWithFrame:CGRectMake(180*ProportionWidth, 0, 120*ProportionWidth, 50*ProportionWidth)title:@"出租车" fontSize:17.0];
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = CGRectMake(0, 0, KWidth, KHeight);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TaxiMsgTableCell" bundle:nil] forCellReuseIdentifier:cellMsgTable];
    self.tableView.tableHeaderView = _header;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
    }];
   // self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)getData {
    [self updateHeaderDataMethod];
//    NSString *pageIndex = [NSString stringWithFormat:@"%ld",_page];
    [MHNetworkManager getRequstWithURL:kGetTaxiRankInfoAPI params:nil successBlock:^(id returnData) {
        
        if ([returnData[@"code"] integerValue] == 0) {
            
            _dataArray = [TaxiMsgModel mj_objectArrayWithKeyValuesArray:returnData[@"data"]];
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
    return 130*ProportionHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaxiMsgTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellMsgTable forIndexPath:indexPath];
    TaxiMsgModel *model = _dataArray[indexPath.row];
    [cell writeDataWithModel:model];
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