//
//  NuritionFoodListView.m
//  HMClient
//
//  Created by lkl on 2017/8/16.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NuritionFoodListView.h"

@interface NuritionFoodListView ()
{
    UIImageView* ivFood;
    UILabel* lbFoodName;
    UILabel* lbDesc;
    UIView *lineView;
}
@end

@implementation NuritionFoodListView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        ivFood = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_default"]];
        [self addSubview:ivFood];
        [ivFood mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.equalTo(self).with.offset(12.5);
            make.top.equalTo(self).with.offset(10);
        }];
        
        lbFoodName = [[UILabel alloc]init];
        [self addSubview:lbFoodName];
        [lbFoodName setFont:[UIFont font_30]];
        [lbFoodName setTextColor:[UIColor commonTextColor]];
        
        [lbFoodName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ivFood.mas_right).with.offset(8);
            make.top.equalTo(ivFood);
        }];
        
        lbDesc = [[UILabel alloc]init];
        [self addSubview:lbDesc];
        [lbDesc setFont:[UIFont font_26]];
        [lbDesc setTextColor:[UIColor commonGrayTextColor]];
        [lbDesc setNumberOfLines:2];
        
        [lbDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbFoodName);
            make.top.equalTo(lbFoodName.mas_bottom).with.offset(5);
            make.right.lessThanOrEqualTo(self).with.offset(-12.5);
        }];
        
        lineView = [[UIView alloc] init];
        [self addSubview:lineView];
        [lineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(@1);
            make.bottom.equalTo(self).offset(-1);
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

