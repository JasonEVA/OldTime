//
//  PaymentUtil.m
//  HMClient
//
//  Created by yinquan on 16/11/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PaymentUtil.h"

static PaymentUtil* defaultPaymentUtil = nil;

@interface PaymentUtil ()

@property (nonatomic, strong) PaymentSuccessBlock successBlock;
@property (nonatomic, strong) PaymentFailedBlock failedBlock;

@end

@implementation PaymentUtil

+ (PaymentUtil*) shareInstance
{
    if (!defaultPaymentUtil || ![defaultPaymentUtil isKindOfClass:[self class]])
    {
        defaultPaymentUtil = [[[self class] alloc]init];
    }
    return defaultPaymentUtil;
}


- (void) payOrder:(id) payParam
          orderId:(NSString*) orderId
     successBlock:(PaymentSuccessBlock) successBlock
      failedBlock:(PaymentFailedBlock) failedBlock
{
    _payParam = payParam;
    _orderId = orderId;
    
    _successBlock = successBlock;
    _failedBlock = failedBlock;
    
    [self doPayOrder];
}

- (void) doPayOrder
{
    
}

- (void) doPayOrderSuccess
{
    if (_successBlock)
    {
        _successBlock();
    }
}

- (void) doPayOrderFailed
{
    if (_failedBlock)
    {
        _failedBlock();
    }
}

- (void) payOrderFinish
{
    _payParam = nil;
    _orderId = nil;
    _orderType = Order_None;
    
    _successBlock = nil;
    _failedBlock = nil;
}

@end
