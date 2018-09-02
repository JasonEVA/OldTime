//
//  MissionDetailTimeTanleViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 16/7/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//  任务详情时间cell

#import <UIKit/UIKit.h>

@class MissionDetailModel;
@interface MissionDetailTimeTanleViewCell : UITableViewCell
- (void)fillDataWithTitle:(MissionDetailModel *)model;
+ (NSString *)identifier;

@end
