//
//  ServiceOrder.m
//  HMClient
//
//  Created by yinqaun on 16/5/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceOrder.h"

@implementation ServiceOrderPayResp


@end

@implementation ServiceOrder

- (NSString*) payUrl
{
    if (_payResult)
    {
        return _payResult.payUrl;
    }
    return nil;
}
@end
