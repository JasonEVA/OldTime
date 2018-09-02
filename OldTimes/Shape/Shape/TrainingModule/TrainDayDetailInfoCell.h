//
//  TrainDayDetailInfoCell.h
//  Shape
//
//  Created by jasonwang on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainGetDayTrainInfoModel.h"

@interface TrainDayDetailInfoCell : UITableViewCell
@property (nonatomic, strong) UILabel *trainNameLb;
@property (nonatomic, strong) UILabel *trainName;
@property (nonatomic, strong) UILabel *todayNum;
@property (nonatomic, strong) UILabel *totalDayNum;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *actionLb;
@property (nonatomic, strong) UILabel *action;
@property (nonatomic, strong) UILabel *costLb;
@property (nonatomic, strong) UILabel *cost;

- (void)setMyData:(TrainGetDayTrainInfoModel *)model;
@end
