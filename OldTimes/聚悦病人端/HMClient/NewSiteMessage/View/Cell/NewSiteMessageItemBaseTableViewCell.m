//
//  NewSiteMessageItemBaseTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2016/11/1.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteMessageItemBaseTableViewCell.h"

@implementation NewSiteMessageItemBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView addSubview:self.receiveTimeLb];
        [self.contentView addSubview:self.cardView];
        
        [self.cardView addSubview:self.line];
        [self.cardView addSubview:self.titelLb];
        [self.cardView addSubview:self.subTitelLb];
        [self.cardView addSubview:self.typeImage];
        [self.cardView addSubview:self.rightBtn];
        
        [self baseConfigElements];
        
    }
    return self;
}


#pragma mark -private method
- (void)baseConfigElements {
    
    [self.receiveTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(15);
        make.height.equalTo(@20);
    }];
    
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.receiveTimeLb.mas_bottom).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView).offset(15);
        make.left.equalTo(self.cardView).offset(10);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.typeImage);
        make.right.equalTo(self.cardView).offset(-10);
        make.width.equalTo(@86);
        make.height.equalTo(@32);
    }];
    
    [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeImage);
        make.left.equalTo(self.typeImage.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.rightBtn.mas_left).offset(-15);
    }];
    
    [self.subTitelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titelLb.mas_bottom).offset(6);
        make.left.equalTo(self.titelLb);
        make.right.lessThanOrEqualTo(self.rightBtn.mas_left).offset(-5);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.cardView);
        make.bottom.equalTo(self.typeImage.mas_bottom).offset(15);
        make.top.equalTo(self.cardView);
    }];

}
#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
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
- (UILabel *)titelLb
{
    if (!_titelLb) {
        _titelLb = [self getLebalWithTitel:@"随访" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"999999"]];
    }
    return _titelLb;
}

- (UILabel *)subTitelLb
{
    if (!_subTitelLb) {
        _subTitelLb = [self getLebalWithTitel:@"请及时联系专家" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"333333"]];
    }
    return _subTitelLb;
}

- (UIImageView *)typeImage
{
    if (!_typeImage) {
        _typeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_jiance"]];
    }
    return _typeImage;
}
- (UIImageView *)line
{
    if (!_line) {
        _line = [UIImageView new];
        [_line setImage:[UIImage imageNamed:@"siteMessage_back"]];
    }
    return _line;
}

- (UILabel *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UILabel new];
        [_rightBtn setText:@"记录健康"];
        [_rightBtn setFont:[UIFont systemFontOfSize:16]];
        [_rightBtn setTextColor:[UIColor colorWithHexString:@"31c9ba"]];
        [_rightBtn.layer setCornerRadius:3];
        [_rightBtn setClipsToBounds:YES];
        [_rightBtn.layer setBorderWidth:0.5];
        [_rightBtn.layer setBorderColor:[[UIColor colorWithHexString:@"31c9ba"] CGColor]];
        [_rightBtn setTextAlignment:NSTextAlignmentCenter];
    }
    return _rightBtn;
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
