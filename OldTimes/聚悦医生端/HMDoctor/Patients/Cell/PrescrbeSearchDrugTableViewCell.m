//
//  PrescrbeSearchDrugTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 16/6/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PrescrbeSearchDrugTableViewCell.h"

@interface PrescrbeSearchDrugTableViewCell ()
{
    UILabel *lbDrugName;
    UILabel *lbSpec;
    UILabel *lbSpecValue;
    
    UILabel *lbBrand;
    UILabel *lbProductName;
}

@end

@implementation PrescrbeSearchDrugTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbDrugName = [[UILabel alloc] init];
        [self addSubview:lbDrugName];
        [lbDrugName setTextColor:[UIColor commonTextColor]];
        [lbDrugName setFont:[UIFont systemFontOfSize:14]];
        
        lbSpec = [[UILabel alloc] init];
        [self addSubview:lbSpec];
        [lbSpec setText:@"规格:"];
        [lbSpec setTextColor:[UIColor commonGrayTextColor]];
        [lbSpec setFont:[UIFont systemFontOfSize:14]];
        
        lbSpecValue = [[UILabel alloc] init];
        [self addSubview:lbSpecValue];
        [lbSpecValue setTextColor:[UIColor commonGrayTextColor]];
        [lbSpecValue setFont:[UIFont systemFontOfSize:14]];
        
        lbBrand = [[UILabel alloc] init];
        [self addSubview:lbBrand];
        [lbBrand setText:@"品牌:"];
        [lbBrand setTextColor:[UIColor commonGrayTextColor]];
        [lbBrand setFont:[UIFont systemFontOfSize:14]];
        
        lbProductName = [[UILabel alloc] init];
        [self addSubview:lbProductName];
        [lbProductName setTextColor:[UIColor commonGrayTextColor]];
        [lbProductName setFont:[UIFont systemFontOfSize:14]];
        
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_addBtn];
        [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [_addBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_addBtn setUserInteractionEnabled:NO];
        
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
    
    [lbSpec mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbDrugName.mas_left);
        make.top.equalTo(lbDrugName.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    [lbSpecValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbSpec.mas_right);
        make.top.equalTo(lbSpec.mas_top);
        make.size.mas_equalTo(CGSizeMake(120*kScreenScale, 20));
    }];
    
    [lbBrand mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbSpecValue.mas_right);
        make.top.equalTo(lbSpec.mas_top);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    [lbProductName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbBrand.mas_right);
        make.top.equalTo(lbSpec.mas_top);
        make.height.mas_equalTo(@20);
        make.right.lessThanOrEqualTo(self).offset(-5);
    }];
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-12.5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)setDrugInfo:(DrugInfo *)info
{
    if (info)
    {
        [lbDrugName setText:info.drugName];
        
        [lbSpecValue setText:info.drugBagSpec];
        //规格 20mg*100mg/瓶
        //[lbSpecValue setText:[NSString stringWithFormat:@"%@%@*%@%@/%@",info.drugOneSpec,info.drugOneSpecUnit,info.drugSpec,info.drugOneSpecUnit,info.drugBagUnit]];
        
        [lbProductName setText:info.drugOrg];
    }
}

@end
