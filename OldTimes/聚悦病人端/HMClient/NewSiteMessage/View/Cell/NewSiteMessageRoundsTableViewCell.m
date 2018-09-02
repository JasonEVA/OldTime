//
//  NewSiteMessageRoundsTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/1/22.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewSiteMessageRoundsTableViewCell.h"
#import "NewSiteMessageRoundsModel.h"
#import "NSDate+MsgManager.h"
#import "AvatarUtil.h"

#define W_MAX   ([ [ UIScreen mainScreen ] bounds ].size.width - 130)   // 文字最大宽度

@interface  NewSiteMessageRoundsTableViewCell ()
@property (nonatomic, strong) UIImageView *imgViewHeadIcon;         // 头像
@property (nonatomic, strong) UILabel *receiveTimeLb;
@property (nonatomic, strong) UIImageView *cardView;      //整个卡片View
@property (nonatomic, strong) UIImageView *iconView;      //icon
@property (nonatomic, strong) UILabel *contentLb;         //内容
@property (nonatomic, strong) UILabel *replyLb;         //点击回复
@property (nonatomic, strong) UILabel *nikeNameLb;   //昵称


@end
@implementation NewSiteMessageRoundsTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView addSubview:self.receiveTimeLb];
        [self.contentView addSubview:self.cardView];
        [self.contentView addSubview:self.imgViewHeadIcon];
        [self.contentView addSubview:self.nikeNameLb];
        [self.cardView addSubview:self.iconView];
        [self.cardView addSubview:self.contentLb];
        [self.cardView addSubview:self.replyLb];
        
        
        
        [self baseConfigElements];
        
    }
    return self;
}
- (void)baseConfigElements {
    [self.receiveTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(15);
        make.height.equalTo(@20);
    }];
    
    [self.imgViewHeadIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.receiveTimeLb.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.width.height.equalTo(@40);
    }];
    
    [self.nikeNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgViewHeadIcon);
        make.left.equalTo(self.imgViewHeadIcon.mas_right).offset(15);
        make.right.lessThanOrEqualTo(self.contentView).offset(-60);
    }];
    
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nikeNameLb.mas_bottom).offset(2);
        make.left.equalTo(self.imgViewHeadIcon.mas_right).offset(8);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-50);;

    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardView).offset(20);
        make.top.equalTo(self.cardView).offset(15);
        make.width.height.equalTo(@37.5);
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView);
        make.left.equalTo(self.iconView.mas_right).offset(15);
        make.right.lessThanOrEqualTo(self.cardView).offset(-15);
    }];
    
    [self.replyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLb.mas_bottom).offset(6);
        make.left.equalTo(self.contentLb);
        make.bottom.equalTo(self.cardView).offset(-15);
    }];
    
}


- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model {
    NewSiteMessageRoundsModel *tempModel  = [NewSiteMessageRoundsModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    [self.contentLb setText:tempModel.msg];
    NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model.createTimestamp appendMinute:NO];
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",strDate]];
    NSURL *urlHead = avatarURL(avatarType_80, [NSString stringWithFormat:@"%ld",tempModel.staffUserId]);
    [self.imgViewHeadIcon sd_setImageWithURL:urlHead placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    NSDictionary *dict = model.doThing.mj_JSONObject;
    [self.nikeNameLb setText:dict[@"nickName"]];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)getLebalWithTitel:(NSString *)titel font:(UIFont *)font textColor:(UIColor *)textColor
{
    UILabel *lb = [UILabel new];
    [lb setText:titel];
    [lb setTextColor:textColor];
    [lb setFont:font];
    return lb;
}

- (UIImageView *)imgViewHeadIcon
{
    if (!_imgViewHeadIcon)
    {
        _imgViewHeadIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"im_xitong"]];
        [_imgViewHeadIcon setUserInteractionEnabled:YES];
        _imgViewHeadIcon.layer.cornerRadius = 2.5;
        _imgViewHeadIcon.clipsToBounds = YES;
    }
    
    return _imgViewHeadIcon;
}

- (UIImageView *)cardView
{
    if (!_cardView) {
        _cardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NewSite_Roundsback"]];
    }
    return _cardView;
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NewSite_RoundsIcon"]];
    }
    return _iconView;
}

- (UILabel *)receiveTimeLb
{
    if (!_receiveTimeLb) {
        _receiveTimeLb = [self getLebalWithTitel:@" 12-12 18:13 " font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"FFFFFF"]];
        [_receiveTimeLb.layer setCornerRadius:3];
        [_receiveTimeLb setBackgroundColor:[UIColor colorWithHexString:@"cecece"]];
        [_receiveTimeLb setClipsToBounds:YES];
        
    }
    return _receiveTimeLb;
}
- (UILabel *)replyLb
{
    if (!_replyLb) {
        _replyLb = [self getLebalWithTitel:@"点击回复" font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"FFFFFF"]];
        [_replyLb setAlpha:0.6];
    }
    return _replyLb;
}

- (UILabel *)contentLb
{
    if (!_contentLb) {
        _contentLb = [self getLebalWithTitel:@"点击回复" font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHexString:@"FFFFFF"]];
        [_contentLb setNumberOfLines:0];
//        _contentLb.preferredMaxLayoutWidth = W_MAX - 55 - 8;
    }
    return _contentLb;
}

- (UILabel *)nikeNameLb
{
    if (!_nikeNameLb) {
        _nikeNameLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"333333"]];
    }
    return _nikeNameLb;
}
@end
