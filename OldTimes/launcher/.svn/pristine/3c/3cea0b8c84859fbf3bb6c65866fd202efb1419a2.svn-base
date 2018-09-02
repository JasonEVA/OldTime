//
//  NewApplyBtnsTableViewCell.m
//  launcher
//
//  Created by conanma on 16/1/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyBtnsTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "UIFont+Util.h"
#import "MyDefine.h"

@interface NewApplyBtnsTableViewCell()
@property (nonatomic, strong) UIButton *btnfirst;
@property (nonatomic, strong) UIButton *btnSecond;
@property (nonatomic, strong) UIButton *btnThird;
@end

@implementation NewApplyBtnsTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.btnfirst];
        [self.contentView addSubview:self.btnSecond];
        [self.contentView addSubview:self.btnThird];
        
        [self setframes];
    }
    return self;
}

#pragma mark - Privite Methods
- (void)setframes
{
    [self.btnSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.contentView);
        make.height.equalTo(@30);
        make.width.equalTo(@80);
    }];
    
    [self.btnfirst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.btnSecond.mas_left).offset(-20);
        make.height.equalTo(@30);
        make.width.equalTo(@80);
    }];
    
    [self.btnThird mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.btnSecond.mas_right).offset(20);
        make.height.equalTo(@30);
        make.width.equalTo(@80);
    }];
}

- (void)btnsClick:(UIButton *)btn
{
    if (self.myblock)
    {
        self.myblock(btn.tag);
    }
}

#pragma mark - init
- (UIButton *)btnSecond
{
    if (!_btnSecond)
    {
        _btnSecond = [[UIButton alloc] init];
        _btnSecond.layer.cornerRadius = 4.0f;
        _btnSecond.layer.borderWidth = 1.0f;
        _btnSecond.layer.borderColor = [UIColor themeRed].CGColor;
        _btnSecond.tag = 0;
        [_btnSecond setTitle:LOCAL(VETO) forState:UIControlStateNormal];
        [_btnSecond setTitleColor:[UIColor themeRed] forState:UIControlStateNormal];
        [_btnSecond addTarget:self action:@selector(btnsClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSecond;
}

- (UIButton *)btnThird
{
    if (!_btnThird)
    {
        _btnThird = [[UIButton alloc] init];
        _btnThird.layer.cornerRadius = 4.0f;
        _btnThird.layer.borderWidth = 1.0f;
        _btnThird.layer.borderColor = [UIColor mtc_colorWithHex:0xff8500].CGColor;
        _btnThird.tag = 1;
        [_btnThird setTitle:LOCAL(APPLY_SENDER_BACKWARD_TITLE) forState:UIControlStateNormal];
        [_btnThird setTitleColor:[UIColor mtc_colorWithHex:0xff8500] forState:UIControlStateNormal];
        [_btnThird addTarget:self action:@selector(btnsClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnThird;
}

- (UIButton *)btnfirst
{
    if (!_btnfirst)
    {
        _btnfirst = [[UIButton alloc] init];
        _btnfirst.layer.cornerRadius = 4.0f;
        _btnfirst.layer.borderWidth = 1.0f;
        _btnfirst.tag = 2;
        _btnfirst.layer.borderColor = [UIColor mtc_colorWithHex:0x21c064].CGColor;
        [_btnfirst setTitle:LOCAL(APPLY_SENDER_ACCEPT_TITLE) forState:UIControlStateNormal];
        [_btnfirst setTitleColor:[UIColor mtc_colorWithHex:0x21c064] forState:UIControlStateNormal];
        [_btnfirst addTarget:self action:@selector(btnsClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnfirst;
}

- (void)setblock:(backblock)block
{
    if (block)
    {
        self.myblock = block;
    }
}
@end
