//
//  HealthPlansTimeLineTableHeaderView.h
//  HMClient
//
//  Created by yinqaun on 16/6/7.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthPlansTimeLineHeaderDateView : UIControl
{
    UIView* vDate;
    UILabel* lbDate;
    
}

- (void) setDateStr:(NSString*) dateStr;
@end

@interface HealthPlansTimeLineTableHeaderView : UIView

@property (nonatomic, readonly) HealthPlansTimeLineHeaderDateView* dateView;

- (void) setDateString:(NSString*) dateStr;
- (void) setTotalPlansCount:(NSInteger) totalPlanCount;

- (void) setCompletePlansCount:(NSInteger) completePlanCount;
@end
