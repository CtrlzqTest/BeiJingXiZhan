//
//  PinImageView.m
//  西站地图Test
//
//  Created by zhangqiang on 16/7/4.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "PinImageView.h"
#import "MapModel.h"
#import "BubView.h"

@interface PinImageView()

@property(nonatomic,strong)BubView *bubView;

@end

@implementation PinImageView

-(instancetype)initWithCoordinate:(CGPoint )coordinate {
    
    if (self = [super init]) {
        self.coordinate = coordinate;
        self.frame = CGRectMake(0, 0, 20.0, 20.0);
        self.center = coordinate;
        self.layer.cornerRadius = 10.0;
        self.backgroundColor = [UIColor blueColor];
//        self.layer.borderWidth = 2;
//        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.userInteractionEnabled = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    self.bubView = [[[NSBundle mainBundle] loadNibNamed:@"BubView" owner:self options:nil] objectAtIndex:0];
    self.bubView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.bubView.frame = CGRectMake(0, 0, 200, 60);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
}

-(void)tapAction:(UITapGestureRecognizer *)gesture {
    
    [self.bubView removeFromSuperview];
    self.bubView.center = CGPointMake(self.center.x + 90, self.center.y - 35);
    [self.superview addSubview:self.bubView];
    
}

-(void)setCoordinate:(CGPoint)coordinate {
    
    if (_coordinate.x != coordinate.x || _coordinate.y != coordinate.y) {
        _coordinate = coordinate;
        self.center = coordinate;
        [self setNeedsLayout];
    }
    
}

-(void)layoutSubviews {
//    CGPoint center = self.center;
//    self.frame = CGRectMake(0, 0, 20, 20);
//    self.center = center;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     
}


@end
