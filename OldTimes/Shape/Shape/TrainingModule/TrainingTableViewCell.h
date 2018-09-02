//
//  TrainingTableViewCell.h
//  Shape
//
//  Created by jasonwang on 15/10/30.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
// 训练的CELL


#import <UIKit/UIKit.h>
#import "TrainStrengthView.h"
#import "TrainGetTrainDataArrayModel.h"
#import "TrainGetMyTrainListModel.h"
#import "TrainRoundnessProgressBar.h"

@interface TrainingTableViewCell : UITableViewCell
- (instancetype)initWithShowStrength:(BOOL)showStrength reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setMyData:(TrainGetTrainDataArrayModel *)model;
- (void)setModelData:(TrainGetMyTrainListModel *)model;
@end
