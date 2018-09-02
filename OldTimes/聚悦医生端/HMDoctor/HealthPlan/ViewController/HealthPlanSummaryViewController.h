//
//  HealthPlanSummaryViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthPlanSummaryViewController : UIViewController

@property (nonatomic, assign) BOOL formulatePlan;
@property (nonatomic, copy) NSString* groupId;
@property (nonatomic, copy) NSString* healthyPlanId;

- (id) initWithUserId:(NSInteger) userId;
@end
