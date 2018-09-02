//
//  HMNewConcernSendViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2016/12/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//  新建医生关怀vc

#import "HMBaseViewController.h"
@class HealthEducationItem;

typedef void(^concernSendedsuccessBlock)();
@interface HMNewConcernSendViewController : HMBaseViewController

- (instancetype)initWithIsSendToGroup:(BOOL)isSendToGroup;
- (instancetype)initWithSelectMember:(NSArray *)selectedArr text:(NSString *)text isSendToGroup:(BOOL)isSendToGroup;

- (void)sendConcernSuccess:(concernSendedsuccessBlock)block;
- (void)configHealthEdition:(HealthEducationItem *)model;
- (void)configSelectedImageArr:(NSArray *)imageArr;
@end
