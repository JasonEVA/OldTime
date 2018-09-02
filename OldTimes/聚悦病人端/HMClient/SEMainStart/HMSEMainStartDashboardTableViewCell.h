//
//  HMSEMainStartDashboardTableViewCell.h
//  HMClient
//
//  Created by JasonWang on 2017/5/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//  第二版首页仪表盘tableviewcell

#import <UIKit/UIKit.h>
@class MainStartHealthTargetModel;

typedef void(^HMSEMainStartDashboardClickedCompletion)(MainStartHealthTargetModel *model);

@interface HMSEMainStartDashboardTableViewCell : UITableViewCell
- (void)configTargetItems:(NSArray<MainStartHealthTargetModel *> *)targetItems;
- (void)addTargetValueClickedCompletion:(HMSEMainStartDashboardClickedCompletion)completion;

@end
