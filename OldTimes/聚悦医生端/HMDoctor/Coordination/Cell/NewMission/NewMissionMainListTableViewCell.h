//
//  NewMissionMainListTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 16/8/4.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MissionDetailModel;
@interface NewMissionMainListTableViewCell : UITableViewCell
- (void)setCellDataWithModel:(MissionDetailModel *)model;
@end
