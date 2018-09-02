//
//  ChatSelectForwardUsersViewController.h
//  launcher
//
//  Created by williamzhang on 16/3/28.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  消息选择转发界面

#import "BaseViewController.h"
#import <MintcodeIM/MintcodeIM.h>

@interface ChatSelectForwardUsersViewController : BaseViewController

/**
 *  获取筛选过的数据
 *
 *  @param merge    是否合并
 *
 *  @return 能够转发的数据
 */
+ (NSArray *)handledMessages:(NSArray <MessageBaseModel *>*)messages merge:(BOOL)merge;

- (instancetype)initWithForwardMerge:(BOOL)isMerge
                     sessionNickName:(NSString *)sessionNickName
                            messages:(NSArray<MessageBaseModel *> *)messages
                             isGroup:(BOOL)isGroup
                          completion:(void (^)())completion;

@end
