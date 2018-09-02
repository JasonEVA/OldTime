//
//  EvaluationRecordView.m
//  HMClient
//
//  Created by lkl on 16/8/22.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "EvaluationRecordView.h"

@interface EvaluationRecordView()
{
    UIImageView* ivBackground;
    UILabel* lbOrgName;
    //UILabel* lbDepName;
    //UILabel* lbStaff;
    UILabel* lbEvaluationTpye;
    
    UIImageView* ivDetail;
    UIImageView* ivFlag;
}
@end

@implementation EvaluationRecordView

- (id) init
{
    self = [super init];
    if (self)
    {
        ivBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"history_record_bg"]];
        [self addSubview:ivBackground];

        lbOrgName = [[UILabel alloc]init];
        [self addSubview:lbOrgName];
        [lbOrgName setTextColor:[UIColor commonTextColor]];
        [lbOrgName setFont:[UIFont font_28]];
        
        /*lbDepName = [[UILabel alloc]init];
        [self addSubview:lbDepName];
        [lbDepName setTextColor:[UIColor commonTextColor]];
        [lbDepName setFont:[UIFont font_28]];

        lbStaff = [[UILabel alloc]init];
        [self addSubview:lbStaff];
        [lbStaff setTextColor:[UIColor commonTextColor]];
        [lbStaff setFont:[UIFont font_28]];*/
        
        lbEvaluationTpye = [[UILabel alloc]init];
        [self addSubview:lbEvaluationTpye];
        [lbEvaluationTpye setTextColor:[UIColor commonGrayTextColor]];
        [lbEvaluationTpye setFont:[UIFont font_28]];
        
        ivDetail = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"history_detail"]];
        [self addSubview:ivDetail];

        ivFlag = [[UIImageView alloc]init];
        [self addSubview:ivFlag];
    
        [lbOrgName setText:@"医院："];
        [lbEvaluationTpye setText:@"评估项目："];
        [ivFlag setImage:[UIImage imageNamed:@"biaoqian_08"]];
        
        [self subViewsLayout];
    }
    
    return self;
}

- (void)subViewsLayout
{
    [ivBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self).with.offset(-5);
    }];
    
    [lbOrgName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(22);
        make.top.equalTo(self).with.offset(14);
        make.right.equalTo(ivDetail.mas_left).with.offset(-3);
    }];
    
    /*[lbDepName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbOrgName.mas_bottom).with.offset(5);
        make.left.equalTo(self).with.offset(22);
        make.right.lessThanOrEqualTo(self).with.offset(-8);
    }];
    
    [lbStaff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbDepName.mas_bottom).with.offset(5);
        make.left.equalTo(self).with.offset(22);
        make.right.lessThanOrEqualTo(self).with.offset(-8);
    }];*/
    
    [lbEvaluationTpye mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(22);
        make.bottom.equalTo(self).with.offset(-14);
        make.right.lessThanOrEqualTo(self).with.offset(-8);
    }];
    
    [ivDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.right.equalTo(self).with.offset(-9);
        make.top.equalTo(self).with.offset(10);
    }];
    
    [ivFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(33, 31));
        make.right.equalTo(ivBackground);
        make.bottom.equalTo(ivBackground);
    }];
}

- (void)setEvaluationRecord:(EvaluationListRecord *)record
{
    [lbOrgName setText:record.orgName];
//    [lbDepName setText:[NSString stringWithFormat:@"科室：%@",record.depName]];
//    [lbStaff setText:[NSString stringWithFormat:@"医生：%@",record.staffName]];
    [lbEvaluationTpye setText:[NSString stringWithFormat:@"评估项目：%@",record.itemName]];
  
    [ivFlag setImage:[UIImage imageNamed:@"biaoqian_08"]];
    
    NSString *imageName = nil;
    //1.阶段性评估  2.单次评估  3.建档评估
    if (record.itemType)
    {
        switch (record.itemType.integerValue)
        {
            case 1:
                imageName = @"biaoqian_08";
                break;
                
            case 2:
                imageName = @"biaoqian_07";
                break;
                
            case 3:
                imageName = @"biaoqian_09";
                break;
                
            default:
                break;
        }

        [ivFlag setImage:[UIImage imageNamed:imageName]];

    }
}

@end
