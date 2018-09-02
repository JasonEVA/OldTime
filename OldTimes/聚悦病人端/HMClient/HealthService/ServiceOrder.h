//
//  ServiceOrder.h
//  HMClient
//
//  Created by yinqaun on 16/5/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceOrderPayResp : NSObject
{
    
}

@property (nonatomic, retain) NSString* payUrl;
@property (nonatomic, retain) NSString* jsonParam;
@end

@interface ServiceOrder : NSObject
{
    
}
@property (nonatomic, assign) NSInteger orderId;        //订单ID,
@property (nonatomic, assign) float orderMoney;         //订单实际总金额,
@property (nonatomic, retain) NSString* orderNo;
@property (nonatomic, retain) NSString* orderName;      //订单名称
@property (nonatomic, copy) NSString* jumpUrl;          //亲友付生成二维码用

@property (nonatomic, retain) NSString* payStatus;

@property (nonatomic, retain) ServiceOrderPayResp* payResult;
@property (nonatomic, retain) NSString* payUrl;
@end
