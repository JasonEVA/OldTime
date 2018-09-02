//
//  HMRecentMedicalTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 2017/3/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMRecentMedicalTableViewCell.h"
#import "HMRecentMedicalModel.h"

@interface HMRecentMedicalTableViewCell ()

@property (nonatomic, strong) UILabel *brandLabel;
@property (nonatomic, strong) UILabel *specsLabel;
@property (nonatomic, strong) UILabel *useLabel;
@property (nonatomic, strong) UIView *SeparatorView;

@end

@implementation HMRecentMedicalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.brandLabel];
        [self.contentView addSubview:self.specsLabel];
        [self.contentView addSubview:self.useLabel];
        [self.contentView addSubview:self.SeparatorView];
        
        [self configElements];
    }
    return self;
}

- (void)configElements{
    
    [_brandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(12);
    }];
    
    [_specsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_brandLabel.mas_left);
        make.top.equalTo(_brandLabel.mas_bottom).offset(8);
    }];
    
    [_useLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_brandLabel.mas_left);
        make.top.equalTo(_specsLabel.mas_bottom).offset(8);
    }];
    
    [_SeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.height.mas_equalTo(@1);
    }];
}

- (void)setRecentMedicalInfo:(HMRecentMedicalModel *)model
{
    if (!model) {
        return;
    }
    [_brandLabel setText:[NSString stringWithFormat:@"%@（%@）",model.DRUG_NAME,model.DRUG_ORG]];
    if (!model.DRUG_ORG) {
        [_brandLabel setText:model.DRUG_NAME];
    }
    [_specsLabel setText:[NSString stringWithFormat:@"用法：%@",model.DRUG_SPECIFICATIONS]];
    [_useLabel setText:[NSString stringWithFormat:@"用法：%@。一次%@%@，%@",model.DRUGS_USAGE_NAME,model.DRUG_DOSAGE,model.DRUG_DOSAGE_TITLE,model.DRUGS_FREQUENCY_NAME]];
}

//基本信息-近期用药
- (void)setBaseInfoRecentMedical:(HMThirdEditionPatitentInfoModel *)model{
    
    if (kArrayIsEmpty(model.recentDugs)) {
        return;
    }
    
    if ([model.recentDugs isKindOfClass:[NSArray class]])
    {
        NSArray *array = [HMRecentMedicalModel mj_objectArrayWithKeyValuesArray:model.recentDugs];
    }

}

#pragma mark - init UI
- (UILabel *)brandLabel {
    if (!_brandLabel) {
        _brandLabel = [UILabel new];
        [_brandLabel setFont:[UIFont font_28]];
        [_brandLabel setTextColor:[UIColor commonGrayTextColor]];
        [_brandLabel setText:@"谷维素片"];
    }
    return _brandLabel;
}

- (UILabel *)specsLabel {
    if (!_specsLabel) {
        _specsLabel = [UILabel new];
        [_specsLabel setFont:[UIFont font_28]];
        [_specsLabel setTextColor:[UIColor commonGrayTextColor]];
        [_specsLabel setNumberOfLines:0];
        [_specsLabel setText:@"规格："];
    }
    return _specsLabel;
}

- (UILabel *)useLabel {
    if (!_useLabel) {
        _useLabel = [UILabel new];
        [_useLabel setFont:[UIFont font_28]];
        [_useLabel setTextColor:[UIColor commonGrayTextColor]];
        [_useLabel setNumberOfLines:0];
        [_useLabel setText:@"用法："];
    }
    return _useLabel;
}

- (UIView *)SeparatorView{
    if (!_SeparatorView) {
        _SeparatorView = [UIView new];
        [_SeparatorView setBackgroundColor:[UIColor commonCuttingLineColor]];
    }
    return _SeparatorView;
}

@end
