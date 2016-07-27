//
//  MapViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/7/15.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "MapViewController.h"
#import "ZQMapView.h"
#import "MapModel.h"
#import <Masonry.h>


@interface MapViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ZQMapViewDelegate>{
    NSMutableArray *_dataArray;
    NSMutableArray *_groupArray;
}

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) ZQMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTef;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;
@property(strong,nonatomic) BubView *bubView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 返回按钮
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    _dataArray = [NSMutableArray array];

    [self setupViews];
    
}

- (void)setupViews {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, KWidth, 200) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    self.mapView = [[ZQMapView alloc] initWithFrame:self.view.bounds imageType:MapImageType1];
    //  必须设置
    self.mapView.imageType = MapImageType1;
    self.mapView.delegate = self;
    [self.mapView setMapScale:1.2];
    [self.backView addSubview:self.mapView];
    
    self.searchView.backgroundColor = [UIColor colorWithRed:0.771 green:0.858 blue:1.000 alpha:0.500];
    [self.backView bringSubviewToFront:self.searchView];
    [self.backView bringSubviewToFront:self.showBtn];
    self.searchView.layer.cornerRadius = 5;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    self.showBtn.hidden = YES;
    
    self.bubView = [[[NSBundle mainBundle] loadNibNamed:@"BubView" owner:self options:nil] objectAtIndex:0];
//    self.bubView.frame = CGRectMake(0, self.backView.frame.size.height, KWidth, 80);
    [self.backView addSubview:self.bubView];
    [self.bubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(80);
        make.height.offset(80);
    }];
}


- (void)requestData {
    
    __weak typeof(self) weakSelf = self;
    [RequestManager getRequestWithURL:kGetFacilitiesAPI paramer:@{@"areaid":@"",@"type":@"",@"keyword":self.searchTef.text} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            _dataArray = [MapModel setDataWithArray:responseObject[@"data"]];
            if (_dataArray.count <= 0) {
                [MBProgressHUD showMessag:@"没有匹配到数据" toView:self.view];
                return ;
            }
            [weakSelf groupPinviews:_dataArray];
            [weakSelf.tableView reloadData];
            if ([_groupArray[0] count] > 0) {
                [weakSelf.mapView resetMapView:_groupArray[MapImageType1 - 1]];
            }else {
                [weakSelf.mapView resetMapView:_groupArray[MapImageType2 - 1]];
            }
            
            [weakSelf showPositionList];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showHUD:YES];
    
}

// 楼层归类
-(void)groupPinviews:(NSArray *)dataArray {
    
    _groupArray = [NSMutableArray array];
    NSMutableArray *tmpArray1 = [NSMutableArray array];
    NSMutableArray *tmpArray2 = [NSMutableArray array];
    
    for (MapModel *model in _dataArray) {
        
        if (model.imageType == MapImageType1) {
            
            [tmpArray1 addObject:model];
            
        }else if(model.imageType == MapImageType2){
            
            [tmpArray2 addObject:model];
        }
    }
    [_groupArray addObject:tmpArray1];
    [_groupArray addObject:tmpArray2];
}

#pragma mark -- ZQMapViewDelegate
-(void)tapMapActionWithPinview:(PinImageView *)pinView {
    
    [self.bubView setDataWithModel:pinView.mapModel];
//    self.bubView.bubImage.image = [UIImage imageNamed:@"about_info"];
    [UIView transitionWithView:self.bubView duration:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.bubView.transform = CGAffineTransformMakeTranslation(0, -80);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)tapMapAction {
    
    [self hideBubView];
    [UIView transitionWithView:self.tableView duration:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.tableView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

// 影藏气泡
- (void)hideBubView {
    [UIView transitionWithView:self.bubView duration:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.bubView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)showBtnAction:(id)sender {
    
    [self showPositionList];
    
}


- (IBAction)searchAction:(id)sender {
    
    [self hideBubView];
    if (self.searchTef.text > 0) {
        [self requestData];
    }
    [self.searchTef resignFirstResponder];
    
}


-(void)viewWillLayoutSubviews {
    
    self.mapView.frame = self.view.bounds;
//    self.bubView.frame = CGRectMake(0, self.backView.frame.size.height, KWidth, 80);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    MapModel *model = _dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    self.mapView.imageType = 2;
    MapModel *model = _dataArray[indexPath.row];
    model.isMark = YES;
    NSLog(@"%ld count:%ld",indexPath.row,[_groupArray[0] count]);
    if (self.mapView.imageType == model.imageType) {
        
        [self.mapView resetPointAnnotation:model atIndex:indexPath.row];
    }else {
        // 切换地图
        self.mapView.imageType = model.imageType;
        [self.mapView resetMapView:_groupArray[model.imageType - 1]];
        [self.mapView resetPointAnnotation:model atIndex:indexPath.row];
    }
    [self hidePositionList];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)textFieldDidChange:(NSNotification *)notice {
    
    NSLog(@"%@",self.searchTef.text);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text.length > 0) {
        [self requestData];
    }
    return [textField resignFirstResponder];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self hideBubView];
    return YES;
}

// 显示列表
- (void)showPositionList {
    
    if (self.showBtn.hidden == YES) {
        self.showBtn.hidden = NO;
    }
    [UIView transitionWithView:self.tableView duration:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.tableView.transform = CGAffineTransformMakeTranslation(0, -200);
    } completion:^(BOOL finished) {
        
    }];
}

// 隐藏列表
- (void)hidePositionList {
    
    [UIView transitionWithView:self.tableView duration:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.tableView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
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
