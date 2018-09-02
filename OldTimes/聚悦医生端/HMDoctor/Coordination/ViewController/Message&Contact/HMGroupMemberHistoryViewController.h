//
//  HMGroupMemberHistoryViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2017/4/10.
//  Copyright © 2017年 yinquan. All rights reserved.
//  某一群成员的历史聊天记录vc

#import "HMBaseViewController.h"

@class UserProfileModel;
@interface HMGroupMemberHistoryViewController : HMBaseViewController
- (instancetype)initWithUserProfileModel:(UserProfileModel *)model groupId:(NSString *)groupId;
@end
