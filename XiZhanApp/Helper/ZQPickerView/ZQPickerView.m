//
//  ZQPickerView.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/7/22.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ZQPickerView.h"

@interface ZQPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>{

    hidePickerViewBlock _block;
    UIView *_accessInputView;
    
    NSInteger _index;
}

@end

@implementation ZQPickerView

-(instancetype)initWithDataArray:(NSArray *)dataArray {
    
    if (self = [super init]) {
        self.dataArray = dataArray;
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    self.maskView.alpha = 0;
    self.maskView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskView)];
    [self.maskView addGestureRecognizer:tap];
    CGFloat accessHeight = 50;
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, KHeight + accessHeight, KWidth, KHeight * 3 / 8.0 - accessHeight)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    _accessInputView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.pickerView.frame) - accessHeight, KWidth, accessHeight)];
    //    _accessInputView.hidden = YES;
    _accessInputView.backgroundColor = [UIColor whiteColor];
    
    UIButton *cancleBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    cancleBtn.frame = CGRectMake(20, 15, 30, 30);
    [cancleBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:(UIControlEventTouchUpInside)];
    UIButton *ensureBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    ensureBtn.frame = CGRectMake(KWidth - 20 - 30, 15, 30, 30);
    [ensureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [ensureBtn addTarget:self action:@selector(ensureAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_accessInputView addSubview:cancleBtn];
    [_accessInputView addSubview:ensureBtn];
    
    [self addSubview:self.maskView];
    [self addSubview:self.pickerView];
    [self addSubview:_accessInputView];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

- (void)cancleAction:(UIButton *)sender {
    [self hidePickerViewWithEnsure:NO];
}

- (void)ensureAction:(UIButton *)sender {
    [self hidePickerViewWithEnsure:YES];
}

- (void)showPickViewAnimated:(hidePickerViewBlock )block {
    
    _block = block;
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.5;
        _accessInputView.transform = CGAffineTransformMakeTranslation(0, - KHeight * 3 / 8.0);
        self.pickerView.transform = CGAffineTransformMakeTranslation(0, - KHeight * 3 / 8.0);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hidePickerViewWithEnsure:(BOOL )flag {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        _accessInputView.transform = CGAffineTransformIdentity;
        self.pickerView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        if (flag) {
            _block(_index);
        }
        [self removeFromSuperview];
    }];
}

- (void)tapMaskView {
    [self hidePickerViewWithEnsure:YES];
}

#pragma mark -- UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.dataArray[row];
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _index = row;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
