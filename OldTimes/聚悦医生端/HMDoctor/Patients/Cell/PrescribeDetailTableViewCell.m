//
//  PrescribeDetailTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 16/6/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PrescribeDetailTableViewCell.h"
#import "PrescribeDosageUnitSelectViewControl.h"
#import "PrescribeDrugsUsageSelectViewController.h"
#import "PrescribeDosageUnitSelectViewControl.h"

@interface PrescribeDetailTableViewCell ()
{

}

@end

@implementation PrescribeDetailTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _addDrugsView = [[PrescrbeDrugsView alloc] init];
        [self addSubview:_addDrugsView];
        //[addDrugsView setDrugInfo:drug];
        
        _drugselectView = [[DrugsUsagesSelectView alloc] init];
        [self addSubview:_drugselectView];

        _drugsDaysView = [[DrugsUsagesView alloc] init];
        [self addSubview:_drugsDaysView];
        [_drugsDaysView setName:@"用药天数" unit:@"天"];
        
        _drugsTotalView = [[DrugsUsagesView alloc] init];
        [self addSubview:_drugsTotalView];
        [_drugsTotalView setName:@"总量" unit:nil];
        
        _remarkTF = [UITextField new];
        [self addSubview:_remarkTF];
        [_remarkTF setPlaceholder:@"添加备注"];
        
        [self subViewsLayout];
    }
    return self;
    
}

- (void)subViewsLayout
{
    [_addDrugsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(60);
    }];
    
    [_drugselectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_addDrugsView.mas_bottom);
        make.height.mas_equalTo(95);
    }];
    [_drugsDaysView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_drugselectView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    [_drugsTotalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_drugsDaysView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    [_remarkTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12.5);
        make.right.equalTo(self).offset(-12.5);
        make.top.equalTo(_drugsTotalView.mas_bottom);
        make.height.equalTo(@50);
    }];
    
}

- (void)setPrescribeDetailDrugsInfo:(PrescribeTempInfo *)info
{
    [_addDrugsView setPrescribeDetailDrugsInfo:info];
    [_drugselectView.tfDosage setText:info.singleDosage];
    [_drugselectView.unitControl setContent:info.drugUnit];
    [_drugselectView.frequencyControl setContent:info.drugsFrequencyCode];
    [_drugselectView.usageControl setContent:info.drugsUsageName];
    
    if (!info.drugsFrequencyCode)
    {
        [_drugselectView.frequencyControl.lbContent setText:@"请选择频次"];
    }
    if (!info.drugsUsageCode)
    {
        
        [_drugselectView.usageControl.lbContent setText:@"请选择用法"];
    }
    
    [_drugsDaysView.tfUsages setText:info.medicationDays];
    [_drugsTotalView.tfUsages setText:info.allDosage];
    [_drugsTotalView setName:@"总量" unit:info.allUnit];
}



@end
