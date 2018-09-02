//
//  NuritionDietRecordTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/6/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NuritionDietRecordTableViewCell.h"

@interface NuritionDietRecordTableViewCell ()
{
    UIImageView* ivFoot;
    UILabel* lbFootName;
    UILabel* lbFootNum;
    UILabel* lbCalorie;
}
@end

@implementation NuritionDietRecordTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ivFoot = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_default"]];
        [self.contentView addSubview:ivFoot];
        [ivFoot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.centerY.equalTo(self.contentView);
        }];
        
        lbFootName = [[UILabel alloc]init];
        [self.contentView addSubview:lbFootName];
        [lbFootName setFont:[UIFont font_30]];
        [lbFootName setTextColor:[UIColor commonTextColor]];
        
        [lbFootName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ivFoot.mas_right).with.offset(8);
            make.top.equalTo(ivFoot);
        }];
        
        lbFootNum = [[UILabel alloc]init];
        [self.contentView addSubview:lbFootNum];
        [lbFootNum setFont:[UIFont font_26]];
        [lbFootNum setTextColor:[UIColor commonGrayTextColor]];
        
        [lbFootNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbFootName);
            make.bottom.equalTo(ivFoot);
        }];
        
        lbCalorie = [[UILabel alloc]init];
        [self.contentView addSubview:lbCalorie];
        [lbCalorie setFont:[UIFont font_30]];
        [lbCalorie setTextColor:[UIColor commonGrayTextColor]];
        
        [lbCalorie mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-12.5);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.contentView showBottomLine];
    }
    return self;
}

- (void) setNuritionDiet:(NuritionDietInfo*) diet
{
    [ivFoot setImage:[UIImage imageNamed:@"img_default"]];
    if (diet.foodPicUrls && 0 < diet.foodPicUrls.count)
    {
        NSString* foodPicUrl = [diet.foodPicUrls firstObject];
        if (foodPicUrl && [foodPicUrl isKindOfClass:[NSString class]] && 0 < foodPicUrl.length) {
            [ivFoot sd_setImageWithURL:[NSURL URLWithString:foodPicUrl] placeholderImage:[UIImage imageNamed:@"img_default"]];
        }
        
    }
    
    [lbFootName setText:diet.foodName];
    NSString* footnum = [NSString stringWithFormat:@"%ld", diet.foodNum];
    if (diet.foodUnitStr)
    {
        footnum = [footnum stringByAppendingFormat:@" %@", diet.foodUnitStr];
    }
    [lbFootNum setText: footnum];
    [lbCalorie setText:@""];
    if (diet.allKcal > 0)
    {
        [lbCalorie setText:[NSString stringWithFormat:@"%ld千卡", diet.allKcal]];
    }
    
}
@end
