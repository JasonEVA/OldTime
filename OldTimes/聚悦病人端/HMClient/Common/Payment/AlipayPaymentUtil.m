//
//  AlipayPaymentUtil.m
//  HMClient
//
//  Created by yinquan on 16/11/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AlipayPaymentUtil.h"
#import "UIViewController+Loading.h"
@implementation AlipayPaymentUtil

- (void) doPayOrder
{
    NSString* payUrl = self.payParam;
    if (!payUrl || ![payUrl isKindOfClass:[NSString class]])
    {
        return;
    }
    NSString* appscheme = @"jyhmclient";
#ifdef kPlantform_JuYue
    appscheme = @"jyhmclient";
#endif
    
#ifdef kPlantform_ChongYi
    appscheme = @"cyhmclient";
#endif
    
#ifdef kPlantform_XiNan
    appscheme = @"xnhmclient";
#endif
    UIViewController* vcTop = [HMViewControllerManager topMostController];
    
    //调用支付宝支付
    [[AlipaySDK defaultService] payOrder:payUrl fromScheme:appscheme callback:^(NSDictionary *resultDic)
     {
         NSString* resultStatusStr = [resultDic valueForKey:@"resultStatus"];
         if (!resultStatusStr)
         {
             
             return ;
         }
         
         //[orderInfo setOrderId:order.orderId];
         switch (resultStatusStr.integerValue)
         {
             case 9000:
             {
                 //支付宝支付成功
                 [self doPayOrderSuccess];
                 [self payOrderFinish];
                 return;
                 break;
             }
             case 8000:
             {
                 [vcTop at_postError:@"正在处理中。"];
                 
             }
                 break;
             case 4000:
             {
                 [vcTop at_postError:@"订单支付失败。"];
                 
             }
                 break;
             case 6001:
             {
                 [vcTop at_postError:@"用户中途取消。"];
                 
             }
                 break;
             case 6002:
             {
                 [vcTop at_postError:@"网络连接出错。"];
                 
             }
                 break;
                 
             
         }
         //支付失败
         [self doPayOrderFailed];
         [self payOrderFinish];
     }];
}



@end
