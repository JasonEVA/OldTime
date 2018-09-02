//
//  ApplyDetailTableViewCell.m
//  launcher
//
//  Created by Kyle He on 15/8/15.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyDetailTableViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"

@implementation ApplyDetailTableViewCell

+ (NSString *)identifier { return NSStringFromClass(self);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.applyDetailLbl];
        [self.applyDetailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
			make.left.greaterThanOrEqualTo(self.contentView).offset(80);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - Initializer
- (UILabel *)applyDetailLbl {
    if (!_applyDetailLbl) {
        _applyDetailLbl = [[UILabel alloc] init];
        _applyDetailLbl.font = [UIFont mtc_font_30];
        _applyDetailLbl.textColor = [UIColor blackColor];
    }
    return _applyDetailLbl;
}

@end
