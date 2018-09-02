//
//  HMPingAnPayAddCardViewController.h
//  HMClient
//
//  Created by jasonwang on 2016/11/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//  平安支付添加银行卡页

#import "HMBaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol HMPingAnPayAddCardViewControllerDelegate <NSObject>

- (void)HMPingAnPayAddCardViewControllerDelegateCallBack_reLoadCardList;

@end

@class HMPingAnPayParmsModel;
@interface HMPingAnPayAddCardViewController : HMBaseViewController
@property (nonatomic, strong) HMPingAnPayParmsModel *model;
@property (nonatomic, weak) id<HMPingAnPayAddCardViewControllerDelegate> delegate;
@end
