//
//  HMSecondEditionPayWayViewController.h
//  HMClient
//
//  Created by jasonwang on 2016/12/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//  第二版支付组件

#import "HMBaseViewController.h"

@class ServiceDetail;
@class OrderInfo;
@interface HMSecondEditionPayWayViewController : HMBaseViewController
@property (nonatomic, retain) NSArray* needMsgItems;
@property (nonatomic, retain) NSString* recommendUserId;

//首次付款
- (instancetype)initWithServiceDetail:(ServiceDetail *)detail;
//未支付订单付款
- (instancetype)initWithPayWayList:(NSArray *)payWayList orderInfo:(OrderInfo *)orderInfo;
@end
