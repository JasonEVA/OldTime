//
//  RelationListTableViewCell.m
//  launcher
//
//  Created by TabLiu on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "RelationListTableViewCell.h"
#import "UIFont+Util.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AvatarUtil.h"
#import "MyDefine.h"
#import <MintcodeIM/MintcodeIM.h>
#import "UIImage+Manager.h"
#import "UIColor+Hex.h"
@interface RelationListTableViewCell ()

@property (nonatomic,strong) UIImageView * imgView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * phoneLabel;
@property(nonatomic, strong) UIButton  *addBtn;
@property(nonatomic, copy) addOrConnectBlock  myBlock;
@end

@implementation RelationListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(RelationListTableViewCellType)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.wz_contentView addSubview:self.imgView];
        [self.wz_contentView addSubview:self.titleLabel];
        [self.wz_contentView addSubview:self.phoneLabel];
        [self.wz_contentView addSubview:self.addBtn];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.wz_contentView.mas_centerY);
            make.left.equalTo(self.wz_contentView).offset(10);
            make.width.height.equalTo(@40);
        }];
        if (type == CellType_Define) {
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.imgView.mas_right).offset(15);
                make.centerY.equalTo(self.wz_contentView.mas_centerY);
            }];
            self.phoneLabel.hidden = YES;
        }else {
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.imgView.mas_right).offset(15);
                make.right.equalTo(self.wz_contentView.mas_right).offset(-20);
                make.bottom.equalTo(self.wz_contentView.mas_centerY).offset(-2);
            }];
            [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.imgView.mas_right).offset(15);
                make.right.equalTo(self.wz_contentView.mas_right).offset(-20);
                make.top.equalTo(self.wz_contentView.mas_centerY).offset(2);
            }];
            
            [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.wz_contentView).offset(10);
                make.bottom.equalTo(self.wz_contentView).offset(-10);
                make.width.greaterThanOrEqualTo(@60);
                make.right.equalTo(self.wz_contentView.mas_right).offset(-20);
            }];
            self.addBtn.hidden = YES;
        }
        
    }
    return self;
}



- (void)setCellDate:(MessageRelationInfoModel *)model
{
    NSURL *urlHead = avatarIMURL(avatarType_80, model.relationAvatar);
    [self.imgView sd_setImageWithURL:urlHead placeholderImage:IMG_PLACEHOLDER_HEAD];
    self.titleLabel.text = ![model.remark isEqualToString:@""] ? model.remark : model.nickName;
    self.phoneLabel.text = model.mobile;
}

- (void)isAdded:(BOOL)isAdd
{
    if (isAdd)
    {
        [self.addBtn setTitle:LOCAL(FRIEND_CHAT) forState:UIControlStateNormal];
    }else
    {
        [self.addBtn setTitle:LOCAL(FRIEND_ADD) forState:UIControlStateNormal];
    }
    self.addBtn.hidden = NO;
}

- (void)addOrConnectedwithBlock:(addOrConnectBlock)block
{
    self.myBlock = block;
}

#pragma makr - privateMethod
- (void)addOrConnectAction
{
    !self.myBlock ?: self.myBlock([self.addBtn.titleLabel.text isEqualToString:LOCAL(FRIEND_CHAT)]);
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

- (UIButton *)addBtn
{
    if (!_addBtn)
    {
        _addBtn = [[UIButton alloc] init];
        [_addBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor themeBlue]] forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addBtn.layer.cornerRadius = 2;
        _addBtn.layer.masksToBounds = YES;
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_addBtn addTarget:self action:@selector(addOrConnectAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _addBtn;
}
@end
