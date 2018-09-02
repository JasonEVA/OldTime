//
//  MissionCCTeamLeaderCell.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//  抄送团队长CELL


#import <UIKit/UIKit.h>

typedef void(^MissionCCTeamLeaderCellBlock)(BOOL state);

@interface MissionCCTeamLeaderCell : UITableViewCell
+ (NSString *)identifier;

@property (nonatomic, strong) UILabel *lblTitle;
- (void)switchDidSelect:(MissionCCTeamLeaderCellBlock)selectBlock;

- (void)configSwitchState:(BOOL)state;
@end
