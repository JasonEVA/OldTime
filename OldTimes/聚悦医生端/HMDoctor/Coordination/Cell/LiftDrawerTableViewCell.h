//
//  LiftDrawerTableViewCell.h
//  launcher
//
//  Created by TabLiu on 16/2/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  任务分类Cell

#import <UIKit/UIKit.h>

@class TaskTypeTitleAndCountModel;

@interface LiftDrawerTableViewCell : UITableViewCell

- (void)configCellIsSelect:(BOOL)isSelect;

- (void)configCellDataWithModel:(TaskTypeTitleAndCountModel *)model iconName:(NSString *)iconName;

@end
