//
//  HealthPlanNutrionSelectSuggestionTableViewCell.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/25.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanNutrionSelectSuggestionTableViewCell.h"

@implementation HealthPlanNutritionSuggestionModel


@end

@interface HealthPlanNutrionSelectSuggestionTableViewCell ()

@property (nonatomic, strong) UILabel* suggestionLabel;
@property (nonatomic, strong) UIImageView* selectImageView;

@end

@implementation HealthPlanNutrionSelectSuggestionTableViewCell

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
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12.5);
        make.top.equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 13));
    }];
    
    [self.suggestionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectImageView.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.contentView).offset(-12.5);
        make.top.equalTo(self.contentView).offset(10);
        
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}

- (void) setHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel *)model
{
    [self.suggestionLabel setText:model.suggest];
    
}

- (void) setIsSelected:(BOOL) isSelected
{
    [self.selectImageView setHidden:!isSelected];
}

#pragma mark - settingAndGetting
- (UIImageView*) selectImageView
{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_select_blue"]];
        [self.contentView addSubview:_selectImageView];
    }
    return _selectImageView;
}

- (UILabel*) suggestionLabel
{
    if (!_suggestionLabel) {
        _suggestionLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_suggestionLabel];
        [_suggestionLabel setTextColor:[UIColor commonTextColor]];
        [_suggestionLabel setFont:[UIFont systemFontOfSize:15]];
        
        [_suggestionLabel setNumberOfLines:0];
    }
    return _suggestionLabel;
}


@end
