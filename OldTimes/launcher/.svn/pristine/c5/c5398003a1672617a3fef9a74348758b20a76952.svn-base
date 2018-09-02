//
//  MePassWordOriginalTableViewCell.m
//  launcher
//
//  Created by Conan Ma on 15/9/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MePassWordOriginalTableViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"

@interface MePassWordOriginalTableViewCell()
@property (nonatomic, strong) UIButton *btn;
@end

@implementation MePassWordOriginalTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addSubview:self.lblTitle];
        [self addSubview:self.tfdOriginal];
        [self addSubview:self.btn];
        [self CreateFrames];
    }
    return self;
}
- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - Privite Methods
- (void)CreateFrames
{
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.height.equalTo(@25);
//        make.width.lessThanOrEqualTo(@120);
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.height.equalTo(@15);
        make.width.equalTo(@20);
    }];
    
    [self.tfdOriginal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblTitle.mas_right).offset(10);        make.centerY.equalTo(self);
        make.height.equalTo(@25);
        make.right.equalTo(self.btn.mas_left);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(ChangeTfd) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_btn).insets(UIEdgeInsetsMake(-10, -10, -10, -10));
    }];

}

- (void)ChangeTfd
{
    if (self.btn.selected)
    {
        self.btn.selected = NO;
        self.tfdOriginal.secureTextEntry = YES;
    }
    else
    {
        self.btn.selected = YES;
        self.tfdOriginal.secureTextEntry = NO;
    }
}

#pragma mark - init
- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.textColor = [UIColor blackColor];
        _lblTitle.font = [UIFont mtc_font_30];
        [_lblTitle setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _lblTitle;
}

- (UITextField *)tfdOriginal
{
    if (!_tfdOriginal)
    {
        _tfdOriginal = [[UITextField alloc] init];
        _tfdOriginal.textAlignment = NSTextAlignmentLeft;
        _tfdOriginal.font = [UIFont mtc_font_30];
        _tfdOriginal.secureTextEntry = YES;
        _tfdOriginal.returnKeyType = UIReturnKeyDone;
        _tfdOriginal.clearButtonMode = YES;
        _tfdOriginal.textColor = [UIColor blackColor];
    }
    return _tfdOriginal;
}

- (UIButton *)btn
{
    if (!_btn)
    {
        _btn = [[UIButton alloc] init];
        [_btn setImage:[UIImage imageNamed:@"Me_Revisecode_gray"] forState:UIControlStateNormal];
        [_btn setImage:[UIImage imageNamed:@"Me_Revisecode_blue"] forState:UIControlStateSelected];
        _btn.selected = NO;
            }
    return _btn;
}
@end
