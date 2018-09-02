//
//  HMSuperviseInfoView.h
//  HMClient
//
//  Created by jasonwang on 2017/7/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//  监测图表 信息弹出view

#import <UIKit/UIKit.h>
#import "HMSuperviseEnum.h"

@class HMSuperviseDetailModel;

@interface HMSuperviseInfoView : UIView
- (void)showInfoViewWithArrowXCenter:(CGFloat)XCenter Model:(HMSuperviseDetailModel *)model superviseScreening:(SESuperviseScreening)type kpiCode:(NSString *)kpiCode;
@end
