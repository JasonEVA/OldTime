//
//  HMPingAnPaySentVerificationCodeViewController.h
//  HMClient
//
//  Created by jasonwang on 2016/11/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//  平安支付填写验证码界面

#import "HMBaseViewController.h"
#import "HMPingAnPayOrderModel.h"
@protocol HMPingAnPaySentVerificationCodeViewControllerDelegate <NSObject>

- (void)HMPingAnPaySentVerificationCodeViewControllerDelegateCallBack_showCardList;

@end
@interface HMPingAnPaySentVerificationCodeViewController : HMBaseViewController
@property (nonatomic) CGFloat amount;                     //价格
@property (nonatomic, copy) NSString *openId;             //银行卡openId
@property (nonatomic, copy) NSString *objectName;         //服务名
@property (nonatomic, copy) NSString *pinganOrderNo;            //订单号
@property (nonatomic) NSInteger serviceId;                //请求订单详情状态用
@property (nonatomic, weak) id<HMPingAnPaySentVerificationCodeViewControllerDelegate> delegate;

@end
