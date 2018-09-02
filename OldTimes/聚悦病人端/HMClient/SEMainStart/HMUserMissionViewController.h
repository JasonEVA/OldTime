//
//  HMUserMissionViewController.h
//  HMClient
//
//  Created by JasonWang on 2017/5/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//  今日任务vc

#import "HMBasePageViewController.h"

typedef void(^isHaveHealthPlan)(BOOL isHave);

@interface HMUserMissionViewController : HMBasePageViewController
- (void)checkIsHaveHealthPlan:(isHaveHealthPlan)block;
@end
