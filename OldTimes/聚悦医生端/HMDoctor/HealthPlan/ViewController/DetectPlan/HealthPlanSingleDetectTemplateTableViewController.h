//
//  HealthPlanSingleDetectTemplateTableViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/9/12.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HealthPlanSingleDetectTemplateTableViewController : UITableViewController
{
    
}

- (id) initWithKpiCode:(NSString*) kpiCode
           selectBlock:(HealthPlanSingleDetectSelectBlock) selectBlock;
@end
