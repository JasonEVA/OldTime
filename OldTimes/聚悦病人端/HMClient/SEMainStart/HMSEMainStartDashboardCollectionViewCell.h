//
//  HMSEMainStartDashboardCollectionViewCell.h
//  HMClient
//
//  Created by JasonWang on 2017/5/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//  第二版仪表盘

#import <UIKit/UIKit.h>
@class MainStartHealthTargetModel;
@interface HMSEMainStartDashboardCollectionViewCell : UICollectionViewCell
- (void)configTargetData:(MainStartHealthTargetModel *)targetData;
@end
