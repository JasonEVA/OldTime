//
//  HMStepHistoryTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/8/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMGroupPKEnum.h"

@class HMStepHistoryModel;

@interface HMStepHistoryTableViewCell : UITableViewCell
- (void)fillDataWithModel:(HMStepHistoryModel *)model cellType:(HMGroupPKTableType)type PKScreening:(HMGroupPKScreening)PKScreening;
@end
