//
//  TaxiMsgTableCell.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/3.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "TaxiMsgTableCell.h"
#import "MessageModel.h"
#import "TaxiMsgModel.h"

@implementation TaxiMsgTableCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCellView];
    }
    return self;
}
-(void)initCellView
{
    self.taxiStationNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(9*ProportionWidth, 34*ProportionHeight, 103*ProportionWidth, 26*ProportionHeight)];
    self.taxiStationNameLabel.numberOfLines = 0;
    self.taxiStationNameLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.taxiStationNameLabel];

    self.taxiShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(131*ProportionWidth, 11*ProportionHeight, 120*ProportionWidth, 26*ProportionHeight)];
    self.taxiShowLabel.textColor = mainColor;
    self.taxiShowLabel.text = @"出租车待客";
    [self.contentView addSubview:self.taxiShowLabel];
    
    self.peopleShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(131*ProportionWidth, 51*ProportionHeight, 120*ProportionWidth, 26*ProportionHeight)];
    self.peopleShowLabel.textColor = mainColor;
    self.peopleShowLabel.text = @"候车乘客";
    [self.contentView addSubview:self.peopleShowLabel];
    
    self.taxiCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(270*ProportionWidth, 11*ProportionHeight, 50*ProportionWidth, 26*ProportionHeight)];
    [self.contentView addSubview:self.taxiCountLabel];
    
    self.peopleCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(270*ProportionWidth, 55*ProportionHeight, 50*ProportionWidth, 26*ProportionHeight)];
    [self.contentView addSubview:self.peopleCountLabel];
    
    self.taxiDanWeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(337*ProportionWidth, 11*ProportionHeight, 23*ProportionWidth, 26*ProportionHeight)];
    self.taxiDanWeiLabel.textColor = mainColor;
    self.taxiDanWeiLabel.text = @"辆";
    [self.contentView addSubview:self.taxiDanWeiLabel];
    
    self.peopleDanWeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(337*ProportionWidth, 55*ProportionHeight, 23*ProportionWidth, 26*ProportionHeight)];
    self.peopleDanWeiLabel.textColor = mainColor;
    self.peopleDanWeiLabel.text = @"人";
    [self.contentView addSubview:self.peopleDanWeiLabel];
    
    self.layerLabel = [[UILabel alloc]initWithFrame:CGRectMake(5*ProportionWidth, 8*ProportionHeight, 367*ProportionWidth, 77*ProportionHeight)];
    self.layerLabel.backgroundColor = [UIColor clearColor];
    self.layerLabel.text = @"";
    [self.contentView addSubview:self.layerLabel];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)writeDataWithModel:(TaxiMsgModel *)msgModel
{
    self.layerLabel.layer.cornerRadius = 35.0;
    self.layerLabel.layer.masksToBounds = YES;
    self.layerLabel.layer.borderWidth = 2.0;
    self.layerLabel.layer.borderColor = colorref;
    
    self.taxiStationNameLabel.textColor = mainColor;
    self.taxiStationNameLabel.text = msgModel.taxiRankName;
   // self.taxiStationNameLabel.adjustsFontSizeToFitWidth = YES;
    //[self.taxiStationNameLabel sizeToFit];
    CGSize size = CGSizeMake(103*ProportionWidth, 80*ProportionHeight);//设置展示内容的宽高
    CGSize labelSize = [msgModel.taxiRankName sizeWithFont:self.taxiStationNameLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    self.taxiStationNameLabel.frame = CGRectMake(9*ProportionWidth, 34*ProportionHeight,labelSize.width, labelSize.height);
    self.taxiStationNameLabel.text = msgModel.taxiRankName;
    
    self.taxiCountLabel.textColor = mainColor;
    self.taxiCountLabel.text = msgModel.taxiCount;
    self.taxiCountLabel.adjustsFontSizeToFitWidth = YES;
    self.taxiCountLabel.layer.cornerRadius = 15.0;
    self.taxiCountLabel.textAlignment = NSTextAlignmentCenter;
    //  [self.taxiCountLabel sizeToFit];
    self.taxiCountLabel.layer.masksToBounds = YES;
    self.taxiCountLabel.layer.borderWidth = 2.0;
    self.taxiCountLabel.layer.borderColor = colorref;
    
    self.peopleCountLabel.textColor = mainColor;
    self.peopleCountLabel.adjustsFontSizeToFitWidth = YES;
    self.peopleCountLabel.text = msgModel.peopleCount;
    self.peopleCountLabel.textAlignment = NSTextAlignmentCenter;
    //[self.peopleCountLabel sizeToFit];
    self.peopleCountLabel.layer.cornerRadius = 15.0;
    self.peopleCountLabel.layer.masksToBounds = YES;
    self.peopleCountLabel.layer.borderWidth = 2.0;
    self.peopleCountLabel.layer.borderColor = colorref;
}
@end
