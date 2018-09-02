//
//  HealthPlanReviewDetailViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/30.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"

@interface HealthPlanReviewDetailViewController : HMBasePageViewController

- (id) initWithDetailModel:(HealthPlanDetailSectionModel*) detailModel
                    status:(NSString*) status;

@end
