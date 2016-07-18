//
//  ZQMapView.m
//  西站地图Test
//
//  Created by zhangqiang on 16/7/5.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ZQMapView.h"
#import "PinImageView.h"
#import "MapModel.h"

@interface ZQMapView(){
    CGFloat lastScale;
    CGFloat minScale, maxScale;
    CGFloat old_y; // 记录缩放到原始状态时的Y值
}

@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,assign)CGSize imageSize;

@end

@implementation ZQMapView

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image {
    
    if (self = [super initWithFrame:frame]) {
//        self.bounds = frame;
        self.mapImage = image;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    self.imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imgView.userInteractionEnabled = YES;
    lastScale=1.0;minScale = 1.0;old_y = 0;
    
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImageView:)];
    [self.imgView addGestureRecognizer:pin];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImageView:)];
    [self.imgView addGestureRecognizer:pan];
    
    self.imgView.image = self.mapImage;
    self.imageSize = self.mapImage.size;
    
    [self.imgView setAutoresizesSubviews:YES];
    [self addSubview:self.imgView];
    
    self.clipsToBounds = YES;
}

// 添加大头针
-(void)addPointAnnotation:(MapModel *)model {
    
    PinImageView *pinView = [[PinImageView alloc] initWithCoordinate:model.coordinate];
    [self.imgView addSubview:pinView];
    
}

-(void)resetPointAnnotation:(MapModel *)model atIndex:(NSInteger)index {
    
    NSArray *viewArray = self.imgView.subviews;
//    PinImageView *pinView = viewArray[index];
//    if (model.isMark) {
//        pinView.backgroundColor = [UIColor redColor];
//    }else {
//        pinView.backgroundColor = [UIColor blueColor];
//    }
    for (int i = 0; i < viewArray.count; i++) {
        PinImageView *pinView = viewArray[i];
        if (i == index) {
            pinView.backgroundColor = [UIColor redColor];
        }else {
            pinView.backgroundColor = [UIColor blueColor];
        }
    }
}

// 设置初始比例
- (void)setMapScale:(CGFloat )mapScale {
    
    CGRect tmpRect = self.imgView.frame;
    CGPoint anchorPoint = CGPointMake(0.5,0.5); // 缩放中心点,锚点
    CGFloat x,y,width,height;
    x = anchorPoint.x * tmpRect.size.width * (1 - mapScale) + tmpRect.origin.x;
    y = anchorPoint.y * tmpRect.size.height * (1 - mapScale) + tmpRect.origin.y;
    width = tmpRect.size.width * mapScale;
    height = tmpRect.size.height * mapScale;
    self.imgView.frame = CGRectMake(x, y, width, height);
    
}

- (void)scaleImageView:(UIPinchGestureRecognizer *)gesture {
    
    if([gesture state] == UIGestureRecognizerStateEnded) {
        lastScale = 1.0;
        return;
    }
    
    CGFloat scale = 1.0 - (lastScale - gesture.scale);
    CGRect tmpRect = self.imgView.frame;
    if (gesture.numberOfTouches < 2) {
        return;
    }
    CGPoint p1 = [gesture locationOfTouch:0 inView:self.imgView];
    CGPoint p2 = [gesture locationOfTouch:1 inView:self.imgView];
    CGPoint anchorPoint = CGPointMake((p1.x+p2.x) /2.0 / tmpRect.size.width,(p1.y+p2.y)/2.0 / tmpRect.size.height); // 缩放中心点,锚点
    
    CGFloat x,y,width,height;
    x = anchorPoint.x * tmpRect.size.width * (1 - scale) + tmpRect.origin.x;
    y = anchorPoint.y * tmpRect.size.height * (1 - scale) + tmpRect.origin.y;
    width = tmpRect.size.width * scale;
    height = tmpRect.size.height * scale;
    self.imgView.frame = CGRectMake(x, y, width, height);
    
    lastScale = gesture.scale;
    if (self.imgView.frame.size.width <= self.bounds.size.width) {
        self.imgView.frame = self.bounds;
    }
    [self setViewInSuper];
    
}

- (void)moveImageView:(UIPanGestureRecognizer *)gesture {
    
    CGPoint point = [gesture translationInView:self];
    gesture.view.center = CGPointMake(gesture.view.center.x + point.x, gesture.view.center.y + point.y);
    [self setViewInSuper];
    [gesture setTranslation:CGPointMake(0, 0) inView:self];
    
}

- (void)setViewInSuper {
    
    if (self.imgView.frame.origin.x >= 0) {
        CGRect tmpRect = self.imgView.frame;
        tmpRect.origin.x = 0;
        self.imgView.frame = tmpRect;
    }
    
    if (self.imgView.frame.origin.y >= 0) {
        CGRect tmpRect = self.imgView.frame;
        tmpRect.origin.y = 0;
        self.imgView.frame = tmpRect;
    }
    
    if ((self.imgView.frame.origin.x + self.imgView.frame.size.width) <= self.bounds.size.width) {
        CGRect tmpRect = self.imgView.frame;
        tmpRect.origin.x = self.bounds.size.width - tmpRect.size.width;
        self.imgView.frame = tmpRect;
    }
    
    if ((self.imgView.frame.origin.y + self.imgView.frame.size.height) <= self.bounds.size.height) {
        CGRect tmpRect = self.imgView.frame;
        tmpRect.origin.y = self.bounds.size.height - tmpRect.size.height;
        self.imgView.frame = tmpRect;
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
