//
//  HMStepHistoryCollectionViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/8/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//  步数记录cell

#import <UIKit/UIKit.h>
#import "HMGroupPKEnum.h"

@class HMStepHistoryModel;

@interface HMStepHistoryCollectionViewCell : UICollectionViewCell
- (void)fillDataWithModel:(HMStepHistoryModel *)model groupPKScreening:(HMGroupPKScreening)groupPKScreening;
- (void)updateCellStatusIsSelect:(BOOL)isSelect;
@end
