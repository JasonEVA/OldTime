//
//  HMRecentMedicalTableViewCell.h
//  HMDoctor
//
//  Created by lkl on 2017/3/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMThirdEditionPatitentInfoModel.h"

@class HMRecentMedicalModel;

@interface HMRecentMedicalTableViewCell : UITableViewCell

- (void)setRecentMedicalInfo:(HMRecentMedicalModel *)info;

//基本信息-近期用药
- (void)setBaseInfoRecentMedical:(HMThirdEditionPatitentInfoModel *)model;

@end
