//
//  HMConcernHealthEditionView.h
//  HMDoctor
//
//  Created by jasonwang on 2017/6/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//  医生关怀中健康宣教view

#import <UIKit/UIKit.h>
@class HealthEducationItem;

@interface HMConcernHealthEditionView : UIView
- (void)fillDataWithModel:(HealthEducationItem *)model;
@end
