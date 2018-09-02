//
//  HealthPlanMedicineRecipeRecordTableViewCell.m
//  HMDoctor
//
//  Created by yinquan on 2017/9/14.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanMedicineRecipeRecordTableViewCell.h"

@interface HealthPlanMedicineRecipeRecordTableViewCell ()

@property (nonatomic, strong) UILabel* drugNameLabel;
@property (nonatomic, strong) UILabel* periodLabel;
@end

@implementation HealthPlanMedicineRecipeRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutElements];
    }
    return self;
    
}

- (void) layoutElements
{
    [self.drugNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12.5);
        make.top.equalTo(self.contentView).offset(13);
    }];
    
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12.5);
        make.top.equalTo(self.drugNameLabel.mas_bottom).offset(7);
    }];
}

- (void) setDrugInfo:(PrescribeTempInfo*) model
{
    NSString* drugTitle = [NSString stringWithFormat:@"%@", model.drugName];
    if (model.drugSpecifications && model.drugSpecifications.length > 0) {
        drugTitle = [drugTitle stringByAppendingFormat:@"(%@)", model.drugSpecifications];
    }
    [self.drugNameLabel setText:drugTitle];
    
    NSString* periodStr = [NSString stringWithFormat:@"%@%@/次 %@", model.drugOneSpec, model.drugOneSpecUnit, model.drugsFrequencyName];
    [self.periodLabel setText:periodStr];
}

#pragma mark - settingAndGetting
- (UILabel*) drugNameLabel
{
    if (!_drugNameLabel) {
        _drugNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_drugNameLabel];
        [_drugNameLabel setTextColor:[UIColor commonTextColor]];
        [_drugNameLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _drugNameLabel;
}

- (UILabel*) periodLabel
{
    if (!_periodLabel) {
        _periodLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_periodLabel];
        [_periodLabel setTextColor:[UIColor commonGrayTextColor]];
        [_periodLabel setFont:[UIFont systemFontOfSize:13]];
    }
    return _periodLabel;
}

@end
