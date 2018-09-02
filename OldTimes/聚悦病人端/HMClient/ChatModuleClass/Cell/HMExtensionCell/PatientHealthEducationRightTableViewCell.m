//
//  PatientHealthEducationRightTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2016/10/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientHealthEducationRightTableViewCell.h"
#import "IMNewsModel.h"
#import "ChatBaseTableViewCell+BubbleStyleEdit.h"

@interface PatientHealthEducationRightTableViewCell ()

@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation PatientHealthEducationRightTableViewCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.wz_contentView addSubview:self.titelLb];
        [self.wz_contentView addSubview:self.contentLb];
        [self.wz_contentView addSubview:self.iconView];
        
        [self configElements];
    }
    return self;
}
- (void)configElements {
    
    [self ats_changeBubbleBackgroundImage:[UIImage imageNamed:@"chat_right_borderBubble"]];

    [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgViewBubble).offset(3);
        make.left.equalTo(self.imgViewBubble).offset(10);
        make.right.equalTo(self.imgViewBubble).offset(-10);
        make.width.mas_equalTo(ScreenWidth - 145);
        make.height.equalTo(@(45*kScreenScale));
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titelLb.mas_bottom);
        make.left.equalTo(self.titelLb);
        make.width.height.equalTo(@55);
        make.bottom.equalTo(self.imgViewBubble).offset(-12*kScreenScale);
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView);
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.right.equalTo(self.titelLb);
        
    }];
}

- (void)fillInDadaWith:(IMNewsModel *)model {
    [model conmfirmNewsType];

    [self.titelLb setText:model.newsTitle];
    [self.contentLb setText:model.newsDescription];
    NSString *placeHoldImageName = @"ic_xuanjiao";
    if (model.newsType == News_Notice) {
        // 公告
        placeHoldImageName = @"ic_gonggao2";
    }
    else {
        placeHoldImageName = @"ic_xuanjiao";
    }
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.newsPicUrl] placeholderImage:[UIImage imageNamed:placeHoldImageName]];}
#pragma mark  - init
- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titelLb setFont:[UIFont font_32]];
        [_titelLb setNumberOfLines:2];
    }
    return _titelLb;
}

- (UILabel *)contentLb {
    if (!_contentLb) {
        _contentLb = [UILabel new];
        [_contentLb setFont:[UIFont font_28]];
        [_contentLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_contentLb setNumberOfLines:3];
    }
    return _contentLb;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [UIImageView new];
        [_iconView.layer setCornerRadius:2.5];
        [_iconView setClipsToBounds:YES];
    }
    return _iconView;
}
@end
