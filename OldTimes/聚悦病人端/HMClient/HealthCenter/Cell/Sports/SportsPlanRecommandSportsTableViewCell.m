//
//  SportsPlanRecommandSportsTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/6/15.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SportsPlanRecommandSportsTableViewCell.h"

@interface SportsPlanRecommandSportsTableViewCell ()
{
    UIView* topview;
    NSMutableArray* sportsLables;
}
@end

@implementation SportsPlanRecommandSportsTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        topview = [[UIView alloc]init];
        [self.contentView addSubview:topview];
        [topview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.height.mas_equalTo(@7);
        }];
        
        sportsLables = [NSMutableArray array];
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

- (void) setSportType:(NSArray*) sportTypes
{
    for (UIView* sub in sportsLables)
    {
        [sub removeFromSuperview];
    }
    [sportsLables removeAllObjects];
    if (!sportTypes)
    {
        return;
    }
    
    MASViewAttribute* topattr = topview.mas_bottom;
    MASViewAttribute* leftAttr = self.contentView.mas_left;
    
    for (NSInteger index = 0; index < sportTypes.count; ++index)
    {
        RecommandSportsType* sportsType = sportTypes[index];
        UILabel* lbSports = [[UILabel alloc]init];
        [lbSports setFont:[UIFont font_24]];
        [lbSports setTextColor:[UIColor commonTextColor]];
        [lbSports setTextAlignment:NSTextAlignmentCenter];
        [lbSports setText:sportsType.sportsName];
        [self.contentView addSubview:lbSports];
        [sportsLables addObject:lbSports];
        
        [lbSports mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftAttr);
            make.top.equalTo(topattr);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth/4, 26));
        }];
        
        if (3 == index % 4)
        {
            leftAttr = self.contentView.mas_left;
            topattr = lbSports.mas_bottom;
        }
        else
        {
            leftAttr = lbSports.mas_right;
        }
    }
}
@end

@interface SportsPlanReaderTableViewCell ()
{
    UILabel* lbTitle;
}

@end

@implementation SportsPlanReaderTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbTitle];
        [lbTitle setTextColor:[UIColor commonTextColor]];
        [lbTitle setFont:[UIFont font_30]];
        
        [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(20);
            make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void) setTitle:(NSString *)title
{
    [lbTitle setText:title];
}

@end