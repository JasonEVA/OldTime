//
//  MissionNavCollectionViewCell.m
//  launcher
//
//  Created by Kyle He on 15/8/27.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MissionNavCollectionViewCell.h"
#import "Masonry.h"
#import "UIColor+Hex.h"

@implementation MissionNavCollectionViewCell

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLbl];
        [self createFrame];
    }
    return self;
}

#pragma mark - createFrame
- (void)createFrame
{
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - setter and getter

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    _titleLbl.textColor = selected ? [UIColor themeBlue]:[UIColor mtc_colorWithHex:0x959595];
}

- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.textColor = [UIColor mtc_colorWithHex:0x959595];
    }
    return _titleLbl;
}


@end
