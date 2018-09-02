//
//  HealthFillFormDetailTableViewCell.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/23.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthFillFormDetailTableViewCell.h"

@interface HealthFillFormDetailTableViewCell ()

@property (nonatomic, strong) UILabel* nameLable;
@property (nonatomic, strong) UILabel* periodLabel;

@end

@implementation HealthFillFormDetailTableViewCell

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
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12.5);
    }];
    
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-12.5);
        make.left.greaterThanOrEqualTo(self.nameLable.mas_right).offset(10);
    }];
}

- (void) setHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel*) model
{
    [self.nameLable setText:model.surveyMoudleName];
    if (model.periodValue && ![model.periodValue isEqualToString:@"1"]) {
        [self.periodLabel setText:[NSString stringWithFormat:@"每%@%@1次", model.periodValue, model.periodTypeString]];
    }
    else
    {
        [self.periodLabel setText:[NSString stringWithFormat:@"每%@1次", model.periodTypeString]];
    }
    
}

#pragma mark - settingAndGetting
- (UILabel*) nameLable
{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLable];
        [_nameLable setTextColor:[UIColor commonTextColor]];
        [_nameLable setFont:[UIFont systemFontOfSize:15]];
    }
    return _nameLable;
}

- (UILabel*) periodLabel
{
    if (!_periodLabel) {
        _periodLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_periodLabel];
        [_periodLabel setTextColor:[UIColor commonTextColor]];
        [_periodLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _periodLabel;
}
@end
