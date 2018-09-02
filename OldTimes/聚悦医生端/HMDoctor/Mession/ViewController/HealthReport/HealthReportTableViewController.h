//
//  HealthReportTableViewController.h
//  HMDoctor
//
//  Created by yinqaun on 16/8/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HealthReport_UnDealed = 1,
    HealthReport_All = 2,
    
} HealthReportListType;

@interface HealthReportTableViewController : UITableViewController
{
    
}
- (id) initWithStatusList:(NSArray*) statusList;

@end
