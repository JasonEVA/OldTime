//
//  WeiXinPaymentUtil.m
//  HMClient
//
//  Created by yinquan on 16/11/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "WeiXinPaymentUtil.h"
#import "WXApi.h"

@implementation WeiXinPaymentUtil

- (void) doPayOrder
{
     UIViewController* vcTop = [HMViewControllerManager topMostController];
    if (![WXApi isWXAppInstalled])
    {
        [vcTop showAlertMessage:@"未检测到微信客户端，调用失败"];
        return;
    }
    
    //判断当前微信的版本是否支持OpenApi
    if (![WXApi isWXAppSupportApi])
    {
        [vcTop showAlertMessage:@"当前版本不支持微信支付"];
        return;
    }
    
    NSString* payUrl = self.payParam;
    if (!payUrl || ![payUrl isKindOfClass:[NSString class]])
    {
        return;
    }
    
    NSDictionary *dicParam = [NSDictionary dictionaryWithJsonString:payUrl];
    NSDictionary *dicPayReq = [dicParam valueForKey:@"payReq"];
    
    //调起微信支付
    PayReq *req = [[PayReq alloc]init];
    req.openID = dicPayReq[@"appid"];
    req.partnerId = dicPayReq[@"partnerid"];
    req.prepayId = dicPayReq[@"prepayid"];
    req.package = dicPayReq[@"package"];
    req.nonceStr = dicPayReq[@"noncestr"];
    req.timeStamp = [dicPayReq[@"timestamp"] intValue];
    req.sign = dicPayReq[@"sign"];
    
    BOOL result = [WXApi sendReq:req];
    NSLog(@"%d",result);

}

- (void) doPayOrderSuccess
{
    [super doPayOrderSuccess];
    [self payOrderFinish];
}

- (void) doPayOrderFailed
{
    [super doPayOrderFailed];
    [self payOrderFinish];
}
@end
