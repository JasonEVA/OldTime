//
//  HealthReportListTableViewCell.h
//  HMDoctor
//
//  Created by yinqaun on 16/8/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthReportInfo.h"

@interface HealthReportListTableViewCell : UITableViewCell
{
    
}

@property (nonatomic, readonly) UIButton* operateButton;

- (void) setHealthReport:(HealthReportInfo*) report;
@end
