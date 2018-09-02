//
//  NutritionDietEstimateLeftTableViewCell.m
//  HMClient
//
//  Created by lkl on 2017/8/18.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NutritionDietEstimateLeftTableViewCell.h"

@interface NutritionDietEstimateLeftTableViewCell ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation NutritionDietEstimateLeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.name = [[UILabel alloc] init];
        self.name.numberOfLines = 0;
        self.name.font = [UIFont font_30];
        self.name.textColor = [UIColor commonGrayTextColor];
        self.name.highlightedTextColor = [UIColor mainThemeColor];
        [self.contentView addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = [UIColor mainThemeColor];
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(@3);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor colorWithWhite:0 alpha:0.05];
    self.highlighted = selected;
    self.name.highlighted = selected;
    self.lineView.hidden = !selected;
}

@end
