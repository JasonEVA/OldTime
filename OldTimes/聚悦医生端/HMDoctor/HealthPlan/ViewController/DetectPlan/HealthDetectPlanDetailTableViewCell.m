//
//  HealthDetectPlanDetailTableViewCell.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthDetectPlanDetailTableViewCell.h"

@interface HealthDetectPlanDetailTableViewCell ()
@property (nonatomic, strong) UILabel* nameLable;
@property (nonatomic, strong) UILabel* valueLabel;
@end

@implementation HealthDetectPlanDetailTableViewCell

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
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12.5);
    }];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-12.5);
        make.left.greaterThanOrEqualTo(self.nameLable.mas_right).offset(10);
    }];
}

- (void) setName:(NSString*) name value:(NSString*) value
{
    [self.nameLable setText:name];
    [self.valueLabel setText:value];
}

#pragma mark - settingAndGetting
- (UILabel*) nameLable
{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLable];
        [_nameLable setTextColor:[UIColor commonGrayTextColor]];
        [_nameLable setFont:[UIFont systemFontOfSize:13]];
    }
    return _nameLable;
}

- (UILabel*) valueLabel
{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_valueLabel];
        [_valueLabel setTextColor:[UIColor commonTextColor]];
        [_valueLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _valueLabel;
}

@end
