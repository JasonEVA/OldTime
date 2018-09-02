//
//  RoundsRecordView.m
//  HMDoctor
//
//  Created by lkl on 16/9/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "RoundsRecordView.h"

@interface RoundsRecordView()
{
    UIImageView* ivBackground;
    UILabel* lbOrgName;
    UILabel* lbDepName;
//    UILabel* lbStaff;
    UILabel* lbRoundsCon;
    
    UIImageView* ivDetail;
}
@end

@implementation RoundsRecordView

- (id) init
{
    self = [super init];
    if (self)
    {
        ivBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"history_record_bg"]];
        [self addSubview:ivBackground];
        
        lbOrgName = [[UILabel alloc]init];
        [self addSubview:lbOrgName];
        [lbOrgName setTextColor:[UIColor mainThemeColor]];
        [lbOrgName setFont:[UIFont systemFontOfSize:14]];
        
        lbDepName = [[UILabel alloc]init];
         [self addSubview:lbDepName];
         [lbDepName setTextColor:[UIColor commonGrayTextColor]];
         [lbDepName setFont:[UIFont systemFontOfSize:14]];
         
//         lbStaff = [[UILabel alloc]init];
//         [self addSubview:lbStaff];
//         [lbStaff setTextColor:[UIColor commonGrayTextColor]];
//         [lbStaff setFont:[UIFont systemFontOfSize:14]];
        
        lbRoundsCon = [[UILabel alloc]init];
        [self addSubview:lbRoundsCon];
        [lbRoundsCon setTextColor:[UIColor commonGrayTextColor]];
        [lbRoundsCon setFont:[UIFont systemFontOfSize:14]];
        
        ivDetail = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right"]];
        [self addSubview:ivDetail];
        
        [lbOrgName setText:@"医院："];
        [lbDepName setText:@"科室："];
//        [lbStaff setText:@"查房医生："];
        [lbRoundsCon setText:@"查房内容："];
        
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
    
    [lbDepName mas_makeConstraints:^(MASConstraintMaker *make) {
     make.top.equalTo(lbOrgName.mas_bottom).with.offset(5);
     make.left.equalTo(self).with.offset(22);
     make.right.lessThanOrEqualTo(self).with.offset(-8);
     }];
     
//     [lbStaff mas_makeConstraints:^(MASConstraintMaker *make) {
//     make.top.equalTo(lbDepName.mas_bottom).with.offset(5);
//     make.left.equalTo(self).with.offset(22);
//     make.right.lessThanOrEqualTo(self).with.offset(-8);
//     }];
    
    [lbRoundsCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(22);
        make.top.equalTo(lbDepName.mas_bottom).with.offset(5);
        make.right.lessThanOrEqualTo(self).with.offset(-8);
    }];
    
    [ivDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.right.equalTo(self).with.offset(-9);
        make.top.equalTo(self).with.offset(10);
    }];
}

- (void)setRoundsRecord:(RoundsRecord *)record
{
    [lbOrgName setText:record.orgName];
    [lbDepName setText:[NSString stringWithFormat:@"科室：%@",record.depName]];
//    [lbStaff setText:[NSString stringWithFormat:@"查房医生：%@",record.staffName]];
    [lbRoundsCon setText:[NSString stringWithFormat:@"查房内容：%@",record.itemName]];
}

@end

