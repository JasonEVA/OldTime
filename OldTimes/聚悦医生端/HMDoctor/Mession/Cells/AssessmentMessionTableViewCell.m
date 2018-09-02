//
//  AssessmentMessionTableViewCell.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/29.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AssessmentMessionTableViewCell.h"

@interface AssessmentMessionTableViewCell ()
{
    UIView* assessmentView;
    UILabel* userInfoLable; //用户信息
    UILabel* dateLable;     //评估计划发送时间
    UILabel* templateTypeLable; //评估类型
    UILabel* templateNameLable; //评估项目
    
    UIView* statusView;
    UILabel* statusLabel;
}


@end

@implementation AssessmentMessionTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
        assessmentView = [[UIView alloc]init];
        [self.contentView addSubview:assessmentView];
        [assessmentView setBackgroundColor:[UIColor whiteColor]];
        [assessmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.right.equalTo(self.contentView).with.offset(-12.5);
            make.top.equalTo(self.contentView).with.offset(10);
            make.bottom.equalTo(self.contentView);
        }];
        
        assessmentView.layer.borderWidth = 0.5;
        assessmentView.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        assessmentView.layer.cornerRadius = 5;
        assessmentView.layer.masksToBounds = YES;

        //用户基本信息
        userInfoLable = [[UILabel alloc]init];
        [assessmentView addSubview:userInfoLable];
        [userInfoLable setBackgroundColor:[UIColor clearColor]];
        [userInfoLable setTextColor:[UIColor commonTextColor]];
        [userInfoLable setFont:[UIFont systemFontOfSize:15]];
        [userInfoLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(assessmentView).with.offset(7.5);
            make.right.lessThanOrEqualTo(assessmentView).with.offset(-77);
            make.top.equalTo(assessmentView).with.offset(12);
        }];
        
        dateLable = [[UILabel alloc]init];
        [assessmentView addSubview:dateLable];
        [dateLable setBackgroundColor:[UIColor clearColor]];
        [dateLable setTextColor:[UIColor commonGrayTextColor]];
        [dateLable setFont:[UIFont font_26]];
        [dateLable mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(assessmentView).with.offset(7.5);
            make.right.equalTo(assessmentView).with.offset(-10);
            make.top.equalTo(assessmentView).with.offset(14);
        }];

        
        //评估类型
        UILabel* templateTypeTitleLable = [[UILabel alloc]init];
        [assessmentView addSubview:templateTypeTitleLable];
        [templateTypeTitleLable setBackgroundColor:[UIColor clearColor]];
        [templateTypeTitleLable setTextColor:[UIColor commonGrayTextColor]];
        [templateTypeTitleLable setFont:[UIFont systemFontOfSize:13]];
        [templateTypeTitleLable setText:@"评估类型: "];
        [templateTypeTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userInfoLable);
            make.top.equalTo(userInfoLable.mas_bottom).with.offset(8);
        }];
        
        templateTypeLable = [[UILabel alloc]init];
        [assessmentView addSubview:templateTypeLable];
        [templateTypeLable setBackgroundColor:[UIColor clearColor]];
        [templateTypeLable setTextColor:[UIColor commonGrayTextColor]];
        [templateTypeLable setFont:[UIFont systemFontOfSize:13]];
        [templateTypeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(templateTypeTitleLable);
            make.left.equalTo(templateTypeTitleLable.mas_right);
            make.right.lessThanOrEqualTo(assessmentView).with.offset(-7.5);
        }];
        
        //评估项目
        UILabel* templateNameTitleLable = [[UILabel alloc]init];
        [assessmentView addSubview:templateNameTitleLable];
        [templateNameTitleLable setBackgroundColor:[UIColor clearColor]];
        [templateNameTitleLable setTextColor:[UIColor commonGrayTextColor]];
        [templateNameTitleLable setFont:[UIFont systemFontOfSize:13]];
        [templateNameTitleLable setText:@"评估项目: "];
        [templateNameTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userInfoLable);
            make.top.equalTo(templateTypeTitleLable.mas_bottom).with.offset(8);
        }];
        
        templateNameLable = [[UILabel alloc]init];
        [assessmentView addSubview:templateNameLable];
        [templateNameLable setBackgroundColor:[UIColor clearColor]];
        [templateNameLable setTextColor:[UIColor commonGrayTextColor]];
        [templateNameLable setFont:[UIFont systemFontOfSize:13]];
        [templateNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(templateNameTitleLable);
            make.left.equalTo(templateNameTitleLable.mas_right);
            make.right.lessThanOrEqualTo(assessmentView).with.offset(-7.5);
        }];
        
        
        statusView = [[UIView alloc]init];
        [assessmentView addSubview:statusView];
        [statusView setBackgroundColor:[UIColor whiteColor]];
        [statusView showTopLine];
        
        [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(assessmentView);
            make.bottom.equalTo(assessmentView);
            make.height.mas_equalTo(39);
        }];
        
        statusLabel = [[UILabel alloc]init];
        [assessmentView addSubview:statusLabel];
        [statusLabel setBackgroundColor:[UIColor clearColor]];
        [statusLabel setTextColor:[UIColor commonGrayTextColor]];
        [statusLabel setFont:[UIFont systemFontOfSize:13]];
        [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(statusView);
            make.left.equalTo(statusView).with.offset(7.5);
        }];
        
        _summaryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [statusView addSubview:_summaryButton];
        [_summaryButton setBackgroundImage:[UIImage rectImage:CGSizeMake(60, 30) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_summaryButton setTitle:@"总结" forState:UIControlStateNormal];
        [_summaryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_summaryButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        _summaryButton.layer.cornerRadius = 2.5;
        _summaryButton.layer.masksToBounds = YES;
        
        [_summaryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(statusView);
            make.right.equalTo(statusView).with.offset(-9);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        [_summaryButton setHidden:YES];
    }
    return self;
}

- (void) setAssessmentMession:(AssessmentMessionModel*) messionModel
{
    [userInfoLable setText:@""];
    [templateTypeLable setText:@""];
    [templateNameLable setText:@""];
    [statusLabel setText:@""];
    
    if (!messionModel)
    {
        return;
    }
    
    NSString* userInfoString = [NSString stringWithFormat:@"%@ (%@|%ld|%@)", messionModel.userName, messionModel.sex, messionModel.age, messionModel.userIll];
    [userInfoLable setText:userInfoString];
    [dateLable setText:messionModel.planDate];
    [templateTypeLable setText:messionModel.templateTypeName];
    [templateNameLable setText:messionModel.surveyMoudleName];
    
    [statusLabel setText:messionModel.statusName];
    [_summaryButton setHidden:YES];
    if (1 == messionModel.status)
    {
        //已填写
        BOOL editPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeAssessmentMode Status:messionModel.status OperateCode:kPrivilegeEditOperate];
        [_summaryButton setHidden:!editPrivilege];
    }
}

@end
