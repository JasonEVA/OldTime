//
//  HMSEHealthPlanMissionHeadView.h
//  HMClient
//
//  Created by jasonwang on 2017/6/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//  第二版健康计划VC headview

#import <UIKit/UIKit.h>

@interface HMSEHealthPlanMissionHeadView : UIView
- (void)fillDataWithAllMissionCount:(NSInteger)allMissionCount;
- (void)fillDataWithdoneMissionCount:(NSInteger)doneMissionCount;
@end
