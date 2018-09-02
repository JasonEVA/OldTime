//
//  HealthFillFormTemplateTableViewCell.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/24.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthFillFormTemplateTableViewCell.h"

@interface HealthFillFormTemplateTableViewCell ()

@property (nonatomic, strong) UILabel* titleLable;

@end

@implementation HealthFillFormTemplateTableViewCell

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
    [self.perviewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-12.5);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.lessThanOrEqualTo(self.perviewButton).offset(-5);
        make.left.equalTo(self).offset(12.5);
    }];
}

- (void) setHealthPlanTemplateModel:(HealthPlanFillFormTemplateModel*) model
{
    [self.titleLable setText:model.surveyMoudleName];
}

#pragma mark - settingAndGeting
- (UILabel*) titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLable];
        
        [_titleLable setFont:[UIFont systemFontOfSize:15]];
        [_titleLable setTextColor:[UIColor commonTextColor]];
    }
    return _titleLable;
}

- (UIButton*) perviewButton
{
    if (!_perviewButton) {
        _perviewButton = [[UIButton alloc] init];
        [self.contentView addSubview:_perviewButton];
        
        [_perviewButton setTitle:@"预览" forState:UIControlStateNormal];
        [_perviewButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [_perviewButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
    }
    return _perviewButton;
}

@end
