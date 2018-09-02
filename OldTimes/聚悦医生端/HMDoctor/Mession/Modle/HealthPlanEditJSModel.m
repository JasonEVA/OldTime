//
//  HealthPlanEditJSModel.m
//  HMDoctor
//
//  Created by jasonwang on 16/8/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HealthPlanEditJSModel.h"

@implementation HealthPlanEditJSModel

- (void)goToPrescribeWithUserId:(NSString *)userId :(NSString *)healthyId {
    if ([self.delegate respondsToSelector:@selector(HealthPlanEditJSModelDelegateCallBack_withUserId:healthId:)]) {
        [self.delegate HealthPlanEditJSModelDelegateCallBack_withUserId:userId healthId:healthyId];
    }
}

@end
