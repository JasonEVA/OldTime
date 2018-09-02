//
//  HealthReportListTableViewCell.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HealthReportListTableViewCell.h"

@interface HealthReportListTableViewCell ()
{
    UIView* reportview;
    
    UILabel* lbUserName;
    UILabel* lbUserInfo;
    UILabel* lbSummarizeTime;
    UILabel* lbReportTime;      //报告数据时间
    UILabel* lbSummarize;       //报告内容
    
    UIView* statusView;
    UILabel* lbStatus;
}
@end

@implementation HealthReportListTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor commonBackgroundColor]];
        reportview = [[UIView alloc]init];
        [self.contentView addSubview:reportview];
        [reportview setBackgroundColor:[UIColor whiteColor]];
        [reportview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.right.equalTo(self.contentView).with.offset(-12.5);
            make.top.equalTo(self.contentView).with.offset(10);
            make.bottom.equalTo(self.contentView);
        }];
        
        reportview.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        reportview.layer.borderWidth = 0.5;
        reportview.layer.cornerRadius = 4;
        reportview.layer.masksToBounds = YES;
        
        lbUserName = [[UILabel alloc]init];
        [lbUserName setFont:[UIFont systemFontOfSize:15]];
        [reportview addSubview:lbUserName];
        [lbUserName setTextColor:[UIColor commonTextColor]];
        [lbUserName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(reportview).with.offset(8);
            make.top.equalTo(reportview).with.offset(12.5);
        }];
        
        lbUserInfo = [[UILabel alloc]init];
        [lbUserInfo setFont:[UIFont systemFontOfSize:15]];
        [reportview addSubview:lbUserInfo];
        [lbUserInfo setTextColor:[UIColor commonTextColor]];
        [lbUserInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbUserName.mas_right);
            make.top.equalTo(lbUserName);
        }];
        
        lbSummarizeTime = [[UILabel alloc]init];
        [lbSummarizeTime setFont:[UIFont systemFontOfSize:11]];
        [reportview addSubview:lbSummarizeTime];
        [lbSummarizeTime setTextColor:[UIColor commonGrayTextColor]];
        [lbSummarizeTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(reportview).with.offset(-8);
            make.bottom.equalTo(lbUserName);
        }];
        
        UILabel* lbReportTimeTitle = [[UILabel alloc]init];
        [lbReportTimeTitle setFont:[UIFont systemFontOfSize:13]];
        [reportview addSubview:lbReportTimeTitle];
        [lbReportTimeTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbReportTimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(reportview).with.offset(8);
            make.top.equalTo(lbUserName.mas_bottom).with.offset(15);
        }];
        [lbReportTimeTitle setText:@"报告数据时间: "];
        
        lbReportTime = [[UILabel alloc]init];
        [lbReportTime setFont:[UIFont systemFontOfSize:13]];
        [reportview addSubview:lbReportTime];
        [lbReportTime setTextColor:[UIColor commonGrayTextColor]];
        [lbReportTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbReportTimeTitle.mas_right);
            make.top.equalTo(lbReportTimeTitle);
            make.right.lessThanOrEqualTo(self.contentView).with.offset(-8);
        }];
        
        UILabel* lbSummarizeTitle = [[UILabel alloc]init];
        [lbSummarizeTitle setFont:[UIFont systemFontOfSize:13]];
        [reportview addSubview:lbSummarizeTitle];
        [lbSummarizeTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbSummarizeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(reportview).with.offset(8);
            make.top.equalTo(lbReportTimeTitle.mas_bottom).with.offset(10);
        }];
        [lbSummarizeTitle setText:@"报告内容: "];

        lbSummarize = [[UILabel alloc]init];
        [lbSummarize setFont:[UIFont systemFontOfSize:13]];
        [reportview addSubview:lbSummarize];
        [lbSummarize setTextColor:[UIColor commonGrayTextColor]];
        [lbSummarize mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbSummarizeTitle.mas_right);
            make.top.equalTo(lbSummarizeTitle);
            make.right.lessThanOrEqualTo(reportview).with.offset(-8);
        }];
        
        statusView = [[UIView alloc]init];
        [reportview addSubview:statusView];
        [statusView setBackgroundColor:[UIColor whiteColor]];
        [statusView showTopLine];
        [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(reportview);
            make.bottom.equalTo(reportview);
            make.height.mas_offset(@39);
        }];
        
        lbStatus = [[UILabel alloc]init];
        [statusView addSubview:lbStatus];
        [lbStatus setTextColor:[UIColor commonGrayTextColor]];
        [lbStatus setFont:[UIFont systemFontOfSize:13]];
        [lbStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(statusView).with.offset(8);
            make.center.equalTo(statusView);
        }];
        
        _operateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_operateButton setBackgroundImage:[UIImage rectImage:CGSizeMake(80, 32) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [statusView addSubview:_operateButton];
        
        [_operateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_operateButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        _operateButton.layer.cornerRadius = 2.5;
        _operateButton.layer.masksToBounds = YES;
        
        [_operateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(statusView);
            make.right.equalTo(statusView).with.offset(-9);
            make.size.mas_equalTo(CGSizeMake(85, 30));
        }];
        [_operateButton setHidden:YES];

    }
    return self;
}

- (void) setHealthReport:(HealthReportInfo*) report
{
    [lbUserName setText:@""];
    [lbUserInfo setText:@""];
    [lbSummarizeTime setText:@""];
    [lbReportTime setText:@""];
    [lbSummarize setText:@""];
    [lbStatus setText:@""];
    
    [lbUserName setText:report.userName];
    [lbUserInfo setText:[NSString stringWithFormat:@"（%@|%ld）", report.sex, report.age]];
    [lbSummarizeTime setText:report.summarizeTime];
    
    [lbReportTime setText:[NSString stringWithFormat:@"%@~%@", report.beginTime, report.endTime]];
    [lbSummarize setText:report.reportSummary];
    [lbStatus setText:report.statusView];
    [_operateButton setHidden:YES];
    switch (report.status)
    {
        case 1:
        {
            //待制定
            BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthReportMode Status:report.status OperateCode:kPrivilegeViewOperate];
            if (!viewPrivilege)
            {
                //没有查看健康报告权限
                return;
            }
            [_operateButton setHidden:NO];
            [_operateButton setTitle:@"制定报告" forState:UIControlStateNormal];
            break;
        }
        case 2:
        {
            //待确定
            BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthReportMode Status:report.status OperateCode:kPrivilegeViewOperate];
            if (!viewPrivilege)
            {
                //没有查看健康报告权限
                return;
            }
            [_operateButton setHidden:NO];
            [_operateButton setTitle:@"总结报告" forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    
}

@end
