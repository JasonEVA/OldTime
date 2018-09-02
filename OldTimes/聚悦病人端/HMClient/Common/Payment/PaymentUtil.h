//
//  PaymentUtil.h
//  HMClient
//
//  Created by yinquan on 16/11/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PaymentSuccessBlock)();
typedef void(^PaymentFailedBlock)();

typedef NS_ENUM(NSUInteger, EPaymentType) {
    Order_None,
    Order_ServiceOrder,  //支付宝支付
    
};

@interface PaymentUtil : NSObject
{
    
}
@property (nonatomic, readonly) id payParam;        //支付参数
@property (nonatomic, readonly) NSString* orderId;  //订单ID
@property (nonatomic, readonly) EPaymentType orderType;  //订单类型

+ (PaymentUtil*) shareInstance;



- (void) payOrder:(id) payParam
          orderId:(NSString*) orderId
     successBlock:(PaymentSuccessBlock) successBlock
      failedBlock:(PaymentFailedBlock) failedBlock;


- (void) doPayOrderSuccess;
- (void) doPayOrderFailed;

- (void) payOrderFinish;

@end
