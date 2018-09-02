//
//  HMSessionListInteractor.h
//  HMClient
//
//  Created by jasonwang on 2017/10/19.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "ATModuleInteractor.h"

@interface HMSessionListInteractor : ATModuleInteractor

+ (instancetype)sharedInstance;

// 跳转会话列表
- (void)goToSessionList;

// 跳转某一会话
- (void)gotoChatVCWithFatherVC:(UIViewController *)fatherVC IMGroupId:(NSString *)IMGroupId;

// 去购买服务
- (void)gotoBuyService;
@end
