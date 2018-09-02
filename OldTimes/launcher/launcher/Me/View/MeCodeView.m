//
//  MeCodeView.m
//  launcher
//
//  Created by Conan Ma on 15/9/23.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeCodeView.h"
#import <Masonry.h>
//#import "QRCodeGenerator.h"
#import "MyDefine.h"
#import "UnifiedUserInfoManager.h"
#import "AvatarUtil.h"
#import "UIImageView+WebCache.h"

@interface MeCodeView()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *imgLogo;
@end

@implementation MeCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        [self initComponents];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToSelect)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

#pragma mark - Button Click
- (void)clickToSelect
{
    [self removeFromSuperview];
}

- (void)initComponents
{
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self).insets(UIEdgeInsetsMake(220, 50, 60, 50));
//        make.bottom.equalTo(self).offset(-80);
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
        make.width.equalTo(@(220));
        make.height.equalTo(@(280));
    }];
    
    [self.contentView addSubview:self.imgHeader];
    [self.imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(30);
        make.top.equalTo(self.contentView).offset(30);
        make.height.width.equalTo(@(50));
    }];
    
    [self.contentView addSubview:self.lblName];
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgHeader);
        make.left.equalTo(self.imgHeader.mas_right).offset(10);
        make.height.equalTo(@(25));
        make.right.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.lblID];
    [self.lblID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblName.mas_bottom);
        make.left.equalTo(self.imgHeader.mas_right).offset(10);
        make.height.equalTo(@(25));
        make.right.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(6);
        make.right.equalTo(self.contentView).offset(-6);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(self.imgView.mas_width);
    }];
    
    [self.contentView addSubview:self.imgLogo];
    [self.imgLogo mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.centerY.equalTo(self.imgView);
        make.centerX.equalTo(self.imgView).offset(2);
        make.centerY.equalTo(self.imgView);
        make.width.height.equalTo(@(35));
    }];
}

- (void)setLblNameText:(NSString *)text
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,text.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont  boldSystemFontOfSize:15.0] range:NSMakeRange(0,text.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,text.length)];
    self.lblName.attributedText = str;
    self.lblName.textAlignment = NSTextAlignmentLeft;
}

- (void)GetInformation:(NSString *)information
{
//    UIImage *image = [QRCodeGenerator qrImageForString:information imageSize:self.frame.size.width - 100];
//    [self.imgView setImage:image];
}

- (void)GetModel:(ContactPersonDetailInformationModel *)model
{
    [self GetIDtext:@"9612133"];
    [self setLblNameText:model.u_true_name];
    [self GetInformation:model.show_id];
//    [self GetInformation:@"要请我吃饭的請联系我：15157121662 速度要快 姿势要帅"];
}

- (void)GetIDtext:(NSString *)ID
{
    self.lblID.text = [NSString stringWithFormat:@"Launchr ID: %@",ID];
}

#pragma mark - Initializer
- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIImageView *)imgView
{
    if (!_imgView)
    {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (UIImageView *)imgHeader
{
    if (!_imgHeader)
    {
        _imgHeader = [[UIImageView alloc] init];
        _imgHeader.layer.cornerRadius = 2.0f;
        _imgHeader.clipsToBounds = YES;
//        [_imgHeader sd_setImageWithURL:[AvatarUtil avatarURLWithWidthHeight:avatarType_80 userShowId:[[UnifiedUserInfoManager share] userShowID]] placeholderImage:[UIImage imageNamed:@"login_head_companylogo"] options:SDWebImageRefreshCached];
    }
    return _imgHeader;
}

- (UILabel *)lblName
{
    if (!_lblName)
    {
        _lblName = [[UILabel alloc] init];
    }
    return _lblName;
}

- (UILabel *)lblID
{
    if (!_lblID)
    {
        _lblID = [[UILabel alloc] init];
        [_lblID setTextColor:[UIColor grayColor]];
        _lblID.font = [UIFont systemFontOfSize:10];

    }
    return _lblID;
}

- (UIImageView *)imgLogo
{
    if (!_imgLogo)
    {
        _imgLogo = [[UIImageView alloc] init];
        _imgLogo.layer.cornerRadius = 2.0f;
        [_imgLogo setImage:[UIImage imageNamed:@"login_head_companylogo"]];
    }
    return _imgLogo;
}
@end
