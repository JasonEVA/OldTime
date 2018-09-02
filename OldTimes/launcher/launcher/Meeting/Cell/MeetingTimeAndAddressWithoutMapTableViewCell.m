//
//  MeetingTimeAndAddressWithoutMapTableViewCell.m
//  launcher
//
//  Created by Conan Ma on 15/8/11.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingTimeAndAddressWithoutMapTableViewCell.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "Category.h"

@implementation MeetingTimeAndAddressWithoutMapTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self creatFrames];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)creatFrames
{
    [self.contentView addSubview:self.lblTitle];
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(13);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [self.contentView addSubview:self.lblTime];
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblTitle.mas_right).offset(10);
        make.top.equalTo(self.lblTitle);
        make.right.lessThanOrEqualTo(self.contentView).offset(-8);
    }];
    
    [self.contentView addSubview:self.lblAddress];
    [self.lblAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblTime);
        make.bottom.equalTo(self.contentView).offset( -15);
    }];
}

#pragma mark - init
- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [_lblTitle setTextColor:[UIColor blackColor]];
        _lblTitle.font = [UIFont mtc_font_30];
    }
    return _lblTitle;
}

- (UILabel *)lblTime
{
    if (!_lblTime)
    {
        _lblTime = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblTime.font = [UIFont mtc_font_30];
        _lblTime.textColor = [UIColor minorFontColor];
    }
    return _lblTime;
}

- (UILabel *)lblAddress
{
    if (!_lblAddress)
    {
        _lblAddress = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblAddress.font = [UIFont mtc_font_30];
        _lblAddress.textColor = [UIColor minorFontColor];
    }
    return _lblAddress;
}
@end
