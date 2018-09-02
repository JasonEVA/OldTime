//
//  NewApplyCommentImgTableViewCell.m
//  launcher
//
//  Created by conanma on 16/1/12.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyCommentImgTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIFont+Util.h"
#import "UIColor+Hex.h"
#import "UIImageView+WebCache.h"
#import "AvatarUtil.h"
#import "NSDate+DateTools.h"
#import "MyDefine.h"
#import "AppApprovalModel.h"
#import "AppTaskModel.h"
#import "Category.h"
#import <MJExtension/MJExtension.h>
#import "NSBundle+Language.h"
#import "AttachmentUtil.h"

static CGFloat const kNewApplyCommentImgCellImageHeight = 100;

@interface NewApplyCommentImgTableViewCell()
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UIImageView *imgViewHead;
@property (nonatomic, strong) UILabel *lblTime;
@property (nonatomic, strong) UIImageView *imgAttachment;
@property (nonatomic, copy) void (^clickBlock)(id);
@end

@implementation NewApplyCommentImgTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.imgViewHead];
        [self.contentView addSubview:self.lblName];
        [self.contentView addSubview:self.lblTime];
        [self.contentView addSubview:self.imgAttachment];
        
        [self setframes];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setframes
{
    [self.imgViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@40);
        make.left.equalTo(self.contentView).offset(13);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgViewHead.mas_right).offset(5);
        make.top.equalTo(self.imgViewHead);
        make.height.equalTo(@20);
    }];
    
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-8);
        make.top.bottom.equalTo(self.lblName);
    }];
    
    [self.imgAttachment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgViewHead.mas_right).offset(5);
        make.top.equalTo(self.lblName.mas_bottom).offset(2);
        make.height.width.equalTo(@60);
    }];
}

- (void)dataWithModel:(ApplicationCommentModel *)model
{
    [self.imgViewHead sd_setImageWithURL:avatarURL(avatarType_80, model.createUser) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"] options:SDWebImageRefreshCached];
    self.lblName.text = model.createUserName;
    self.lblTime.text = [model.createTime timeAgoSinceNow];
    
    UIImage *fileImage = [AttachmentUtil attachmentIconFromFileName:model.content];
    if (fileImage) {
        self.imgAttachment.image = fileImage;
        return;
    }
    
    [self.imgAttachment sd_setImageWithURL:[NSURL URLWithString:model.filePath] placeholderImage:[UIImage imageNamed:@"image_placeholder_loading"]];
}

- (void)clickToSee:(void (^)(id))clickBlock {
    _clickBlock = clickBlock;
}

+ (CGFloat)getHeight {
	return kNewApplyCommentImgCellImageHeight;
}

#pragma mark - Button Click
- (void)clickToSeeImage {
    !self.clickBlock ?: self.clickBlock(self);
}

#pragma mark - init
- (UILabel *)lblName
{
    if (!_lblName)
    {
        _lblName = [[UILabel alloc] init];
        [_lblName setTextColor:[UIColor themeGray]];
        [_lblName setFont:[UIFont mtc_font_30]];
        [_lblName setTextAlignment:NSTextAlignmentLeft];
    }
    return _lblName;
}

- (UILabel *)lblTime
{
    if (!_lblTime)
    {
        _lblTime = [[UILabel alloc] init];
        [_lblTime setFont:[UIFont mtc_font_24]];
        [_lblTime setTextColor:[UIColor themeGray]];
        [_lblTime setTextAlignment:NSTextAlignmentRight];
    }
    return _lblTime;
}

- (UIImageView *)imgViewHead
{
    if (!_imgViewHead)
    {
        _imgViewHead = [[UIImageView alloc] init];
        _imgViewHead.layer.cornerRadius = 2.0f;
        _imgViewHead.clipsToBounds = YES;
    }
    return _imgViewHead;
}

- (UIImageView *)imgAttachment
{
    if (!_imgAttachment)
    {
        _imgAttachment = [[UIImageView alloc] init];
        _imgAttachment.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToSeeImage)];
        [_imgAttachment addGestureRecognizer:tapGesture];
    }
    return _imgAttachment;
}
@end
