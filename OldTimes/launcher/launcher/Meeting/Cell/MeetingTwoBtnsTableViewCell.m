//
//  MeetingTwoBtnsTableViewCell.m
//  launcher
//
//  Created by Conan Ma on 15/8/15.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingTwoBtnsTableViewCell.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"

@interface MeetingTwoBtnsTableViewCell()

@end

@implementation MeetingTwoBtnsTableViewCell

+(NSString*)identifier
{
    return NSStringFromClass([self class]);
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addSubview:self.btnDelete];
        [self addSubview:self.btnShare];
        
        [self CreatFrame];
    }
    return self;
}

- (void)awakeFromNib
{
    
}

#pragma mark - Privite Methods
- (void)CreatFrame
{
    [self.btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.right.equalTo(self.mas_centerX);
    }];
    
    [self.btnShare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnDelete.mas_right);
        make.top.bottom.right.equalTo(self);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (UIButton *)btnDelete
{
    if (!_btnDelete)
    {
        _btnDelete = [[UIButton alloc] init];
        [_btnDelete setImage:[UIImage imageNamed:@"calendar_big_trash"] forState:UIControlStateNormal];
        _btnDelete.tag = 11;
        _btnDelete.layer.borderColor = [UIColor grayBackground].CGColor;
        _btnDelete.layer.borderWidth = 0.5f;
    }
    return _btnDelete;
}

- (UIButton *)btnShare
{
    if (!_btnShare)
    {
        _btnShare = [[UIButton alloc] init];
        [_btnShare setImage:[UIImage imageNamed:@"Meeting_Share"] forState:UIControlStateNormal];
        _btnShare.tag = 22;
        _btnShare.layer.borderColor = [UIColor grayBackground].CGColor;
        _btnShare.layer.borderWidth = 0.5f;
    }
    return _btnShare;
}


@end
