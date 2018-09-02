//
//  NuritionFoodListTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/6/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NuritionFoodListTableViewCell.h"

@interface NuritionFoodListTableViewCell ()
{
    UIImageView* ivFood;
    UILabel* lbFoodName;
    UILabel* lbDesc;
}
@end

@implementation NuritionFoodListTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ivFood = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_default"]];
        [self.contentView addSubview:ivFood];
        [ivFood mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.top.equalTo(self.contentView).with.offset(10);
        }];

        lbFoodName = [[UILabel alloc]init];
        [self.contentView addSubview:lbFoodName];
        [lbFoodName setFont:[UIFont font_30]];
        [lbFoodName setTextColor:[UIColor commonTextColor]];
        
        [lbFoodName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ivFood.mas_right).with.offset(8);
            make.top.equalTo(ivFood);
        }];
        
        lbDesc = [[UILabel alloc]init];
        [self.contentView addSubview:lbDesc];
        [lbDesc setFont:[UIFont font_26]];
        [lbDesc setTextColor:[UIColor commonGrayTextColor]];
        [lbDesc setNumberOfLines:2];
        
        [lbDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbFoodName);
            make.top.equalTo(lbFoodName.mas_bottom).with.offset(5);
            make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
        }];
    }
    return self;
}

- (void) setFood:(FoodListItem*) food
{
    [ivFood setImage:[UIImage imageNamed:@"img_default"]];
    if (food.imgUrl && food.imgUrl.length)
    {
        [ivFood sd_setImageWithURL:[NSURL URLWithString:food.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default"]];
    }
    
    [lbFoodName setText:food.name];
    [lbDesc setText: food.foodDesc];
}

@end
