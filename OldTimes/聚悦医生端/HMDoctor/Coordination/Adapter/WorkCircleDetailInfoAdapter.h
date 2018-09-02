//
//  WorkCircleDetailInfoAdapter.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//  工作圈详情adapter

#import "ATTableViewAdapter.h"
@class UserProfileModel,ContactDetailModel;


typedef void(^GroupNameEndEdit)(BOOL end, NSString *newName, NSString *oldName);

typedef void(^MessageReminderState)(BOOL switchState);

@protocol WorkCircleDetailInfoAdapterDelegate <NSObject>

- (void)workCircleDetailInfoAdapterDelegateCallBack_circleMemberClickedWithModel:(UserProfileModel *)model;

- (void)workCircleDetailInfoAdapterDelegateCallBack_addMemberClicked;


@end
@interface WorkCircleDetailInfoAdapter : ATTableViewAdapter

@property (nonatomic, weak)  id<WorkCircleDetailInfoAdapterDelegate>  customDelegate; // <##>

- (void)addGroupNameNoti:(GroupNameEndEdit)groupNameNoti;
- (void)addMessageReminderNoti:(MessageReminderState)messageReminderNoti;
- (void)configUserProfileModel:(UserProfileModel *)userProfileModel;
- (void)configContactDetailModel:(ContactDetailModel *)contactDetailModel;
@end
