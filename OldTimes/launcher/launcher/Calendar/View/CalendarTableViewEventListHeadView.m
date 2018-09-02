//
//  CalendarTableViewEventListHeadView.m
//  launcher
//
//  Created by Conan Ma on 15/7/31.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarTableViewEventListHeadView.h"
#import <Masonry/Masonry.h>
#import "Category.h"

@implementation CalendarTableViewEventListHeadView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.contentView.backgroundColor = [UIColor mtc_colorWithHex:0xe3e7ea];
        [self.contentView addSubview:self.lblTitle];
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(30);
            make.top.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - init
- (UILabel *)lblTitle
{
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.textColor = [UIColor mtc_colorWithHex:0x56656d];
        _lblTitle.font = [UIFont mtc_font_24];
    }
    return _lblTitle;
}

@end
