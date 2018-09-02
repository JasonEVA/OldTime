//
//  HMPatientGroupForwardViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2017/1/13.
//  Copyright © 2017年 yinquan. All rights reserved.
//  病患聊天转发VC

#import "HMBaseViewController.h"

@class MessageBaseModel;
@interface HMPatientGroupForwardViewController : HMBaseViewController
- (instancetype)initWithMessages:(NSArray<MessageBaseModel *> *)messages;
@end
