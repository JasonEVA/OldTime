//
//  HMPingAnPayOrderModel.h
//  HMClient
//
//  Created by jasonwang on 2016/11/22.
//  Copyright © 2016年 YinQ. All rights reserved.
//  平安支付订单model

#import <Foundation/Foundation.h>

@interface HMPingAnPayOrderModel : NSObject
@property (nonatomic, copy) NSString *customerId;        //userid
@property (nonatomic, copy) NSString *orderId;           //订单号
@property (nonatomic, copy) NSString *paydate;
@property (nonatomic) float amount;                   //价格
@property (nonatomic, copy) NSString *objectName;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *openId;            //银行卡ID
@property (nonatomic, copy) NSString *verifyCode;        //验证码
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *masterId;
@property (nonatomic) NSInteger validtime;             //有效期
@end
