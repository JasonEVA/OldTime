//
//  HMMainReviewAlterView.h
//  HMClient
//
//  Created by jasonwang on 2017/5/18.
//  Copyright © 2017年 YinQ. All rights reserved.
//  复查提醒alterview

#import <UIKit/UIKit.h>
#import "HMSEMainStartEnum.h"

@class PlanMessionListItem;

typedef void(^MSReviewAlterBlock)(HMMainStartAlterBtnType clickType);
@interface HMMainReviewAlterView : UIView
@property (nonatomic, strong) PlanMessionListItem *tempModel;
- (void)fillDataWith:(PlanMessionListItem *)model;
- (void)btnClickBlock:(MSReviewAlterBlock)block;

@end
