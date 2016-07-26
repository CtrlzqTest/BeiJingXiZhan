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
#define kImageWidth ([UIScreen mainScreen].bounds.size.height - 64)

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

-(instancetype)initWithFrame:(CGRect)frame imageType:(MapImageType )imageType {
    
    if (self = [super initWithFrame:frame]) {
//        self.bounds = frame;
        [self setupViews];
//        self.imageType = imageType;
    }
    return self;
}

-(void)setImageType:(MapImageType)imageType {
    if (_imageType != imageType) {
        _imageType = imageType;
        self.imgView.image = [self imageWithType:imageType];
    }
}

-(void)setMapImage:(UIImage *)mapImage {
    
    if (_mapImage != mapImage) {
        self.imgView.image = mapImage;
        _mapImage = mapImage;
    }
}

- (void)setupViews {
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kImageWidth, kImageWidth)];
    self.imgView.center = CGPointMake(self.center.x, self.center.y - 32);
    self.imgView.userInteractionEnabled = YES;
    lastScale=1.0;minScale = 1.0;old_y = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.imgView addGestureRecognizer:tap];
    
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImageView:)];
    [self.imgView addGestureRecognizer:pin];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImageView:)];
    [self.imgView addGestureRecognizer:pan];
    
//    self.imgView.image = self.mapImage;
    self.imgView.image = [self imageWithType:self.imageType];
    self.imageSize = self.mapImage.size;
    
    [self.imgView setAutoresizesSubviews:YES];
    [self addSubview:self.imgView];
    
    self.clipsToBounds = YES;
    _shouldScale = YES;

    self.bubView = [[[NSBundle mainBundle] loadNibNamed:@"BubView" owner:self options:nil] objectAtIndex:0];
    self.bubView.frame = CGRectMake(0, self.frame.size.height - 64, KWidth, 80);
    [self addSubview:self.bubView];
//    self.bubView.hidden = YES;
    
}

#pragma mark -- PinImageViewDelegate
- (void)tapPinView:(PinImageView *)pinView {
    
    if ([self.delegate respondsToSelector:@selector(tapMapAction)]) {
        [self.delegate tapMapAction];
    }
    
    [self.bubView setDataWithModel:pinView.mapModel];
    [UIView transitionWithView:self.bubView duration:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.bubView.transform = CGAffineTransformMakeTranslation(0, -80);
    } completion:^(BOOL finished) {
        
    }];
//    self.bubView.center = CGPointMake(pinView.center.x + 90, pinView.center.y - 45);
//    
//    self.bubView.hidden = NO;
//    _shouldScale = NO;
    
}

// 添加大头针
-(void)addPointAnnotation:(MapModel *)model {
    
    PinImageView *pinView = [[PinImageView alloc] initWithCoordinate:model.coordinate];
    pinView.delegate = self;
    pinView.mapModel = model;
    pinView.tag = model.pinTag;
    if (model.isMark) {
        pinView.backgroundColor = [UIColor redColor];
    }
    [self.imgView addSubview:pinView];
    
}

-(void)resetPointAnnotation:(MapModel *)model atIndex:(NSInteger)index {
    
//    NSArray *viewArray = self.imgView.subviews;
//    for (int i = 0; i < viewArray.count; i++) {
//        
//        PinImageView *pinView = viewArray[i];
//        
//        if (i == index) {
////            NSLog(@"pinView:%@",NSStringFromCGRect(pinView.frame));
////            NSLog(@"supView:%@",NSStringFromCGRect(self.imgView.frame));
//            pinView.backgroundColor = [UIColor redColor];
//            [self.imgView bringSubviewToFront:pinView];
//            [self setPinViewInMapView:pinView];
//        }else {
//            pinView.backgroundColor = [UIColor blueColor];
//        }
//    }
    
    PinImageView *pinView = [self.imgView viewWithTag:model.pinTag];
    pinView.backgroundColor = [UIColor redColor];
    [self.imgView bringSubviewToFront:pinView];
    [self setPinViewInMapView:pinView];
    
    NSArray *viewArray = self.imgView.subviews;
    for (int i = 0; i < viewArray.count; i++) {
        
        PinImageView *pinView_other = viewArray[i];
        if (pinView.tag != pinView_other.tag) {
            pinView_other.backgroundColor = [UIColor blueColor];
        }
    }
}

// 重新加载地图
- (void)resetMapView:(NSArray *)modelArray{
    
    if (modelArray.count <= 0) {
        return;
    }
    MapModel *mapModel = modelArray[0];
    self.imageType = mapModel.imageType;
    [self.imgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (MapModel *model in modelArray) {
        [self addPointAnnotation:model];
    }
    [self resetAnnotationsPosition];
}

#pragma mark -- 私有方法
- (void)tapAction:(UITapGestureRecognizer *)gesture {
    
    if ([self.delegate respondsToSelector:@selector(tapMapAction)]) {
        [self.delegate tapMapAction];
    }
    [self hideBubView];
//    self.bubView.hidden = YES;
//    _shouldScale = YES;
}

// 影藏气泡
- (void)hideBubView {
    [UIView transitionWithView:self.bubView duration:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.bubView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (UIImage *)imageWithType:(MapImageType )imageType {
    
    UIImage *image = nil;
    switch (imageType) {
        case MapImageType1:
            image = [UIImage imageNamed:@"floor-1.jpg"];
            break;
        case MapImageType2:
            image = [UIImage imageNamed:@"floor-2.jpg"];
            break;
        case MapImageType3:
            break;
        default:
            break;
    }
    return image;
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
    if (tmpRect.origin.x <= self.frame.size.width / 2.0 || self.imgView.frame.size.width - tmpRect.origin.x <= self.frame.size.width / 2.0) {
        centerX = -self.imgView.frame.origin.x;
    }else {
//        centerX = self.frame.size.width / 2.0 + tmpRect.origin.x;
        centerX = -self.imgView.frame.origin.x - tmpRect.origin.x + self.frame.size.width / 2.0;
    }
    
    if (tmpRect.origin.y <= kImageWidth / 2.0 || self.imgView.frame.size.height - tmpRect.origin.y <= kImageWidth / 2.0) {
        centerY = -self.imgView.frame.origin.y;
    }else {
        centerY = -self.imgView.frame.origin.y - tmpRect.origin.y + kImageWidth / 2.0;
//        centerY = -self.imgView.frame.origin.y - self.imgView.frame.size.height + kImageWidth;
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
    // 缩放到最小就不缩放了
    CGFloat center_X = self.imgView.center.x;
    if (self.imgView.frame.size.height <= kImageWidth) {
        self.imgView.frame = CGRectMake(0, 0, kImageWidth, kImageWidth);
        self.imgView.center = CGPointMake(center_X, self.center.y - 32);
    }
    [self setViewInSuper];
    [self resetAnnotationsPosition];
}

// 修改坐标点的位置
-(void)resetAnnotationsPosition {
    
    CGFloat scale = self.imgView.frame.size.height / kImageWidth;
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
    
    if ((self.imgView.frame.origin.y + self.imgView.frame.size.height) <= kImageWidth) {
        CGRect tmpRect = self.imgView.frame;
        tmpRect.origin.y = kImageWidth - tmpRect.size.height;
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
