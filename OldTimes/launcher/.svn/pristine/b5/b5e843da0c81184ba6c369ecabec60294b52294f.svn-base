//
//  ChatSingleManagerTableViewCell.m
//  launcher
//
//  Created by Lars Chen on 15/9/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ChatSingleManagerTableViewCell.h"
#import <Masonry.h>

@interface ChatSingleManagerTableViewCell()
@property (nonatomic, strong) UIImageView *imgViewArrow;
@end

@implementation ChatSingleManagerTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(14,10,40,40);
}


- (instancetype)init
{
    if (self = [super init])
    {
        [self.imageView.layer setCornerRadius:2.5];
        [self.contentView addSubview:self.lbDepartment];
        [self.textLabel setFont:[UIFont systemFontOfSize:15]];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView).offset(2);
            make.left.equalTo(self.imageView.mas_right).offset(15);
        }];
        
        [self.lbDepartment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).offset(15);
            make.bottom.equalTo(self.imageView).offset(-2);
        }];
        
        [self.contentView addSubview:self.imgViewArrow];
        [self.imgViewArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(@20);
            make.width.equalTo(@10);
        }];
    }
    
    return self;
}

- (UILabel *)lbDepartment
{
    if (!_lbDepartment)
    {
        _lbDepartment = [UILabel new];
        _lbDepartment.textColor = [UIColor grayColor];
        [_lbDepartment setFont:[UIFont systemFontOfSize:13]];
    }
    
    return _lbDepartment;
}

- (UIImageView *)imgViewArrow
{
    if (!_imgViewArrow)
    {
        _imgViewArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosureIndicator"]];
    }
    return _imgViewArrow;
}
@end
