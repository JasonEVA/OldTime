//
//  MissionMainListCell.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//  任务主列表Cell

#import <SWTableViewCell/SWTableViewCell.h>
#import "MissionDetailModel.h"
@class MissionTypeEnum;
//完成或者取消完成后的回调
typedef void(^changeMissionStateCallBackBlock)(BOOL isFinished, UITableViewCell *cell);

@interface MissionMainListCell : SWTableViewCell
- (void)setCellDataWithModel:(MissionDetailModel *)model withType:(MissionType)type;

- (void)finishedCallBlock:(changeMissionStateCallBackBlock)block;
@end
