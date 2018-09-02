//
//  HealthPlanReviewTableViewCell.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/30.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanReviewTableViewCell.h"

@interface HealthPlanReviewTableViewCell ()

@property (nonatomic, strong) UILabel* reviewNameLabel;
@property (nonatomic, strong) UILabel* reviewPeriodLabel;
@property (nonatomic, strong) UIImageView* arrowImageView;

@end

@implementation HealthPlanReviewTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutElements];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutElements
{
    [self.reviewNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12.5);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-12.5);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
    
    [self.reviewPeriodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.arrowImageView.mas_left).offset(-7.5);
    }];

}

- (void) setHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel*) model
{
    [self.reviewNameLabel setText:model.indicesName];
    [self.reviewPeriodLabel setText:model.periodString];
}

#pragma mark - settingAndGetting
- (UILabel*) reviewNameLabel
{
    if (!_reviewNameLabel) {
        _reviewNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_reviewNameLabel];
        
        [_reviewNameLabel setFont:[UIFont systemFontOfSize:15]];
        [_reviewNameLabel setTextColor:[UIColor commonTextColor]];
    }
    return _reviewNameLabel;
}

- (UILabel*) reviewPeriodLabel
{
    if (!_reviewPeriodLabel) {
        _reviewPeriodLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_reviewPeriodLabel];
        
        [_reviewPeriodLabel setFont:[UIFont systemFontOfSize:15]];
        [_reviewPeriodLabel setTextColor:[UIColor commonTextColor]];
    }
    return _reviewPeriodLabel;
}

- (UIImageView*) arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"c_rightArrow"]];
        [self.contentView addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

@end
