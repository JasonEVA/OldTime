//
//  MessageHistoryMissionCell.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/27.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MissionDetailModel.h"

@interface MessageHistoryMissionCell : UITableViewCell
+ (NSString *)identifier;
- (void)setCellDataWithModel:(MissionDetailModel *)model;

@end
