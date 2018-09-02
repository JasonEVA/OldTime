//
//  HMInteractor.h
//  HMClient
//
//  Created by jasonwang on 2016/10/11.
//  Copyright © 2016年 YinQ. All rights reserved.
//  跳转类

#import "ATModuleInteractor.h"

@interface HMInteractor : ATModuleInteractor
+ (instancetype)sharedInstance;
//跳转病患聊天群
- (void)gotoChatVCWithFatherVC:(UIViewController *)fatherVC;

@end
