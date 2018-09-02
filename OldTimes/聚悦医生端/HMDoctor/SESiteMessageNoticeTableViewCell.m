//
//  SESiteMessageNoticeTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2017/9/12.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SESiteMessageNoticeTableViewCell.h"
#import "SiteMessageLastMsgModel.h"
#import "NSDate+MsgManager.h"

#define W_MAX   ([ [ UIScreen mainScreen ] bounds ].size.width - 50 - ICONWEIGHT - 15)   // 文字最大宽度
#define ICONWEIGHT      55

@interface SESiteMessageNoticeTableViewCell ()
@property (nonatomic, strong) UILabel *receiveTimeLb;
@property (nonatomic, strong) UIView *cardView;         //整个卡片View
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UILabel *bottomLb;
@property (nonatomic, strong) UIImageView *arrowImage;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, strong) UIImageView *iconImage;

@end
@implementation SESiteMessageNoticeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView addSubview:self.receiveTimeLb];
        [self.contentView addSubview:self.cardView];
        [self.cardView addSubview:self.line2];
        [self.cardView addSubview:self.bottomLb];
        [self.cardView addSubview:self.arrowImage];
        [self.cardView addSubview:self.titelLb];
        [self.cardView addSubview:self.contentLb];
        [self.cardView addSubview:self.iconImage];
        
        [self configElements];

    }
    return self;
}

- (void)configElements {
    [self.receiveTimeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(15);
        make.height.equalTo(@20);
    }];
    
    [self.cardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.receiveTimeLb.mas_bottom).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.titelLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView).offset(15);
        make.left.equalTo(self.cardView).offset(10);
        make.right.lessThanOrEqualTo(self.cardView).offset(-20);
    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@ICONWEIGHT);
        make.top.equalTo(self.titelLb.mas_bottom).offset(14);
        make.left.equalTo(self.titelLb);
    }];
    
    [self.contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(15);
        make.top.equalTo(self.iconImage);
        make.right.equalTo(self.cardView).offset(-10);
    }];
    
    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLb.mas_bottom).offset(10).priorityMedium();
        make.top.equalTo(self.iconImage.mas_bottom).offset(10).priorityHigh();
        make.left.equalTo(self.titelLb);
        make.right.equalTo(self.cardView).offset(-10);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.cardView).offset(-35);
    }];
    
    [self.bottomLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line2);
        make.top.equalTo(self.line2.mas_bottom).offset(8);
        make.right.lessThanOrEqualTo(self.arrowImage);
    }];
    
    [self.arrowImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line2);
        make.centerY.equalTo(self.bottomLb);
    }];
    
    
}

- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model {
    SESiteMessageNoticModel *tempModel  = [SESiteMessageNoticModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    [self.titelLb setText:tempModel.msgTitle];
    [self.contentLb setText:tempModel.msg];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:tempModel.picUrl] placeholderImage:[UIImage imageNamed:@"ic_gonggao2"]];
    NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model.createTimestamp appendMinute:NO];
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",strDate]];
}

- (UILabel *)getLebalWithTitel:(NSString *)titel font:(UIFont *)font textColor:(UIColor *)textColor
{
    UILabel *lb = [UILabel new];
    [lb setText:titel];
    [lb setTextColor:textColor];
    [lb setFont:font];
    return lb;
}
#pragma mark - init UI
- (UIView *)cardView
{
    if (!_cardView) {
        _cardView = [UIView new];
        [_cardView setBackgroundColor:[UIColor whiteColor]];
        [_cardView.layer setCornerRadius:5];
        [_cardView setClipsToBounds:YES];
    }
    return _cardView;
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

- (UILabel *)bottomLb
{
    if (!_bottomLb) {
        _bottomLb = [self getLebalWithTitel:@"查看详情" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"333333"]];
    }
    return _bottomLb;
}

- (UILabel *)titelLb
{
    if (!_titelLb) {
        _titelLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHexString:@"333333"]];
    }
    return _titelLb;
}
- (UILabel *)contentLb
{
    if (!_contentLb) {
        _contentLb = [self getLebalWithTitel:@"啊上到卡还是的咖啡机好可怜见都很舒服看进度快圣诞节分离开就死定了房间看" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"333333"]];
        [_contentLb setNumberOfLines:3];
        [_contentLb setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_contentLb setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _contentLb.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLb.preferredMaxLayoutWidth = W_MAX;
    }
    return _contentLb;
}
- (UIImageView *)arrowImage
{
    if (!_arrowImage) {
        _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_r_gray_arrow"]];
    }
    return _arrowImage;
}

- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_gonggao2"]];
    }
    return _iconImage;
}

- (UIView *)line2
{
    if (!_line2) {
        _line2 = [UIView new];
        [_line2 setBackgroundColor:[UIColor colorWithHexString:@"dfdfdf"]];
    }
    return _line2;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
