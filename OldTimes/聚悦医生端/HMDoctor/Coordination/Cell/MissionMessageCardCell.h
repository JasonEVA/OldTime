//
//  MissionMessageCardCell.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//  任务卡片Cell

#import <UIKit/UIKit.h>
#import "MissionDetailModel.h"
typedef void (^MissionMessageCardCellBlock)(BOOL isAccept);
@interface MissionMessageCardCell : UITableViewCell
+ (NSString *)identifier;
//接受或拒绝按钮回调
- (void)clickBtnBlock:(MissionMessageCardCellBlock)clickBlock;
- (void)setCellDataWithModel:(MissionDetailModel *)model;
@end
