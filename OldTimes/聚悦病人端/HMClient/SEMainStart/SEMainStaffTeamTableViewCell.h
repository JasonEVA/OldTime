//
//  SEMainStaffTeamTableViewCell.h
//  HMClient
//
//  Created by JasonWang on 2017/5/2.
//  Copyright © 2017年 YinQ. All rights reserved.
//  第二版主页医生团队cell

#import <UIKit/UIKit.h>
@class TeamDetail;
@class UserCareInfo;
@class HMWeatherModel;

@interface SEMainStaffTeamTableViewCell : UITableViewCell
- (void)fillDataWithTeamModel:(TeamDetail *)mdoel cares:(NSArray <UserCareInfo *>*)caresArr;
- (void)fillWeatherDataWithModel:(HMWeatherModel *)model;
@end
