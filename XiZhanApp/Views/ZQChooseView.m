//
//  ZQChooseView.m
//  JinYeFeiLinOA
//
//  Created by zhangqiang on 16/4/7.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ZQChooseView.h"
//#import "MeetingRoomModel.h"
#import "AreaOfXiZhan.h"

@interface ZQChooseView()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_titleArray;
    NSMutableArray *_selectArray;
    ZQChooseType _chooseType;
    clickBtnBlock _myBlock;
    NSInteger _index;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

static NSString *cellId = @"cellId";
@implementation ZQChooseView

-(instancetype)initWithDataSource:(NSArray *)titleArray chooseType:(ZQChooseType )chooseType {
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ZQChooseView" owner:self options:nil];
    self = [array objectAtIndex:0];
    if(self){
        _titleArray = titleArray;
        _chooseType = chooseType;
        _selectArray = [NSMutableArray array];
        for (int i = 0;i < titleArray.count;i ++) {
            [_selectArray addObject:@0];
        }
    }
    return self;
}

-(void)awakeFromNib {
    
    self.frame = [UIScreen mainScreen].bounds;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.clipsToBounds = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
}

- (void)animationShow {
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    self.contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.maskView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
        self.maskView.alpha = 0.3;
    } completion:^(BOOL finished) {
    }];
}
- (void)animationHide {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
#pragma mark --UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSNumber *selectNum = _selectArray[indexPath.row];
    if ([selectNum boolValue]) {
        cell.imageView.image = [UIImage imageNamed:@"autoLogin_sel"];
    }else {
        cell.imageView.image = [UIImage imageNamed:@"autoLogin_unsel"];
    }
     AreaOfXiZhan *model = _titleArray[indexPath.row];
    cell.textLabel.text = model.AreaName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self resetSelectArray];
    _selectArray[indexPath.row] = @1;
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [tableView reloadData];

}

// 清零
- (void)resetSelectArray {
    
    for (int i = 0; i < _selectArray.count; i ++) {
        BOOL isSelect = [_selectArray[i] boolValue];
        if (isSelect) {
            _selectArray[i] = @0;
            break;
        }
    }
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (void)showChooseViewCallBack:(clickBtnBlock )clickBtn {
    
    _myBlock = clickBtn;
    [self animationShow];
    
}

- (IBAction)cancleBtn:(UIButton *)sender {
    
    [self animationHide];
    
}

- (IBAction)enSureAction:(UIButton *)sender {
    
    BOOL flag = NO;
    for (int i = 0; i < _selectArray.count; i ++) {
        BOOL isSelect = [_selectArray[i] boolValue];
        if (isSelect) {
            [self animationHide];
            flag = YES;
            _myBlock(i);
            break;
        }
    }
    if (!flag) {
        [MBProgressHUD showMessag:@"请选择服务区域" toView:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
