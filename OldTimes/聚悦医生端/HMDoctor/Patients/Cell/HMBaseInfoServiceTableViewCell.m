//
//  HMBaseInfoServiceTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 2017/3/21.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMBaseInfoServiceTableViewCell.h"

@interface HMBaseInfoServiceTableViewCell ()

@property (nonatomic, strong) UILabel *serviceDateLabel;
@property (nonatomic, strong) UILabel *serviceTeamLabel;
@property (nonatomic, strong) UILabel *serviceNameLabel;
@property (nonatomic, strong) UILabel *serviceMoneyLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@end

@implementation HMBaseInfoServiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.serviceNameLabel];
        [self.contentView addSubview:self.serviceTeamLabel];
        [self.contentView addSubview:self.serviceMoneyLabel];
        [self.contentView addSubview:self.serviceDateLabel];
        [self.contentView addSubview:self.moneyLabel];
        
        [self configElements];
    }
    return self;
}

- (void)configElements{
    
    [_serviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12);
    }];
    
    [_serviceTeamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_serviceNameLabel.mas_left);
        make.top.equalTo(_serviceNameLabel.mas_bottom).offset(8);
    }];
    
    [_serviceMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_serviceNameLabel.mas_left);
        make.top.equalTo(_serviceTeamLabel.mas_bottom).offset(8);
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_serviceMoneyLabel.mas_right).offset(5);
        make.top.equalTo(_serviceMoneyLabel);
    }];
    
    [_serviceDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_serviceNameLabel.mas_left);
        make.top.equalTo(_serviceMoneyLabel.mas_bottom).offset(8);
    }];
}

- (void)setServiceInfo:(HMThirdEditionPatitentInfoModel *)model
{
    if (!kStringIsEmpty(model.serviceName)) {
        [_serviceNameLabel setText:[NSString stringWithFormat:@"套餐名称：%@",model.serviceName]];
    }

    if (!kStringIsEmpty(model.teamName)) {
        [_serviceTeamLabel setText:[NSString stringWithFormat:@"服务团队：%@",model.teamName]];
    }

    if (!kStringIsEmpty(model.serviceMoney)) {
        [_moneyLabel setText:[NSString stringWithFormat:@"%@元",model.serviceMoney]];
    }
    
    if (!kStringIsEmpty(model.serviceEndDate)) {
        [_serviceDateLabel setText:[NSString stringWithFormat:@"到期时间：%@",model.serviceEndDate]];
    }
}

#pragma mark - init UI
- (UILabel *)serviceDateLabel {
    if (!_serviceDateLabel) {
        _serviceDateLabel = [UILabel new];
        [_serviceDateLabel setFont:[UIFont font_28]];
        [_serviceDateLabel setTextColor:[UIColor commonGrayTextColor]];
        [_serviceDateLabel setText:@"到期时间："];
    }
    return _serviceDateLabel;
}

- (UILabel *)serviceNameLabel {
    if (!_serviceNameLabel) {
        _serviceNameLabel = [UILabel new];
        [_serviceNameLabel setFont:[UIFont font_28]];
        [_serviceNameLabel setTextColor:[UIColor commonGrayTextColor]];
        [_serviceNameLabel setNumberOfLines:0];
        [_serviceNameLabel setText:@"套餐名称："];
    }
    return _serviceNameLabel;
}

- (UILabel *)serviceTeamLabel {
    if (!_serviceTeamLabel) {
        _serviceTeamLabel = [UILabel new];
        [_serviceTeamLabel setFont:[UIFont font_28]];
        [_serviceTeamLabel setTextColor:[UIColor commonGrayTextColor]];
        [_serviceTeamLabel setNumberOfLines:0];
        [_serviceTeamLabel setText:@"服务团队："];
    }
    return _serviceTeamLabel;
}

- (UILabel *)serviceMoneyLabel {
    if (!_serviceMoneyLabel) {
        _serviceMoneyLabel = [UILabel new];
        [_serviceMoneyLabel setFont:[UIFont font_28]];
        [_serviceMoneyLabel setTextColor:[UIColor commonGrayTextColor]];
        [_serviceMoneyLabel setNumberOfLines:0];
        [_serviceMoneyLabel setText:@"价格："];
    }
    return _serviceMoneyLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        [_moneyLabel setFont:[UIFont font_28]];
        [_moneyLabel setTextColor:[UIColor commonRedColor]];
        [_moneyLabel setNumberOfLines:0];
        //[_serviceMoneyLabel setText:@"价格："];
    }
    return _moneyLabel;
}

@end
