//
//  NewMissionListTableViewCell.h
//  launcher
//
//  Created by TabLiu on 16/2/16.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "SWTableViewCell.h"
#import "TaskListModel.h"


@protocol NewMissionListTableViewCellDelegate <NSObject>

- (void)NewMissionListTableViewCell_CompleteButtonClick:(NSIndexPath *)path;
- (void)NewMissionListTableViewCell_SwitchButtonClick:(NSIndexPath *)path;

@end


@interface NewMissionListTableViewCell : SWTableViewCell


@property (nonatomic,strong) NSIndexPath * path;
@property (nonatomic, assign) BOOL opening;
@property (nonatomic,weak) id <NewMissionListTableViewCellDelegate> buttonDelegate;

- (void)setSearchText:(NSString *)string;
- (void)setNeedShowHeadImg:(BOOL)isNeed;
- (void)setCellData:(TaskListModel *)model; // 跟任务
- (void)setProjrctData:(TaskListModel *)model;// 子任务
- (void)SetLineHidden:(BOOL)hidden;
- (UIView *)getSnapCurrentCell;
@end
