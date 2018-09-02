//
//  HMSecondEditionServiceOrderConfrimViewController.h
//  HMClient
//
//  Created by jasonwang on 2016/11/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//  第二版确认订单界面

#import "HMBaseViewController.h"

@class ServiceDetail;
@interface HMSecondEditionServiceOrderConfrimViewController : HMBaseViewController
- (instancetype)initWithServiceDetail:(ServiceDetail *)detail;
@property (nonatomic, retain) NSArray* needMsgItems;
@property (nonatomic, retain) NSString* recommendUserId;

@end
