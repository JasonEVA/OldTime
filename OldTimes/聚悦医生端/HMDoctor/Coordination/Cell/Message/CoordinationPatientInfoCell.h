//
//  CoordinationPatientInfoCell.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//  病人信息cell

#import <UIKit/UIKit.h>
@class PatientModel;
@interface CoordinationPatientInfoCell : UITableViewCell

- (void)setDataWithModel:(PatientModel *)model;

@end
