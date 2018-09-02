//
//  MissionRemarkAndPatientTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 16/7/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//  任务详情病人和备注cell

#import <UIKit/UIKit.h>

@interface MissionRemarkAndPatientTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *contentLb;

+ (NSString *)identifier;

@end
