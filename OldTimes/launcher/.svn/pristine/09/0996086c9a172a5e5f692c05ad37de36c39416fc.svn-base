//
//  MeetingOnlyLabelTableViewCell.m
//  launcher
//
//  Created by Conan Ma on 15/8/14.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingOnlyLabelTableViewCell.h"
#import "Category.h"
#import "Masonry.h"

@implementation MeetingOnlyLabelTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.lblTitle];
        
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(13);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - init
- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblTitle.font = [UIFont systemFontOfSize:15];
        _lblTitle.textColor = [UIColor mtc_colorWithW:175];
    }
    return _lblTitle;
}

@end
