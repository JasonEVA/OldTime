//
//  MissionDetailTitleTableViewCell.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/4.
//  Copyright © 2016年 yinquan. All rights reserved.
// 任务详情titlecell

#import <UIKit/UIKit.h>

@class MissionDetailModel;

@interface MissionDetailTitleTableViewCell : UITableViewCell

- (void)configTitleCellWithModel:(MissionDetailModel *)model;
@end
