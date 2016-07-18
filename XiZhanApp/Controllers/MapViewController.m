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

@interface MapViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSMutableArray *_dataArray;
}

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) ZQMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTef;

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
    MapModel *model1 = [[MapModel alloc] init];
    model1.coordinate = CGPointMake(180, 180);
    model1.title = @"凉亭（A区）";
    MapModel *model2 = [[MapModel alloc] init];
    model2.coordinate = CGPointMake(150, 250);
    model2.title = @"凉亭（B区）";
    MapModel *model3 = [[MapModel alloc] init];
    model3.coordinate = CGPointMake(200, 150);
    model3.title = @"凉亭（C区）";
    [_dataArray addObject:model1];
    [_dataArray addObject:model2];
    [_dataArray addObject:model3];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIImage *image = [UIImage imageNamed:@"test.jpg"];
    
    self.mapView = [[ZQMapView alloc] initWithFrame:self.backView.bounds image:image];
    for (MapModel *mapModel in _dataArray) {
        [self.mapView addPointAnnotation:mapModel];
    }
    [self.mapView setMapScale:2];
    [self.backView addSubview:self.mapView];
    
    self.searchView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    [self.backView bringSubviewToFront:self.searchView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (IBAction)backAction:(id)sender {
    
    
}


-(void)viewWillLayoutSubviews {
    
    self.mapView.frame = self.backView.bounds;
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
    MapModel *model = _dataArray[indexPath.row];
    model.isMark = YES;
    [self.mapView resetPointAnnotation:model atIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void)textFieldDidChange:(NSNotification *)notice {
    NSLog(@"%@",self.searchTef.text);
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
