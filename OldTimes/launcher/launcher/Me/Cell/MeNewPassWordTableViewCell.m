//
//  MeNewPassWordTableViewCell.m
//  launcher
//
//  Created by Conan Ma on 15/9/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeNewPassWordTableViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"

@interface MeNewPassWordTableViewCell()
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *lblLine;
@end

@implementation MeNewPassWordTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addSubview:self.lblTitle];
        [self addSubview:self.tfdNewPassWord];
        [self addSubview:self.btn];
        [self addSubview:self.lblLine];
        [self addSubview:self.btnLowercase];
        [self addSubview:self.btnUppercase];
        [self addSubview:self.btnNumber];
        [self addSubview:self.btnSpecialcase];
        [self addSubview:self.btnMorethaneight];
        [self CreateFrames];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Privite Methods
- (void)CreateFrames
{
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(15);
        make.height.equalTo(@25);
//        make.width.equalTo(@80);
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(20);
        make.height.equalTo(@15);
        make.width.equalTo(@20);
    }];
    
    [self.tfdNewPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblTitle.mas_right).offset(10);
        make.top.equalTo(self).offset(5);
        make.height.equalTo(@45);
        make.right.equalTo(self.btn.mas_left);
    }];
    
    [self.lblLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblTitle).offset(5);
        make.right.equalTo(self);
        make.height.equalTo(@1);
        make.top.equalTo(self).offset(45);
    }];
    
    [self.btnNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset (-10);
        make.top.equalTo(self.lblLine.mas_bottom).offset(3);
        make.height.equalTo(@15);
        make.width.equalTo(@((self.frame.size.width - 20 - 10)/3));
    }];
    
    [self.btnUppercase mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnNumber.mas_left);
        make.top.equalTo(self.lblLine.mas_bottom).offset(3);
        make.height.equalTo(@15);
        make.width.equalTo(@((self.frame.size.width - 20 - 10)/3));
    }];
    
    [self.btnLowercase mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnUppercase.mas_left);
        make.top.equalTo(self.lblLine.mas_bottom).offset(3);
        make.height.equalTo(@15);
        make.width.equalTo(@((self.frame.size.width - 20 - 10)/3));
    }];
    
    [self.btnSpecialcase mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnLowercase);
        make.top.equalTo(self.btnLowercase.mas_bottom).offset(3);
        make.height.equalTo(@15);
        make.width.equalTo(@((self.frame.size.width - 20 - 10)/3));
    }];
    
    [self.btnMorethaneight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnUppercase);
        make.top.equalTo(self.btnUppercase.mas_bottom).offset(3);
        make.height.equalTo(@15);
        make.width.equalTo(@((self.frame.size.width - 20 - 10)/3));
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
    self.btn.selected ^= 1;
    self.tfdNewPassWord.secureTextEntry = !self.btn.selected;
}

- (UIButton *)createButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton new];
    
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    button.titleLabel.font = [UIFont mtc_font_24];
    [button setTitle:[NSString stringWithFormat:@" %@",title] forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:@"Me_RoundDot_Selected"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:@"Me_RoundDot_Unselected"] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorWithRed:190.0/255 green:198.0/255 blue:211.0/255 alpha:1] forState:UIControlStateSelected];

    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    return button;
}

#pragma mark - init
- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.textAlignment = NSTextAlignmentLeft;
        _lblTitle.font = [UIFont mtc_font_30];
        [_lblTitle setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _lblTitle;
}

- (UITextField *)tfdNewPassWord
{
    if (!_tfdNewPassWord)
    {
        _tfdNewPassWord = [[UITextField alloc] init];
        _tfdNewPassWord.textAlignment = NSTextAlignmentLeft;
        _tfdNewPassWord.font = [UIFont mtc_font_30];
        _tfdNewPassWord.secureTextEntry = YES;
        _tfdNewPassWord.returnKeyType = UIReturnKeyDone;
        _tfdNewPassWord.clearButtonMode = YES;
        _tfdNewPassWord.textColor = [UIColor blackColor];
        _tfdNewPassWord.tag = 100;
    }
    return _tfdNewPassWord;
}

- (UIButton *)btn
{
    if (!_btn)
    {
        _btn = [[UIButton alloc] init];
        [_btn setImage:[UIImage imageNamed:@"Me_Revisecode_gray"] forState:UIControlStateNormal];
        [_btn setImage:[UIImage imageNamed:@"Me_Revisecode_blue"] forState:UIControlStateSelected];
        //[_btn addTarget:self action:@selector(ChangeTfd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (UILabel *)lblLine
{
    if (!_lblLine)
    {
        _lblLine = [[UILabel alloc] init];
        _lblLine.backgroundColor = [UIColor mtc_colorWithR:196 g:195 b:200];
    }
    return _lblLine;
}

- (UIButton *)btnLowercase
{
    if (!_btnLowercase)
    {
        _btnLowercase = [self createButtonWithTitle:LOCAL(ME_LOWERWORD)];
    }
    return _btnLowercase;
}

- (UIButton *)btnUppercase
{
    if (!_btnUppercase)
    {
        _btnUppercase = [self createButtonWithTitle:LOCAL(ME_UPPERWORD)];
    }
    return _btnUppercase;
}

- (UIButton *)btnNumber
{
    if (!_btnNumber)
    {
        _btnNumber = [self createButtonWithTitle:LOCAL(ME_NUMBER)];
    }
    return _btnNumber;
}

- (UIButton *)btnSpecialcase
{
    if (!_btnSpecialcase)
    {
        _btnSpecialcase = [self createButtonWithTitle:LOCAL(ME_SPECIALWORD)];
    }
    return _btnSpecialcase;
}

- (UIButton *)btnMorethaneight
{
    if (!_btnMorethaneight)
    {
        _btnMorethaneight = [self createButtonWithTitle:LOCAL(ME_MORETHAN8)];
    }
    return _btnMorethaneight;
}

@end
