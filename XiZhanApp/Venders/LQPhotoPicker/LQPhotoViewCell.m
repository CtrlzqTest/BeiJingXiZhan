//
//  LQPhotoViewCell.m
//  LQPhotoPicker
//
//  Created by lawchat on 15/9/22.
//  Copyright (c) 2015年 Fillinse. All rights reserved.
//

#import "LQPhotoViewCell.h"

@implementation LQPhotoViewCell

-(void)awakeFromNib {
    
    [self bringSubviewToFront:self.closeButton];
//  self.profilePhoto.layer.cornerRadius = (([UIScreen mainScreen].bounds.size.width- 64) / 4 - 10) / 2;
    self.profilePhoto.layer.cornerRadius = 45.0*ProportionWidth;
    self.profilePhoto.clipsToBounds = YES;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (void)setBigImgViewWithImage:(UIImage *)img{
    
//    if (_BigImgView) {
//        _BigImgView.frame = _profilePhoto.frame;
//        
//        _BigImgView.image = img;
//    }
//    else{
//        _BigImgView = [[UIImageView alloc]initWithImage:img];
//        _BigImgView.frame = _profilePhoto.frame;
//        [self insertSubview:_BigImgView atIndex:0];
//    }
//    _BigImgView.contentMode = UIViewContentModeScaleToFill;
}

@end
