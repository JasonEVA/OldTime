//
//  HealthPlanPendingMessionsViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HealthPlanPendingMessionsCountBlock)(NSInteger count);

@interface HealthPlanPendingMessionsViewController : UIViewController

- (id) initWithCountBlock:(HealthPlanPendingMessionsCountBlock) block;


@end
