//
//  TaskTwoLabelsWithArrowTableViewCell.m
//  launcher
//
//  Created by Conan Ma on 15/8/29.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "TaskTwoLabelsWithArrowTableViewCell.h"
#import "UIColor+Hex.h"
#import "Masonry.h"

@interface TaskTwoLabelsWithArrowTableViewCell()

@end

@implementation TaskTwoLabelsWithArrowTableViewCell

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.lblContent];
        [self CreatFrame];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)CreatFrame
{
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.left.equalTo(self.lblTitle.mas_right).offset(10);
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
