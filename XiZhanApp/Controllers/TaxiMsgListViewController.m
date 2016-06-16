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
#import "TaxiMsgCellEdit.h"

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
@property(nonatomic,retain)TaxiMsgCellEdit *editView;
@property(nonatomic,retain)UITextField *taxiTF;
@property(nonatomic,retain)UITextField *peopleTF;
@property(nonatomic,strong)TaxiMsgModel *modelChange;
@end

@implementation TaxiMsgListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    // Do any additional setup after loading the view.
}
#pragma mark  initheaderUI
-(void)initHeaderView
{
    _header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KWidth, 200)];
   // _header.backgroundColor = [UIColor orangeColor];
    
    CGFloat leftSide = 20.0;
    
    UILabel *buttonHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, KWidth, 40)];
    buttonHeaderLabel.textAlignment = NSTextAlignmentCenter;
    buttonHeaderLabel.text = @"出租车待客处查询";
    buttonHeaderLabel.textColor = mainColor;
    buttonHeaderLabel.layer.cornerRadius = 15.0;
    buttonHeaderLabel.layer.masksToBounds = YES;
    buttonHeaderLabel.layer.borderWidth = 2.0;
    buttonHeaderLabel.layer.borderColor = colorref;
    
   // [_header addSubview:buttonHeaderLabel];
    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, KWidth, 40)];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.text = @"出租车待客数量消息";
    headerLabel.textColor = mainColor;
    [_header addSubview:headerLabel];
    
    UILabel *subHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headerLabel.frame), KWidth, 40)];
    subHeaderLabel.textAlignment = NSTextAlignmentCenter;
    subHeaderLabel.text = @"(待客出租车与候车旅客统计数量)";
    subHeaderLabel.textColor = mainColor;
    [_header addSubview:subHeaderLabel];
    
    UILabel *carAllCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftSide, CGRectGetMaxY(subHeaderLabel.frame), 200*ProportionWidth, 40)];
    carAllCountLabel.text = @"待客出租车总数";
    carAllCountLabel.textColor = mainColor;
    [_header addSubview:carAllCountLabel];
    
    _carCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(carAllCountLabel.frame), CGRectGetMaxY(subHeaderLabel.frame)+5, 50*ProportionWidth, 30)];
    _carCountLabel.text = @"xxx";
     _carCountLabel.textAlignment = NSTextAlignmentCenter;
    _carCountLabel.textColor = mainColor;
    _carCountLabel.layer.cornerRadius = 15.0;
    _carCountLabel.layer.masksToBounds = YES;
    _carCountLabel.layer.borderWidth = 2.0;
    _carCountLabel.layer.borderColor = colorref;
    [_header addSubview:_carCountLabel];
    
    UILabel *carDanWeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_carCountLabel.frame), CGRectGetMaxY(subHeaderLabel.frame), 60*ProportionWidth, 40)];
    carDanWeiLabel.text = @"辆";
    carDanWeiLabel.textColor = mainColor;
    [_header addSubview:carDanWeiLabel];
    
    UILabel *peopleAllCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftSide, CGRectGetMaxY(carAllCountLabel.frame), 200*ProportionWidth, 40)];
    peopleAllCountLabel.text = @"候车旅客总数";
    peopleAllCountLabel.textColor = mainColor;
    [_header addSubview:peopleAllCountLabel];
    
    _peoplCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(carAllCountLabel.frame), CGRectGetMaxY(carAllCountLabel.frame)+5, 50*ProportionWidth, 30)];
    _peoplCountLabel.text = @"xxx";
    _peoplCountLabel.textColor = mainColor;
    _peoplCountLabel.textAlignment = NSTextAlignmentCenter;
    _peoplCountLabel.layer.cornerRadius = 15.0;
    _peoplCountLabel.layer.masksToBounds = YES;
    _peoplCountLabel.layer.borderWidth = 2.0;
    _peoplCountLabel.layer.borderColor = colorref;
    [_header addSubview:_peoplCountLabel];
    
    UILabel *peoplDanWeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_carCountLabel.frame), CGRectGetMaxY(carAllCountLabel.frame), 60*ProportionWidth, 40)];
    peoplDanWeiLabel.text = @"人";
    peoplDanWeiLabel.textColor = mainColor;
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    // 注册cell
    [self.tableView registerClass:[TaxiMsgTableCell class] forCellReuseIdentifier:cellMsgTable];
    //[self.tableView registerNib:[UINib nibWithNibName:@"TaxiMsgTableCell" bundle:nil] forCellReuseIdentifier:cellMsgTable];
    self.tableView.tableHeaderView = _header;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
    }];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)getData {
    [self updateHeaderDataMethod];
//    NSString *pageIndex = [NSString stringWithFormat:@"%ld",_page];
    [MHNetworkManager getRequstWithURL:kGetTaxiInfoNewDataAPI params:nil successBlock:^(id returnData) {
        
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
    return 100*ProportionHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaxiMsgTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellMsgTable forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_unSelect"]];
    TaxiMsgModel *model = _dataArray[indexPath.row];
    [cell writeDataWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaxiMsgModel *model = _dataArray[indexPath.row];
    _modelChange = model;

    TaxiMsgCellEdit *alertView = [[TaxiMsgCellEdit alloc] initWithFrame:CGRectMake(50, KHeight/2 - 150, KWidth-100, 160)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, alertView.frame.size.width, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = mainColor;
    titleLabel.text = @"编辑";
    [alertView addSubview:titleLabel];
    
    UILabel *taxiLabel = [[UILabel alloc]init];
    taxiLabel.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 4, 80, 30);
    taxiLabel.textColor = mainColor;
    taxiLabel.text = @"出租车";
    taxiLabel.textAlignment = NSTextAlignmentRight;
    [alertView addSubview:taxiLabel];
    
    UITextField *taxiTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(taxiLabel.frame), CGRectGetMaxY(titleLabel.frame) + 4, alertView.frame.size.width-100, 30)];
    taxiTF.borderStyle = UITextBorderStyleRoundedRect;
    taxiTF.layer.borderWidth = 1;
    taxiTF.layer.borderColor = colorref;
    taxiTF.layer.cornerRadius = 5;
    taxiTF.keyboardType = UIKeyboardTypeNumberPad;
    _taxiTF = taxiTF;
    [alertView addSubview:_taxiTF];
    
    UILabel *peopleLabel = [[UILabel alloc]init];
    peopleLabel.frame = CGRectMake(0, CGRectGetMaxY(taxiLabel.frame) + 4, 80, 30);
    peopleLabel.textColor = mainColor;
    peopleLabel.text = @"待客人数";
    peopleLabel.textAlignment = NSTextAlignmentRight;
    [alertView addSubview:peopleLabel];
    
    UITextField *peopleTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(taxiLabel.frame), CGRectGetMaxY(taxiLabel.frame) + 4, alertView.frame.size.width-100, 30)];
    peopleTF.borderStyle = UITextBorderStyleRoundedRect;
    peopleTF.layer.borderWidth = 1;
    peopleTF.layer.borderColor = colorref;
    peopleTF.layer.cornerRadius = 5;
    peopleTF.keyboardType = UIKeyboardTypeNumberPad;
    _peopleTF = peopleTF;
    [alertView addSubview:_peopleTF];

    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(10, CGRectGetMaxY(peopleTF.frame) + 4, 60, 40);
    [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:mainColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    //cancelBtn.backgroundColor = [UIColor orangeColor];
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.borderColor = colorref;
    cancelBtn.layer.cornerRadius = 5;
    [alertView addSubview:cancelBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    confirmBtn.frame = CGRectMake(CGRectGetMaxX(alertView.frame)-120, CGRectGetMaxY(peopleTF.frame) + 4, 60, 40);
    [confirmBtn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:mainColor forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    //confirmBtn.backgroundColor = [UIColor orangeColor];
    confirmBtn.layer.borderWidth = 1;
    confirmBtn.layer.borderColor = colorref;
    confirmBtn.layer.cornerRadius = 5;
    [alertView addSubview:confirmBtn];
    if ([[User shareUser].type isEqualToString:@"2"]) {
        [alertView show];
    }
}

- (void)cancelClick:(UIButton *)btn
{
    [btn.superview performSelector:@selector(close)];
}

-  (void)confirmClick:(UIButton *)btn
{
    NSLog(@"456");
    if (![self checkInPut]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    
//   [MHNetworkManager postWithURL:KPostTaxiInformation params:@{@"name":_modelChange.taxiRankName,@"areaID":_modelChange.areaID,@"laneCount":_modelChange.laneCount,@"maxTaxiCount":_taxiTF.text,@"maxPeopleCount":_peopleTF.text,@"description":@"0",@"imageurl":@"0"} successBlock:^(id returnData) {
//       
//    } failureBlock:^(NSError *error) {
//
//    } showHUD:YES];
    NSLog(@"[Utility getUserInfoFromLocal]name:%@",[Utility getUserInfoFromLocal][@"tel"]);
    NSNumber *taxiNum = [NSNumber numberWithInt:[_taxiTF.text intValue]] ;
    NSNumber *peopleNum = [NSNumber numberWithInt:[_peopleTF.text intValue]];
    [MHNetworkManager postWithURL:KPostNewPublishTaxiInfo params:@{@"taxiRankID":_modelChange.TaxiRankID,@"taxiCount":taxiNum,@"peopleCount":peopleNum,@"createUser":[Utility getUserInfoFromLocal][@"tel"]} successBlock:^(id returnData) {
        
        NSLog(@"%@",returnData);
        [weakSelf getData];
        [btn.superview performSelector:@selector(close)];
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showError:@"编辑失败！" toView:nil];
    } showHUD:YES];

}

-(BOOL)checkInPut
{
    if (_peopleTF.text.length <= 0) {
        [MBProgressHUD showError:@"待客人数数量不得为空" toView:nil];
        return NO;
    }
    if (_taxiTF.text.length <= 0) {
        [MBProgressHUD showError:@"出租车数量不得为空" toView:nil];
        return NO;
    }
    return YES;
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
