//
//  PrescribeStartTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 16/6/18.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PrescribeStartTableViewCell.h"

@interface PrescribeStartTableViewCell ()
{
    UILabel *lbDrugName;
    UILabel *lbProductName;
    UILabel *lbSpec;
    UILabel *lbSpecValue;

    UILabel *lbDrugsUsage;
    UILabel *lbDrugsUsageValue;
    
    UILabel *lbDosage;
}

@end

@implementation PrescribeStartTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbDrugName = [[UILabel alloc] init];
        [self addSubview:lbDrugName];
        [lbDrugName setTextColor:[UIColor commonTextColor]];
        [lbDrugName setFont:[UIFont systemFontOfSize:14]];
        
        lbProductName = [[UILabel alloc] init];
        [self addSubview:lbProductName];
        [lbProductName setTextColor:[UIColor commonGrayTextColor]];
        [lbProductName setFont:[UIFont systemFontOfSize:14]];
        
        lbSpec = [[UILabel alloc] init];
        [self addSubview:lbSpec];
        [lbSpec setText:@"规格:"];
        [lbSpec setTextColor:[UIColor commonGrayTextColor]];
        [lbSpec setFont:[UIFont systemFontOfSize:14]];
        
        lbSpecValue = [[UILabel alloc] init];
        [self addSubview:lbSpecValue];
        [lbSpecValue setTextColor:[UIColor commonGrayTextColor]];
        [lbSpecValue setFont:[UIFont systemFontOfSize:14]];
        
 
        lbDrugsUsage = [[UILabel alloc] init];
        [self addSubview:lbDrugsUsage];
        [lbDrugsUsage setText:@"用法:"];
        [lbDrugsUsage setTextColor:[UIColor commonGrayTextColor]];
        [lbDrugsUsage setFont:[UIFont systemFontOfSize:14]];
        
        lbDrugsUsageValue = [[UILabel alloc] init];
        [self addSubview:lbDrugsUsageValue];
        [lbDrugsUsageValue setTextColor:[UIColor commonGrayTextColor]];
        [lbDrugsUsageValue setFont:[UIFont systemFontOfSize:14]];
        
        lbDosage = [[UILabel alloc] init];
        [self addSubview:lbDosage];
        [lbDosage setText:@"1瓶"];
        [lbDosage setTextColor:[UIColor commonGrayTextColor]];
        [lbDosage setFont:[UIFont systemFontOfSize:14]];
        
        [self subViewsLayout];
    }
    return self;
}

- (void)subViewsLayout
{
    [lbDrugName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(self).with.offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [lbProductName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbDrugName.mas_right);
        make.top.equalTo(lbSpec.mas_top);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [lbSpec mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbDrugName.mas_left);
        make.top.equalTo(lbDrugName.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    [lbSpecValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbSpec.mas_right);
        make.top.equalTo(lbSpec.mas_top);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
    
    [lbDrugsUsage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbDrugName.mas_left);
        make.top.equalTo(lbSpec.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    [lbDrugsUsageValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbDrugsUsage.mas_right);
        make.top.equalTo(lbDrugsUsage.mas_top);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
    
    [lbDosage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-12.5);
        make.top.equalTo(lbDrugsUsage.mas_top);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
}

- (void)setDrugInfo:(DrugInfo *)info
{
    if (info)
    {
        [lbDrugName setText:info.drugName];
        
        //规格 20mg*100mg/瓶
        [lbSpecValue setText:[NSString stringWithFormat:@"%@%@*%@%@/%@",info.drugOneSpec,info.drugOneSpecUnit,info.drugSpec,info.drugOneSpecUnit,info.drugBagUnit]];
        
        [lbProductName setText:info.drugOrg];
    }
}

@end