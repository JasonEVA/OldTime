//
//  ApplyTotalDetail_CenterLbelTableViewCell.m
//  launcher
//
//  Created by Kyle He on 15/8/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyTotalDetail_CenterLbelTableViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"

@interface ApplyTotalDetail_CenterLbelTableViewCell ()

/**
 *  姓名
 */
@property(nonatomic, strong) UILabel  *nameLbl;

@end

@implementation ApplyTotalDetail_CenterLbelTableViewCell

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.textLabel.textColor = [UIColor minorFontColor];
        self.textLabel.font = [UIFont systemFontOfSize:15.0f];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self createFrame];
    }
    return self;
}

#pragma mark - setMetod
- (void)setItemName:(NSString *)itemName
{
    self.textLabel.text = itemName;
}

- (void)setDetailText:(NSString *)detailText
{
    self.nameLbl.text = detailText;
}

#pragma mark - createFrame
- (void)createFrame
{
    [self.contentView addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.equalTo(self.contentView).offset(80);
        make.centerY.equalTo(self.contentView);
    }];
}

#pragma mark - initilizer
- (UILabel *)nameLbl
{
    if (!_nameLbl)
    {
        _nameLbl = [[UILabel alloc]init];
        _nameLbl.font = [UIFont mtc_font_30];
    }
    return _nameLbl;
}

@end
