//
//  HMThirdEditionPatitentInfoReportTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2017/1/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//  第三版患者基本信息诊断评估公用cell

#import <UIKit/UIKit.h>

@class HMThirdEditionPatitentInfoModel;
@interface HMThirdEditionPatitentInfoReportTableViewCell : UITableViewCell

//健康风险评估设置数据方法
- (void)fillHealthRiskDataWithModel:(HMThirdEditionPatitentInfoModel *)model;

//诊断设置数据方法
- (void)fillDiagnoseDataWithModel:(HMThirdEditionPatitentInfoModel *)model;

//是否可以查看筛查表
@property (nonatomic, strong)void(^isScreeningResultPageBlock)();
@end
