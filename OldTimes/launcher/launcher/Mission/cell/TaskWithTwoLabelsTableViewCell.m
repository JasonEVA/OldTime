//
//  TaskWithTwoLabelsTableViewCell.m
//  launcher
//
//  Created by Conan Ma on 15/8/29.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "TaskWithTwoLabelsTableViewCell.h"
#import "UIColor+Hex.h"
#import "Masonry.h"

@interface TaskWithTwoLabelsTableViewCell()

@end

@implementation TaskWithTwoLabelsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.lblTitle];
        [self addSubview:self.lblContent];
        
        [self CreatFrame];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Privite Methods
- (void)CreatFrame
{
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(30);
        make.width.lessThanOrEqualTo(@(self.frame.size.width - 80));
    }];
    
    [self.lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).offset(-20);
        make.left.equalTo(self.lblTitle.mas_right);
    }];
}


#pragma mark - init
- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.textColor = [UIColor mtc_colorWithHex:0x707070];
        _lblTitle.font = [UIFont systemFontOfSize:14];
        _lblTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _lblTitle;
}

- (UILabel *)lblContent
{
    if (!_lblContent)
    {
        _lblContent = [[UILabel alloc] init];
        _lblContent.textColor = [UIColor mtc_colorWithHex:0x959595];
        _lblContent.font = [UIFont systemFontOfSize:14];
        _lblContent.textAlignment = NSTextAlignmentRight;
    }
    return _lblContent;
}
@end
