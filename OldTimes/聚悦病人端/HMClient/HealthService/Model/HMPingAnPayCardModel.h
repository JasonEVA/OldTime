//
//  HMPingAnPayCardModel.h
//  HMClient
//
//  Created by jasonwang on 2016/11/22.
//  Copyright © 2016年 YinQ. All rights reserved.
//  银行卡model

#import <Foundation/Foundation.h>

@interface HMPingAnPayCardModel : NSObject
@property (nonatomic, copy) NSString *plantBankId;
@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *bankType;
@property (nonatomic, copy) NSString *accNo;
@property (nonatomic, copy) NSString *plantBankName;
@property (nonatomic, copy) NSString *telephone;

@end
