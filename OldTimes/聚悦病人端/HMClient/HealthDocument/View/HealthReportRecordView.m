//
//  HealthReportRecordView.m
//  HMClient
//
//  Created by yinqaun on 16/6/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthReportRecordView.h"

@interface HealthReportRecordView ()
{
    UIImageView* ivBackground;
    UILabel* lbAnalysis;
    UILabel* lbReportSummary;
    
    UIImageView* ivDetail;
    UIImageView* ivFlag;
}
@end

@implementation HealthReportRecordView

- (id) init
{
    self = [super init];
    if (self)
    {
        ivBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"history_record_bg"]];
        [self addSubview:ivBackground];
        
        [ivBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self).with.offset(-5);
        }];
        
        ivDetail = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"history_detail"]];
        [self addSubview:ivDetail];
        
        [ivDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.right.equalTo(self).with.offset(-9);
            make.top.equalTo(self).with.offset(10);
        }];
        
        ivFlag = [[UIImageView alloc]init];
        [self addSubview:ivFlag];
        
        [ivFlag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(33, 31));
            make.right.equalTo(ivBackground);
            make.bottom.equalTo(ivBackground);
        }];

        lbAnalysis = [[UILabel alloc]init];
        [lbAnalysis setText:@"健康报告"];
        [self addSubview:lbAnalysis];
        [lbAnalysis setTextColor:[UIColor commonTextColor]];
        [lbAnalysis setFont:[UIFont font_28]];
        
        [lbAnalysis mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(22);
            make.top.equalTo(self).with.offset(14);
        }];
       
        lbReportSummary = [[UILabel alloc]init];
        [self addSubview:lbReportSummary];
        [lbReportSummary setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbReportSummary setFont:[UIFont font_26]];
        
        [lbReportSummary mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).with.offset(-16);
            make.left.equalTo(self).with.offset(22);
            make.right.lessThanOrEqualTo(self).with.offset(-8);
        }];

        
    }
    
    return self;
}

- (void) setHealthReport:(HealthReport*) report
{
    [lbReportSummary setText:report.reportSummary];
    [ivFlag setImage:[UIImage imageNamed:@"health_report_unread"]];
    if (4 == report.status)
    {
        [ivFlag setImage:[UIImage imageNamed:@"health_report_readed"]];
    }
}

@end
