//
//  MissionDetailSubcellTableViewCell.h
//  launcher
//
//  Created by Kyle He on 15/8/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  任务详情中间的子任务

#import <UIKit/UIKit.h>

@class MissionDetailModel, MissionDetailSubcellTableViewCell;

typedef void(^MissionSubCellClickBlock)(MissionDetailSubcellTableViewCell *clickedCell);

@interface MissionDetailSubcellTableViewCell : UITableViewCell

+ (NSString *)identifier;

- (void)clickedMore:(MissionSubCellClickBlock )clickBlock;

- (void)setDataWithModel:(MissionDetailModel *)model;

@end
