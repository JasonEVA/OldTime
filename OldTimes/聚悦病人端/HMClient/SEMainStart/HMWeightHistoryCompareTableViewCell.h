//
//  HMWeightHistoryCompareTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/8/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//  比体重cell

#import <UIKit/UIKit.h>

@class HMTZMainDiagramDataModel;
@interface HMWeightHistoryCompareTableViewCell : UITableViewCell

- (void)fillDataWithModel:(HMTZMainDiagramDataModel *)model;
@end
