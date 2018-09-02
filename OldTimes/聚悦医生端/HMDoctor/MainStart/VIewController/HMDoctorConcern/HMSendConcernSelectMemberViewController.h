//
//  HMSendConcernSelectMemberViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2016/12/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//  群发医生关怀选人vc

#import "HMBaseViewController.h"
@class NewPatientListInfoModel;

typedef void(^ConcernSelectBlock)(NSArray<NewPatientListInfoModel *> *selectedPatients);

@interface HMSendConcernSelectMemberViewController : HMBaseViewController
//根据titel和已选人初始化
- (instancetype)initWithTitel:(NSString *)titel selectedMember:(NSMutableArray<NewPatientListInfoModel *> *)selectMember;
//获取已选人回调
- (void)acquireSelcetMember:(ConcernSelectBlock)block;

@end
