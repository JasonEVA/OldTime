//
//  HMNewDoctorCareAlterEditionTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/6/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//  首页医生关怀弹窗宣教cell

#import <UIKit/UIKit.h>
#import "HealthEducationItem.h"

@interface HMNewDoctorCareAlterEditionTableViewCell : UITableViewCell
- (void)fillDataWithModel:(HealthEducationItem *)model;
@end
