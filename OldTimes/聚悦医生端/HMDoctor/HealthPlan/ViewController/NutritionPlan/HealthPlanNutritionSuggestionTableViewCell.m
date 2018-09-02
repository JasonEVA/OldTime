//
//  HealthPlanNutritionSuggestionTableViewCell.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/25.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanNutritionSuggestionTableViewCell.h"

@interface HealthPlanNutritionSuggestionTableViewCell ()

@property (nonatomic, strong) UILabel* suggestionLabel;
@end

@implementation HealthPlanNutritionSuggestionTableViewCell

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
    [self.suggestionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12.5);
        make.right.lessThanOrEqualTo(self.contentView).offset(-12.5);
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}

- (void) setSuggestion:(NSString*) suggestion
{
//    [self.suggestionLabel setText:suggestion];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:suggestion];
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    
    //行间距
    [paragraphStyle setLineSpacing:5.0];
    //段落间距
    [paragraphStyle setParagraphSpacing:10.0];
    
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [suggestion length])];
    [self.suggestionLabel setAttributedText:attributedString];
}

#pragma mark - settingAndGetting
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
