//
//  MeTrainHistoryDetailView.h
//  Shape
//
//  Created by jasonwang on 15/11/13.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//  训练历史View

#import <UIKit/UIKit.h>
#import "MeTrainHistoryDetailModel.h"

@interface MeTrainHistoryDetailView : UIView
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *dayLb;
@property (nonatomic, strong) UILabel *costDistanceTitel;
@property (nonatomic, strong) UILabel *costDistanceValue;
@property (nonatomic, strong) UILabel *timeTitel;
@property (nonatomic, strong) UILabel *timeValue;
@property (nonatomic, strong) UILabel *speedTitel;
@property (nonatomic, strong) UILabel *speedValue;
@property (nonatomic, strong) UIImageView *imageView;
- (void)setMyContent:(MeTrainHistoryDetailModel *)model;
@end
