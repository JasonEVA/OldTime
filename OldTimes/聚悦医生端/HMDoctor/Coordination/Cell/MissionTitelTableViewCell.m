//
//  MissionTitelTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionTitelTableViewCell.h"
#import "UIFont+Util.h"
#import "UIImage+EX.h"
#import "UIColor+Common.h"

@interface MissionTitelTableViewCell ()


@property (nonatomic, copy) MissionTitelTableViewCellBlock selectBlock;

@end

@implementation MissionTitelTableViewCell
+ (NSString *)identifier { return NSStringFromClass([self class]);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.selectButton];
        
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.bottom.equalTo(self);
            make.width.equalTo(@65);
        }];
        
        [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self);
            make.width.equalTo(@50);
            make.height.equalTo(@25);
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lblTitle.mas_right).offset(10);
            make.centerY.equalTo(self);
            make.right.equalTo(self.selectButton.mas_left).offset(-5);
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)btnSelect:(MissionTitelTableViewCellBlock)selectBlock {
    self.selectBlock = selectBlock;
}

- (void)btnClick
{
    if (self.selectBlock) {
        self.selectBlock();
    }
}

#pragma mark - Initializer
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [UITextField new];
        [_textField setFont:[UIFont systemFontOfSize:14]];
    }
    return _textField;
}

- (UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [UIButton new];
        [_selectButton setTitle:@"选择" forState:UIControlStateNormal];
        [_selectButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_selectButton setBackgroundImage:[UIImage at_imageWithColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_selectButton.layer setCornerRadius:3];
        [_selectButton setClipsToBounds:YES];
        [_selectButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}
- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.textColor = [UIColor commonDarkGrayColor_666666];
        _lblTitle.font = [UIFont systemFontOfSize:15];
    }
    return _lblTitle;
}

@end
