//
//  MissionMainListSentFromMeCell.h
//  HMDoctor
//
//  Created by jasonwang on 16/5/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//  任务主列表我发出的Cell

#import <UIKit/UIKit.h>
#import "MissionDetailModel.h"
#import <SWTableViewCell/SWTableViewCell.h>

@interface MissionMainListSentFromMeCell : SWTableViewCell

- (void)setCellDataWithModel:(MissionDetailModel *)model;

@end
