//
//  NewMeNewPassWordTableViewCell.m
//  launcher
//
//  Created by 马晓波 on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewMeNewPassWordTableViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"

@interface NewMeNewPassWordTableViewCell()
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *lblLine;
@property (nonatomic, strong) UILabel *lblLine1;
@property (nonatomic, strong) UILabel *lblLine2;
@property (nonatomic, strong) UILabel *lblLine3;
@end

@implementation NewMeNewPassWordTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addSubview:self.lblTitle];
        [self addSubview:self.tfdNewPassWord];
        [self addSubview:self.btn];
        [self addSubview:self.lblLine];
        [self addSubview:self.lblLine1];
        [self addSubview:self.lblLine2];
        [self addSubview:self.lblLine3];
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
        make.left.equalTo(self.tfdNewPassWord);
        make.right.equalTo(self);
        make.height.equalTo(@1);
        make.top.equalTo(self).offset(45);
    }];
    
    [self.lblLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblLine);
        make.height.equalTo(@5);
        make.top.equalTo(self.lblLine.mas_bottom).offset(20);
    }];
    
    [self.lblLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblLine1.mas_right).offset(1);
        make.height.equalTo(self.lblLine1);
        make.width.equalTo(self.lblLine1);
        make.top.equalTo(self.lblLine1);
    }];
    
    [self.lblLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblLine2.mas_right).offset(1);
        make.height.equalTo(self.lblLine1);
        make.width.equalTo(self.lblLine1);
        make.top.equalTo(self.lblLine1);
        make.right.equalTo(self.btn.mas_right);
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

- (void)SetSecurityType:(SecurityType)type
{
    self.lblLine1.backgroundColor = [UIColor mtc_colorWithHex:0x999999];
    self.lblLine2.backgroundColor = [UIColor mtc_colorWithHex:0x999999];
    self.lblLine3.backgroundColor = [UIColor mtc_colorWithHex:0x999999];
    
    switch (type)
    {
        case SecurityType_None:
            break;
        case SecurityType_Low:
        {
            self.lblLine1.backgroundColor = [UIColor themeRed];
        }
            break;
        case SecurityType_Middle:
        {
            self.lblLine1.backgroundColor = [UIColor mtc_colorWithHex:0xfab56d];
            self.lblLine2.backgroundColor = [UIColor mtc_colorWithHex:0xfab56d];
        }
            break;
        case SecurityType_High:
        {
            self.lblLine1.backgroundColor = [UIColor themeGreen];
            self.lblLine2.backgroundColor = [UIColor themeGreen];
            self.lblLine3.backgroundColor = [UIColor themeGreen];
        }
            break;
        default:
            break;
    }
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

- (UILabel *)lblLine1
{
    if (!_lblLine1)
    {
        _lblLine1 = [[UILabel alloc] init];
        _lblLine1.layer.cornerRadius = 1;
        [_lblLine1 setBackgroundColor:[UIColor mtc_colorWithHex:0x999999]];
    }
    return _lblLine1;
}

- (UILabel *)lblLine2
{
    if (!_lblLine2)
    {
        _lblLine2 = [[UILabel alloc] init];
        _lblLine2.layer.cornerRadius = 1;
        [_lblLine2 setBackgroundColor:[UIColor mtc_colorWithHex:0x999999]];
    }
    return _lblLine2;
}

- (UILabel *)lblLine3
{
    if (!_lblLine3)
    {
        _lblLine3 = [[UILabel alloc] init];
        _lblLine3.layer.cornerRadius = 1;
        [_lblLine3 setBackgroundColor:[UIColor mtc_colorWithHex:0x999999]];
    }
    return _lblLine3;
}
//- (UIButton *)btnLowercase
//{
//    if (!_btnLowercase)
//    {
//        _btnLowercase = [self createButtonWithTitle:LOCAL(ME_LOWERWORD)];
//    }
//    return _btnLowercase;
//}
//
//- (UIButton *)btnUppercase
//{
//    if (!_btnUppercase)
//    {
//        _btnUppercase = [self createButtonWithTitle:LOCAL(ME_UPPERWORD)];
//    }
//    return _btnUppercase;
//}
//
//- (UIButton *)btnNumber
//{
//    if (!_btnNumber)
//    {
//        _btnNumber = [self createButtonWithTitle:LOCAL(ME_NUMBER)];
//    }
//    return _btnNumber;
//}
//
//- (UIButton *)btnSpecialcase
//{
//    if (!_btnSpecialcase)
//    {
//        _btnSpecialcase = [self createButtonWithTitle:LOCAL(ME_SPECIALWORD)];
//    }
//    return _btnSpecialcase;
//}
//
//- (UIButton *)btnMorethaneight
//{
//    if (!_btnMorethaneight)
//    {
//        _btnMorethaneight = [self createButtonWithTitle:LOCAL(ME_MORETHAN8)];
//    }
//    return _btnMorethaneight;
//}

@end
