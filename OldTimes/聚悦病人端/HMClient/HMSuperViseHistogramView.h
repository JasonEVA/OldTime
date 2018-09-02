//
//  HMSuperViseHistogramView.h
//  HMClient
//
//  Created by jasonwang on 2017/6/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//  监测计划柱状图

#import <UIKit/UIKit.h>

@interface HMSuperViseHistogramView : UIView
- (void)fillDataWithArr:(NSArray *)array maxTarget:(CGFloat)maxTarget minTarget:(CGFloat)minTarget;

@end
