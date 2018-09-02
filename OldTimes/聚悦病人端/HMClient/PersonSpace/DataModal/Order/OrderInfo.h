//
//  OrderInfo.h
//  HMClient
//
//  Created by yinqaun on 16/5/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kOrderIdKey         @"orderId"
#define kOrderNameKey         @"orderName"
#define kOrderTypeCodeKey         @"orderTypeCode"

@interface OrderInfo : NSObject
{
    
}

@property (nonatomic, retain) NSString* createTime;
@property (nonatomic, retain) NSString* imgUrl;
@property (nonatomic, retain) NSString* orderName;
@property (nonatomic, assign) NSInteger orderNum;
@property (nonatomic, retain) NSString* orderNo;
@property (nonatomic, assign) NSInteger orderStatus;
@property (nonatomic, assign) float orderMoney;
@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, retain) NSString* orderTypeCode;
@property (nonatomic, assign) NSInteger orderTypeId;

@property (nonatomic, retain) NSString* orderStatusName;
@property (nonatomic, retain) NSString* payStatus;      //free 免费
@property (nonatomic, copy) NSString* jumpUrl;          //亲友付生成二维码用

@end
