//
//  NewSiteMessageBubbleBaseTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2016/12/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteMessageBubbleBaseTableViewCell.h"

@implementation NewSiteMessageBubbleBaseTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView addSubview:self.receiveTimeLb];
        [self.contentView addSubview:self.cardView];
        [self.contentView addSubview:self.imgViewHeadIcon];
        [self.contentView addSubview:self.leftTri];
        [self.contentView addSubview:self.nikeNameLb];

        
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
        make.left.equalTo(self.imgViewHeadIcon.mas_right).offset(15);
        make.bottom.equalTo(self.contentView);

    }];
    
    [self.leftTri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView);
        make.right.equalTo(self.cardView.mas_left).offset(1);
        make.width.equalTo(@8);
        make.height.equalTo(@30);
    }];
    
    
    
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

- (UILabel *)nikeNameLb
{
    if (!_nikeNameLb) {
        _nikeNameLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"333333"]];
    }
    return _nikeNameLb;
}

- (LeftTriangle *)leftTri
{
    if (!_leftTri)
    {
        _leftTri = [[LeftTriangle alloc] initWithFrame:CGRectZero WithColor:[UIColor whiteColor] colorBorderColor:[UIColor whiteColor]];
    }
    return _leftTri;
}
@end
