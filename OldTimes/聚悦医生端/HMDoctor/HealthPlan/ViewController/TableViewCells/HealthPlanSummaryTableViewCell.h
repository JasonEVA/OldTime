//
//  HealthPlanSummaryTableViewCell.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthPlanDetailSectionModel (TableViewCellHeight)

- (CGFloat) cellHeight;
@end


@interface HealthPlanSummaryTableViewCell : UITableViewCell

- (void) setHealthPlanSection:(HealthPlanDetailSectionModel*) sectionModel;
@end
