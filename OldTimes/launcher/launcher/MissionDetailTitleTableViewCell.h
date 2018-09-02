//
//  MissionDetailTitleTableViewCell.h
//  launcher
//
//  Created by Kyle He on 15/8/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  详细任务界面的中间子任务标题cell

#import <UIKit/UIKit.h>

@class MissionDetailModel;

@protocol MissionDetailTitleTableViewCellDelegate <NSObject>

@optional

- (void)MissionDetailTitleTableViewCellDelegateCallBack_showSubTasks;
- (void)MissionDetailTitleTableViewCellDelegateCallBack_pushAddNewTaskVC;

@end

@interface MissionDetailTitleTableViewCell : UITableViewCell

@property(nonatomic, weak) id<MissionDetailTitleTableViewCellDelegate> delegate;

+ (NSString *)identifier;

- (void)setSubTaskCount:(NSInteger )count isFolder:(BOOL)isFolder;

- (void)canCreateTaskForDetailModel:(MissionDetailModel *)detailModel;

@end
