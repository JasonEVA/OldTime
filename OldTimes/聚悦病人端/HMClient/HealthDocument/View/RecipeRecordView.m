//
//  RecipeRecordView.m
//  HMClient
//
//  Created by yinqaun on 16/6/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "RecipeRecordView.h"

@interface RecipeRecordView ()
{
    UIImageView* ivBackground;
    UILabel* lbOrgName;
    UILabel* lbStaffTeam;
    UILabel* lbStaff;
    
    UIImageView* ivDetail;
    UIImageView* ivFlag;
}
@end

@implementation RecipeRecordView

- (id) init
{
    self = [super init];
    if (self)
    {
        ivBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"history_record_bg"]];
        [self addSubview:ivBackground];
        
        [ivBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self).with.offset(-5);
        }];
        
        
        lbOrgName = [[UILabel alloc]init];
        [self addSubview:lbOrgName];
        [lbOrgName setTextColor:[UIColor commonTextColor]];
        [lbOrgName setFont:[UIFont font_28]];
        
        [lbOrgName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(22);
            make.top.equalTo(self).with.offset(14);
            make.right.equalTo(ivBackground.mas_right).with.offset(-10);
        }];
        /*
        lbStaffTeam = [[UILabel alloc]init];
        [self addSubview:lbStaffTeam];
        [lbStaffTeam setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbStaffTeam setFont:[UIFont font_26]];
        
        
        [lbStaffTeam mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(22);
            make.bottom.equalTo(ivBackground).with.offset(-12);
            make.right.lessThanOrEqualTo(self).with.offset(-8);
        }];
        */
        lbStaff = [[UILabel alloc]init];
        [self addSubview:lbStaff];
        [lbStaff setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbStaff setFont:[UIFont font_26]];
        
        [lbStaff mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).with.offset(-11);
            make.left.equalTo(self).with.offset(22);
            make.right.lessThanOrEqualTo(self).with.offset(-8);
        }];
        
        ivDetail = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"history_detail"]];
        [self addSubview:ivDetail];
        
        [ivDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.right.equalTo(self).with.offset(-9);
            make.top.equalTo(self).with.offset(10);
        }];
        
        ivFlag = [[UIImageView alloc]init];
        [self addSubview:ivFlag];
        
        [ivFlag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(33, 31));
            make.right.equalTo(ivBackground);
            make.bottom.equalTo(ivBackground);
        }];
    }
    return self;
}

- (void) setRecipeRecord:(RecipeRecord*) record
{
    [lbOrgName setText:record.orgName];
    [lbStaff setText:record.staffDesc];
    
    [ivFlag setImage:nil];
    if (record.status)
    {
        if ([record.status isEqualToString:@"C"])
        {
            [ivFlag setImage:[UIImage imageNamed:@"img_recipe_valid"]];
        }
        if ([record.status isEqualToString:@"R"])
        {
            [ivFlag setImage:[UIImage imageNamed:@"img_recipe_expire"]];
        }
    }
}

@end
