//
//  AddFriendSubViewController.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//  添加好友子页面

#import "HMBaseViewController.h"

@class DoctorCompletionInfoModel,ContactInfoModel;

@interface AddFriendSubViewController : HMBaseViewController
@property (nonatomic, strong) ContactInfoModel *model;
@property (nonatomic, strong)  DoctorCompletionInfoModel  *doctorInfo; // <##>
@end
