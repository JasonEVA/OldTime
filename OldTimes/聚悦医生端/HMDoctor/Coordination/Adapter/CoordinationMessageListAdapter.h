//
//  CoordinationMessageListAdapter.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//  工作组消息主页adapter

#import "ATTableViewAdapter.h"
@class ContactDetailModel;
@protocol CoordinationMessageListAdapterDelegate <NSObject>

- (void)CoordinationMessageListAdapterDelegateCallBack_muteNotification:(ContactDetailModel *)model;

@end

@interface CoordinationMessageListAdapter : ATTableViewAdapter

@property (nonatomic, weak) id <CoordinationMessageListAdapterDelegate> messageAdepterDelegate;

@end
