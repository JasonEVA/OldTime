//
//  RoundsTemplateTableViewCell.m
//  HMDoctor
//
//  Created by yinquan on 16/9/5.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "RoundsTemplateTableViewCell.h"

@interface RoundsTemplateTableViewCell ()
{
    UILabel* templateLable;
}

@end

@implementation RoundsTemplateTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        templateLable = [[UILabel alloc]init];
        [self.contentView addSubview:templateLable];
        [templateLable setFont:[UIFont font_30]];
        [templateLable setTextColor:[UIColor commonTextColor]];
        
        [templateLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
            make.centerY.equalTo(self.contentView);
        }];
        
        UIImageView* ivArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"c_rightArrow"]];
        [self.contentView addSubview:ivArrow];
        [ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).with.offset(-9);
            make.size.mas_equalTo(CGSizeMake(8, 15));
        }];
        
    }
    return self;
}

- (void) setRoundsTemplateModel:(RoundsTemplateModel*) templateModel
{
    [templateLable setText:templateModel.templateName];
}

@end

@interface RoundsTemplateCategoryTableViewCell ()
{
    UILabel* categoryLable;
}
@end

@implementation RoundsTemplateCategoryTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        categoryLable = [[UILabel alloc]init];
        [self.contentView addSubview:categoryLable];
        [categoryLable setFont:[UIFont font_30]];
        [categoryLable setTextColor:[UIColor commonTextColor]];
        
        [categoryLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.right.lessThanOrEqualTo(self.contentView).with.offset(-25);
            make.centerY.equalTo(self.contentView);
        }];
    
        UIImageView* ivArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"c_rightArrow"]];
        [self.contentView addSubview:ivArrow];
        [ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).with.offset(-9);
            make.size.mas_equalTo(CGSizeMake(8, 15));
        }];
    }
    return self;
}

- (void) setRoundsTemplateCategoryModel:(RoundsTemplateCategoryModel*) category
{
    [categoryLable setText:category.categoryName];
    
}

@end