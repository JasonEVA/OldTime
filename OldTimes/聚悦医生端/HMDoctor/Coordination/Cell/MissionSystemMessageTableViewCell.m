//
//  MissionSystemMessageTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/8/2.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionSystemMessageTableViewCell.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "LeftTriangle.h"
#import "MissionDetailModel.h"
#define W_MAX   ([ [ UIScreen mainScreen ] bounds ].size.width - 110)

@interface MissionSystemMessageTableViewCell()
@property (nonatomic, strong) UILabel *receiveTimeLb;
@property (nonatomic, strong)  UIImageView  *avatar; // 头像
@property (nonatomic, strong) LeftTriangle *leftTri; // 尖角
@property (strong, nonatomic) UIView *cardView;      //整个卡片View

@end
@implementation MissionSystemMessageTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self configElements];
    }
    return self;
}
#pragma mark -private method
- (void)configElements {
    [self.contentView addSubview:self.avatar];
    [self.contentView addSubview:self.cardView];
    [self.contentView addSubview:self.receiveTimeLb];
    [self.contentView addSubview:self.leftTri];
    [self.cardView addSubview:self.titelLb];
    
    [self.receiveTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(20);
        make.height.equalTo(@20);
    }];
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12.5);
        make.top.equalTo(self.receiveTimeLb.mas_bottom).offset(10);
        make.width.height.equalTo(@40);
    }];
    
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatar);
        make.left.equalTo(self.avatar.mas_right).offset(12);
        make.right.lessThanOrEqualTo(self.contentView).offset(-12);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView).offset(8);
        make.bottom.equalTo(self.cardView).offset(-5);
        make.right.equalTo(self.cardView).offset(-10);
        make.left.equalTo(self.cardView).offset(10);
    }];

    [self.leftTri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView);
        make.right.equalTo(self.cardView.mas_left).offset(1);
        make.width.equalTo(@8);
        make.height.equalTo(@40);
    }];
}

- (UILabel *)getLebalWithTitel:(NSString *)titel font:(UIFont *)font textColor:(UIColor *)textColor
{
    UILabel *lb = [UILabel new];
    [lb setText:titel];
    [lb setTextColor:textColor];
    [lb setFont:font];
    return lb;
}

- (void)setCellDataWithModel:(MissionDetailModel *)model
{    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.createTime longLongValue]]]]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (UIView *)cardView
{
    if (!_cardView) {
        _cardView = [UIView new];
        [_cardView setBackgroundColor:[UIColor whiteColor]];
        [_cardView.layer setCornerRadius:5];
        [_cardView.layer setBorderWidth:0.5];
        [_cardView.layer setBorderColor:[UIColor colorWithHex:0xdfdfdf].CGColor];
        [_cardView setClipsToBounds:YES];
    }
    return _cardView;
}

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setFont:[UIFont systemFontOfSize:15]];
        [_titelLb setBackgroundColor:[UIColor whiteColor]];
        [_titelLb setNumberOfLines:0];
        [_titelLb setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_titelLb setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _titelLb.lineBreakMode = NSLineBreakByWordWrapping;
        _titelLb.preferredMaxLayoutWidth = W_MAX;
        
    }
    return _titelLb;
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

- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [UIImageView new];
        _avatar.layer.cornerRadius = 2;
        _avatar.clipsToBounds = YES;
        [_avatar setImage:[UIImage imageNamed:@"mission_icon_sysMsg"]];
    }
    return _avatar;
}

- (LeftTriangle *)leftTri
{
    if (!_leftTri)
    {
        _leftTri = [[LeftTriangle alloc] initWithFrame:CGRectZero WithColor:[UIColor whiteColor] colorBorderColor:[UIColor colorWithHex:0xdfdfdf]];
    }
    return _leftTri;
}

@end
