//
//  ServiceTeamConversationViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMBasePageViewController.h"

@class HMClientGroupChatModel;

@interface ServiceTeamConversationViewController : HMBasePageViewController

- (instancetype)initWithChatModel:(HMClientGroupChatModel *)chatModel;
@end
