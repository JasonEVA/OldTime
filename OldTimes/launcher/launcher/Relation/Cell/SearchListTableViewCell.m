//
//  SearchListTableViewCell.m
//  launcher
//
//  Created by TabLiu on 16/3/23.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "SearchListTableViewCell.h"
#import "UIFont+Util.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AvatarUtil.h"
#import "MyDefine.h"
#import <MintcodeIM/MintcodeIM.h>
#import "UIImage+Manager.h"
#import "UIColor+Hex.h"
#import <MintcodeIM/MintcodeIM.h>

@interface SearchListTableViewCell ()

@property (nonatomic,strong) UIImageView * imgView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * phoneLabel;
@property (nonatomic,strong) UIButton * selectButton;

@end

@implementation SearchListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.phoneLabel];
        [self.contentView addSubview:self.selectButton];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12.5);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.height.equalTo(@40);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgView.mas_right).offset(15);
            make.right.equalTo(self.contentView.mas_right).offset(-100);
            make.bottom.equalTo(self.contentView.mas_centerY).offset(-2);
        }];
        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgView.mas_right).offset(15);
            make.right.equalTo(self.contentView.mas_right).offset(-100);
            make.top.equalTo(self.contentView.mas_centerY).offset(2);
        }];
        [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@60);
            make.height.equalTo(@30);
            make.right.equalTo(self.contentView).offset(-20);
        }];
    }
    return self;
}

- (void)setCellData:(MessageRelationInfoModel *)model serchText:(NSString *)searchText
{
    NSURL *urlHead = avatarURL(avatarType_80, model.relationName);
    [self.imgView sd_setImageWithURL:urlHead placeholderImage:IMG_PLACEHOLDER_HEAD];
    self.titleLabel.text = ![model.remark isEqualToString:@""]?model.remark:model.nickName;
    self.phoneLabel.text = model.mobile;
    
    //处理搜索显
    if (![searchText isEqualToString:@""])
    {
        NSMutableAttributedString *str = [self text:self.titleLabel.text searchText:searchText];
        self.titleLabel.attributedText = str;
    }
    
    
    [self.selectButton setTitle:LOCAL(FRIEND_CHAT) forState:UIControlStateNormal];
}
#pragma mark - selectButtonClick
- (void)selectButtonClick:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SearchListTableViewCell_SelectButtonClick:)]) {
        [self.delegate SearchListTableViewCell_SelectButtonClick:self.path];
    }
}

#pragma mark - privateMethod
- (NSMutableAttributedString *)text:(NSString *)string searchText:(NSString *)text
{
    NSMutableString * mutableString = [[NSMutableString alloc] initWithString:string];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    int length = 0;
    while (YES) {
        NSRange range = [mutableString rangeOfString:text options:NSCaseInsensitiveSearch];
        if (range.length > 0) {
            NSRange newRange = NSMakeRange(range.location + length, range.length);
            [str addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:1 green:242/255.0 blue:70/255.0 alpha:1] range:newRange];
            [mutableString deleteCharactersInRange:range];
            length += range.length;
        }else {
            return str;
        }
    }
    return str;
}

#pragma mark - ui
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 3.0;
    }
    return _imgView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont mtc_font_26];
    }
    return _titleLabel;
}
- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
        _phoneLabel.font = [UIFont mtc_font_26];
    }
    return _phoneLabel;
}
- (UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectButton setBackgroundImage:[UIImage mtc_imageColor:[UIColor themeBlue]] forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectButton.layer.masksToBounds = YES;
        _selectButton.layer.cornerRadius = 3.0;
    }
    return _selectButton;
}

@end
