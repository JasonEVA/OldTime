//
//  HMSecondEditionPatientInfoDrugTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2016/11/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//  第二版患者信息页（免费版）用药 cell

#import <UIKit/UIKit.h>

@class HMSecondEditionFreePatientInfoDrugModel;
@interface HMSecondEditionPatientInfoDrugTableViewCell : UITableViewCell
- (void)fillDataWithModel:(HMSecondEditionFreePatientInfoDrugModel *)model;
@end
