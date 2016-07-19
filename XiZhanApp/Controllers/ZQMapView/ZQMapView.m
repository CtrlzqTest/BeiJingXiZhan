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
#import "BubView.h"

@interface ZQMapView()<PinImageViewDelegate>{
    CGFloat lastScale;
    CGFloat minScale, maxScale;
    CGFloat old_y; // 记录缩放到原始状态时的Y值
    BOOL _shouldScale;
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

-(void)setMapImage:(UIImage *)mapImage {
    
    if (_mapImage != mapImage) {
        self.imgView.image = mapImage;
        _mapImage = mapImage;
    }
}

- (void)setupViews {
    
    self.imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imgView.backgroundColor = [UIColor blackColor];
    self.imgView.userInteractionEnabled = YES;
    lastScale=1.0;minScale = 1.0;old_y = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.imgView addGestureRecognizer:tap];
    
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImageView:)];
    [self.imgView addGestureRecognizer:pin];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImageView:)];
    [self.imgView addGestureRecognizer:pan];
    
    self.imgView.image = self.mapImage;
    self.imageSize = self.mapImage.size;
    
    [self.imgView setAutoresizesSubviews:YES];
    [self addSubview:self.imgView];
    
    self.clipsToBounds = YES;
    _shouldScale = YES;
    
    self.bubView = [[[NSBundle mainBundle] loadNibNamed:@"BubView" owner:self options:nil] objectAtIndex:0];
    self.bubView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.bubView.frame = CGRectMake(0, 0, 200, 60);
    [self.imgView addSubview:self.bubView];
    self.bubView.hidden = YES;
    
}

#pragma mark -- PinImageViewDelegate
- (void)tapPinView:(PinImageView *)pinView {
    
    self.bubView.center = CGPointMake(pinView.center.x + 90, pinView.center.y - 45);
    
    self.bubView.hidden = NO;
    _shouldScale = NO;
    
}

// 添加大头针
-(void)addPointAnnotation:(MapModel *)model {
    
    PinImageView *pinView = [[PinImageView alloc] initWithCoordinate:model.coordinate];
    pinView.delegate = self;
    [self.imgView addSubview:pinView];
    
}

- (void)tapAction:(UITapGestureRecognizer *)gesture {
    
    self.bubView.hidden = YES;
    _shouldScale = YES;
    
}

-(void)resetPointAnnotation:(MapModel *)model atIndex:(NSInteger)index {
    
    NSArray *viewArray = self.imgView.subviews;
    for (int i = 0; i < viewArray.count; i++) {
        
        PinImageView *pinView = viewArray[i];
        
        if (i == index + 1) {
            NSLog(@"pinView:%@",NSStringFromCGRect(pinView.frame));
            NSLog(@"supView:%@",NSStringFromCGRect(self.imgView.frame));
            pinView.backgroundColor = [UIColor redColor];
            [self setPinViewInMapView:pinView];
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

// 坐标点自动显示在视野里
- (void)setPinViewInMapView:(PinImageView *)pinView {
    
    CGRect tmpRect = pinView.frame;
    CGFloat centerX,centerY;
    if (tmpRect.origin.x <= self.frame.size.width / 2.0) {
        centerX = -self.imgView.frame.origin.x;
    }else {
//        centerX = self.frame.size.width / 2.0 + tmpRect.origin.x;
        centerX = -self.imgView.frame.origin.x - tmpRect.origin.x + self.frame.size.width / 2.0;
    }
    
    if (tmpRect.origin.y <= self.frame.size.height / 2.0) {
        centerY = -self.imgView.frame.origin.y;
    }else {
        centerY = -self.imgView.frame.origin.y - tmpRect.origin.y + self.frame.size.height / 2.0;
    }
    CGPoint point = self.imgView.center;
    [UIView transitionWithView:self.imgView duration:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.imgView.center = CGPointMake(point.x + centerX,point.y + centerY);
    } completion:^(BOOL finished) {
        
    }];
}


// 地图手势缩放
- (void)scaleImageView:(UIPinchGestureRecognizer *)gesture {
    
    if (_shouldScale == NO) {
        return;
    }
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
    [self resetAnnotationsPosition];
}

-(void)resetAnnotationsPosition {
    
    CGFloat scale = self.imgView.frame.size.width / [UIScreen mainScreen].bounds.size.width;
    for (UIView *view in self.imgView.subviews) {
        if ([view isKindOfClass:[PinImageView class]]) {
            PinImageView *pinview = (PinImageView *)view;
            CGFloat centerX = pinview.coordinate.x * scale;
            CGFloat centerY = pinview.coordinate.y * scale;
            view.center = CGPointMake(centerX, centerY);
        }
    }
}

// 拖动地图
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
