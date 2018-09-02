//
//  MissionMainTableViewCell.h
//  launcher
//
//  Created by Kyle He on 15/8/27.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "SWTableViewCell.h"

@class MissionMainTableViewCell, MissionMainViewModel;

@protocol MissionMainTableViewCellDelegate <NSObject>

- (void)missionMainTableViewCellDelegateCallBack_showSubcell:(MissionMainTableViewCell *)cell;

@end

@interface MissionMainTableViewCell : SWTableViewCell

@property(nonatomic, weak) id<MissionMainTableViewCellDelegate> showSubDelegate;

+ (NSString *)identifier;
+ (CGFloat)height;

- (void)setCellWithModel:(MissionMainViewModel *)model;

@end
