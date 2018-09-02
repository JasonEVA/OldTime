//
//  HealthPlanDetailPageView.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/31.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthPlanDetailPageView : UIView


- (void) setHealthPlanDetailSectionModel:(HealthPlanDetailSectionModel*) model;
- (void) setPageCount:(NSInteger) count;
- (void) setCurrentPage:(NSInteger) index;

- (void) setPage:(NSInteger) page isValid:(BOOL) valid;


@end
