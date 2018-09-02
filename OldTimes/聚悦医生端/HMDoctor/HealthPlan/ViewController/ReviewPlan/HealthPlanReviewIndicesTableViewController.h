//
//  HealthPlanReviewIndicesTableViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/30.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HealthPlanReviewIndicesHandle)(HealthPlanReviewIndicesModel* model);

@interface HealthPlanReviewIndicesTableViewController : UITableViewController

- (id) initWithHandle:(HealthPlanReviewIndicesHandle) handle;
@end
