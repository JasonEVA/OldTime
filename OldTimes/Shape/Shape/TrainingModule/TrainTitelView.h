//
//  TrainTitelView.h
//  Shape
//
//  Created by jasonwang on 15/11/2.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//  训练内容标题View

#import <UIKit/UIKit.h>
#import "TrainStrengthView.h"
#import "TrainGetTrainInfoModel.h"
#import "TrainGetDayTrainInfoModel.h"

@interface TrainTitelView : UIView

@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *instrumentLb;
@property (nonatomic, strong) TrainStrengthView *strengthView;
- (void)setMyData:(TrainGetTrainInfoModel *)model;
- (void)setDayInfoData:(TrainGetDayTrainInfoModel *)model;
@end
