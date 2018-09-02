//
//  NutriationPlanTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/6/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NutriationPlanTableViewCell.h"


@implementation NuritionInfo (PlanTableCellHeight)

- (CGFloat) cellHeight
{
    CGFloat cellHegiht = 30;
    
    if (self.suggest && 0 < self.suggest.length) {
        CGFloat txtHeihgt = [self.target heightSystemFont:[UIFont font_28] width:(kScreenWidth - 25)];
        cellHegiht += txtHeihgt;
    }
    return cellHegiht;
}

@end

@interface NutriationPlanTableViewCell ()
{
    UILabel* lbSuggest;
}
@end

@implementation NutriationPlanTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbSuggest = [[UILabel alloc]init];
        [self.contentView addSubview:lbSuggest];
        [lbSuggest setTextColor:[UIColor commonTextColor]];
        [lbSuggest setFont:[UIFont font_30]];
        
        [lbSuggest mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
            make.top.equalTo(self.contentView).with.offset(15);
        }];
    }
    return self;
}

- (void) setNuritionSuggest:(NSString*) suggest
{
    [lbSuggest setText:suggest];
}
@end


@interface NuritionPlanReaderTableViewCell ()
{
    UILabel* lbTitle;
    UILabel* lbContent;
}
@end

@implementation NuritionPlanReaderTableViewCell

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
            make.top.equalTo(self.contentView).with.offset(11);
        }];
        
        lbContent = [[UILabel alloc]init];
        [self.contentView addSubview:lbContent];
        [lbContent setTextColor:[UIColor commonGrayTextColor]];
        [lbContent setFont:[UIFont font_24]];
        
        [lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(20);
            make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
            make.top.equalTo(lbTitle.mas_bottom).with.offset(4);
        }];
    }
    return self;
}

- (void) setTitle:(NSString *)title
          Content:(NSString*) content
{
    [lbTitle setText:title];
    [lbContent setText:content];
}

@end