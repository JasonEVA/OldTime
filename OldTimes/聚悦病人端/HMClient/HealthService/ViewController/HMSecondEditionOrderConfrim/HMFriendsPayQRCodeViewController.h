//
//  HMFriendsPayQRCodeViewController.h
//  HMClient
//
//  Created by jasonwang on 2017/10/17.
//  Copyright © 2017年 YinQ. All rights reserved.
//  亲友付二维码界面

#import "HMBaseViewController.h"
@class ServiceOrder;
@class OrderInfo;

@interface HMFriendsPayQRCodeViewController : HMBaseViewController

// 首次支付流程
- (instancetype)initWithOrderModel:(ServiceOrder *)model name:(NSString *)name;

// 从未支付完成继续支付
- (instancetype)initWithOrderInfoModel:(OrderInfo *)model name:(NSString *)name;

@end
