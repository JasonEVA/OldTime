//
//  HMPingAnPayWaiverViewController.h
//  HMClient
//
//  Created by jasonwang on 2016/11/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//  平安支付免责协议页

#import "HMBaseViewController.h"
typedef void (^clickBlock)(NSInteger tag);

@interface HMPingAnPayWaiverViewController : HMBaseViewController
- (void)payWaiverClick:(clickBlock)block;

@end
