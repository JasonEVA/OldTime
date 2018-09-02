//
//  PrescrbeDrugsView.m
//  HMDoctor
//
//  Created by lkl on 16/6/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PrescrbeDrugsView.h"

@interface PrescrbeDrugsView ()
{
    UILabel *lbDrugName;
    UILabel *lbSpec;
    UILabel *lbSpecValue;
    
    UILabel *lbBrand;
    UILabel *lbProductName;
}

@end

@implementation PrescrbeDrugsView
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
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
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_deleteBtn];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor commonRedColor] forState:UIControlStateNormal];
        [_deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
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
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-12.5);
        make.top.equalTo(lbDrugName.mas_top);
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

- (void)setPrescribeDetailDrugsInfo:(PrescribeTempInfo *)info
{
    [lbDrugName setText:info.drugName];
    
    [lbSpecValue setText:info.drugSpecifications];
//    if (info.drugOneSpecUnit.length > 0 && info.drugOneSpec.length > 0)
//    {
//        [lbSpecValue setText:[NSString stringWithFormat:@"%@%@*%@", info.drugOneSpec,info.drugOneSpecUnit,info.drugSpecifications]];
//    }

    [lbProductName setText:info.drugCompany];
}


@end


@interface DrugsUsagesSelectControl ()
{

}
@end

@implementation DrugsUsagesSelectControl

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self.layer setBorderColor:[[UIColor commonCuttingLineColor] CGColor]];
        [self.layer setBorderWidth:1.0f];
        [self.layer setCornerRadius:3.0f];
        [self.layer setMasksToBounds:YES];
        
        _lbContent = [[UILabel alloc] init];
        [self addSubview:_lbContent];
        [_lbContent setTextColor:[UIColor commonGrayTextColor]];
        [_lbContent setFont:[UIFont systemFontOfSize:15]];
        [_lbContent setTextAlignment:NSTextAlignmentCenter];
        
        _ivArrow = [[UIImageView alloc] init];
        [self addSubview:_ivArrow];
        
        [_lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self);
            make.size.equalTo(self);
        }];
        
        [_ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-15);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
    }
    return self;
}

- (void)setContent:(NSString *)content
{
    [_lbContent setText:content];
}

@end

@interface DrugsUsagesSelectView ()
{

    UIView *lineView;
}
@end

@implementation DrugsUsagesSelectView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _dosageControl = [[DrugsUsagesSelectControl alloc] init];
        [self addSubview:_dosageControl];

        _tfDosage = [[UITextField alloc] init];
        [self addSubview:_tfDosage];
        [_tfDosage setFont:[UIFont systemFontOfSize:15]];
        [_tfDosage setTextAlignment:NSTextAlignmentCenter];
        //[_tfDosage setKeyboardType:UIKeyboardTypeDecimalPad];
        [_tfDosage setTextColor:[UIColor commonGrayTextColor]];
        [_tfDosage setPlaceholder:@"请输入剂量"];
        
        _unitControl = [[DrugsUsagesSelectControl alloc] init];
        [self addSubview:_unitControl];
        //[_unitControl setContent:@"mg"];
        [_unitControl.ivArrow setImage:[UIImage imageNamed:@"icon_down_list_arrow"]];
        
        _frequencyControl = [[DrugsUsagesSelectControl alloc] init];
        [self addSubview:_frequencyControl];
        [_frequencyControl setContent:@"请选择频次"];
        
        _usageControl = [[DrugsUsagesSelectControl alloc] init];
        [self addSubview:_usageControl];
        [_usageControl setContent:@"请选择用法"];
        
        lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        [self addSubview:lineView];

        [self subViwsLayout];
    }
    return self;
}

- (void)subViwsLayout
{
    [_dosageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(self).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(141*kScreenScale, 40));
    }];
    
    [_tfDosage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_dosageControl);
        make.size.equalTo(_dosageControl);
    }];
    
    [_unitControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dosageControl.mas_right).with.offset(12.5);
        make.top.equalTo(self).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(141*kScreenScale, 40));
    }];
    
    [_frequencyControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(_dosageControl.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(141*kScreenScale, 40));
    }];
    
    [_usageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_frequencyControl.mas_right).with.offset(12.5);
        make.top.equalTo(_dosageControl.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(141*kScreenScale, 40));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.mas_bottom).with.offset(-1);
    }];
}

@end


@interface DrugsUsagesView ()
{
    UILabel *lbName;
    UILabel *lbUnit;
    UIView *lineView;
}

- (void)setName:(NSString *)name unit:(NSString *)unit;

@end

@implementation DrugsUsagesView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbName = [[UILabel alloc] init];
        [self addSubview:lbName];
        [lbName setTextColor:[UIColor commonGrayTextColor]];
        [lbName setFont:[UIFont systemFontOfSize:15]];
        
        lbUnit = [[UILabel alloc] init];
        [self addSubview:lbUnit];
        [lbUnit setTextColor:[UIColor commonTextColor]];
        [lbUnit setFont:[UIFont systemFontOfSize:15]];
        [lbUnit setTextAlignment:NSTextAlignmentRight];
        
        _tfUsages = [[UITextField alloc] init];
        [self addSubview:_tfUsages];
        [_tfUsages setFont:[UIFont systemFontOfSize:15]];
        [_tfUsages setTextAlignment:NSTextAlignmentRight];
        //[_tfUsages setKeyboardType:UIKeyboardTypeDecimalPad];
        
        lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        [self addSubview:lineView];
        
        [self subViewsLayout];
    }
    return self;
}

- (void)subViewsLayout
{
    
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    [lbUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-12.5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
    
    [_tfUsages mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lbUnit.mas_left);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.mas_bottom).with.offset(-1);
    }];
}

- (void)setName:(NSString *)name unit:(NSString *)unit
{
    [lbName setText:name];
    [lbUnit setText:unit];
}


@end
