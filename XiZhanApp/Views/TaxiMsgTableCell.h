//
//  TaxiMsgTableCell.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/3.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

//@property(nonatomic,strong)NSString *taxiStationName;
//@property(nonatomic,strong)NSString *areaID;
//@property(nonatomic,strong)NSString *taxiCount;
//@property(nonatomic,copy)NSString *laneCount;
//@property(nonatomic,copy)NSString *peopleCount;
//@property(nonatomic,copy)NSString *stationId;
#import <UIKit/UIKit.h>
@class MessageModel;
@class TaxiMsgModel;

static NSString *cellMsgTable = @"taxtMsgTableCell";

@interface TaxiMsgTableCell : UITableViewCell
@property(nonatomic,retain)IBOutlet UILabel *taxiStationNameLabel;
@property(nonatomic,retain)IBOutlet UILabel *taxiCountLabel;
@property(nonatomic,retain)IBOutlet UILabel *peopleCountLabel;
@property(nonatomic,retain)IBOutlet UILabel *layerLabel;

- (void)writeDataWithModel:(TaxiMsgModel *)msgModel;
@end
