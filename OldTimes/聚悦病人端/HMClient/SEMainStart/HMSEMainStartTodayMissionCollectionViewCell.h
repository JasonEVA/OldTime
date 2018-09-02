//
//  HMSEMainStartTodayMissionCollectionViewCell.h
//  HMClient
//
//  Created by JasonWang on 2017/5/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//  今日任务cell

#import <UIKit/UIKit.h>
@class PlanMessionListItem;
@interface HMSEMainStartTodayMissionCollectionViewCell : UICollectionViewCell
- (void)fillDataWithModel:(PlanMessionListItem *)model;
@end
