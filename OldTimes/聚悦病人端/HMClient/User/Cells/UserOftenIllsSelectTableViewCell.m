//
//  UserOftenIllsSelectTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/7/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserOftenIllsSelectTableViewCell.h"

@interface UserOftenIllsSelectTableViewCell ()
{
    UILabel* lbIllName;
    UIImageView* ivCheck;
}


@end

@implementation UserOftenIllsSelectTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbIllName = [[UILabel alloc]init];
        [self.contentView addSubview:lbIllName];
        [lbIllName setFont:[UIFont font_30]];
        [lbIllName setTextColor:[UIColor commonTextColor]];
        
        [lbIllName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.centerY.equalTo(self.contentView);
        }];
        
        ivCheck = [[UIImageView alloc]init];
        [self.contentView addSubview:ivCheck];
        
        [ivCheck mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).with.offset(-12.5);
        }];
    }
    return self;
}

- (void) setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (!isSelected)
    {
        [ivCheck setImage:[UIImage imageNamed:@"select_m"]];
    }
    else
    {
        [ivCheck setImage:[UIImage imageNamed:@"select_s"]];
    }
}

- (void) setOftenIll:(UserOftenIllInfo*) ill
{
    [lbIllName setText:ill.illName];
    [self setIsSelected:NO];
}

@end
