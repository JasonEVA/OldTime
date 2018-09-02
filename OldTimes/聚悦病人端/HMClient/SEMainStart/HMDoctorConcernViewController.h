//
//  HMDoctorConcernViewController.h
//  HMClient
//
//  Created by jasonwang on 2017/6/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//  新版首页展示医生关怀vc

#import "HMBaseViewController.h"

typedef void(^CareShowMore)(NSInteger tag);

@interface HMDoctorConcernViewController : HMBaseViewController
- (instancetype)initWithArray:(NSArray *)array;
- (void)doctorCareShowMore:(CareShowMore)block;
@end
