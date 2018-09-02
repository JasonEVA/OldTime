//
//  MissionSendFromMeMessageCardCell.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//  从我发出的cell

#import <UIKit/UIKit.h>
#import "MissionDetailModel.h"

@interface MissionSendFromMeMessageCardCell : UITableViewCell
+ (NSString *)identifier;
- (void)setCellDataWithModel:(MissionDetailModel *)model;

@end
