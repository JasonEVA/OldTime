//
//  ServiceOrderConfirmInfoTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceOrderConfirmInfoTableViewCell.h"

@interface ServiceOrderConfirmInfoTableViewCell ()
{
    UILabel* lbServiceName;
    UILabel* lbProvider;
    UILabel* lbDuration;
}
@end

@implementation ServiceOrderConfirmInfoTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbServiceName = [[UILabel alloc]init];
        [self.contentView addSubview:lbServiceName];
        [lbServiceName setTextColor:[UIColor commonTextColor]];
        [lbServiceName setFont:[UIFont font_30]];
        
        [lbServiceName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.right.equalTo(self.contentView).with.offset(-12.5);
            make.top.equalTo(self.contentView).with.offset(8);
        }];
        
        UILabel* lbProviderName = [[UILabel alloc]init];
        [self.contentView addSubview:lbProviderName];
        [lbProviderName setTextColor:[UIColor commonGrayTextColor]];
        [lbProviderName setFont:[UIFont font_24]];
        [lbProviderName setText:@"提供者:"];
        [lbProviderName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbServiceName);
            make.top.equalTo(lbServiceName.mas_bottom).with.offset(2);
        }];
        
        lbProvider = [[UILabel alloc]init];
        [self.contentView addSubview:lbProvider];
        [lbProvider setTextColor:[UIColor commonGrayTextColor]];
        [lbProvider setFont:[UIFont font_24]];
        
        [lbProvider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbProviderName.mas_right);
            make.top.equalTo(lbServiceName.mas_bottom).with.offset(2);
        }];
        
        UILabel* lbDurationName = [[UILabel alloc]init];
        [self.contentView addSubview:lbDurationName];
        [lbDurationName setTextColor:[UIColor commonGrayTextColor]];
        [lbDurationName setFont:[UIFont font_24]];
        [lbDurationName setText:@"服务期限:"];
        [lbDurationName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbServiceName);
            make.top.equalTo(lbProviderName.mas_bottom).with.offset(2);
        }];
        
        lbDuration = [[UILabel alloc]init];
        [self.contentView addSubview:lbDuration];
        [lbDuration setTextColor:[UIColor commonGrayTextColor]];
        [lbDuration setFont:[UIFont font_24]];
        
        [lbDuration mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbDurationName.mas_right);
            make.top.equalTo(lbProviderName.mas_bottom).with.offset(2);
        }];
    }
    return self;
}

- (void) setServiceDetail:(ServiceDetail*) serviceDetail
{
    [lbServiceName setText:serviceDetail.comboName];
    [lbProvider setText:serviceDetail.mainProviderName];
    [lbDuration setText:[NSString stringWithFormat:@"%ld%@", serviceDetail.comboBillWayNum, serviceDetail.comboBillWayName]];
}
@end

@interface ServiceOrderConfirmPriceTableViewCell ()
{
    UILabel* lbPrice;
}
@end

@implementation ServiceOrderConfirmPriceTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"FDFEEE"]];
        UIImageView* ivIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_order_money"]];
        [self.contentView addSubview:ivIcon];
        [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(20, 23));
        }];
        
        UILabel* lbPriceName = [[UILabel alloc]init];
        [self.contentView addSubview:lbPriceName];
        [lbPriceName setTextColor:[UIColor commonTextColor]];
        [lbPriceName setText:@"需支付:"];
        [lbPriceName setFont:[UIFont font_26]];
        [lbPriceName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ivIcon.mas_right).with.offset(5);
            make.centerY.equalTo(self.contentView);
        }];
        
        UILabel* lbPriceSymbol = [[UILabel alloc]init];
        [self.contentView addSubview:lbPriceSymbol];
        [lbPriceSymbol setTextColor:[UIColor commonTextColor]];
        [lbPriceSymbol setText:@"￥"];
        [lbPriceSymbol setFont:[UIFont font_28]];
        [lbPriceSymbol mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbPriceName.mas_right).with.offset(5);
            make.bottom.equalTo(lbPriceName.mas_bottom);
        }];
        
        lbPrice = [[UILabel alloc]init];
        [self.contentView addSubview:lbPrice];
        [lbPrice setTextColor:[UIColor commonRedColor]];
        [lbPrice setFont:[UIFont font_32]];
        [lbPrice setText:@"0.00"];
        [lbPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbPriceSymbol.mas_right);
            make.centerY.equalTo(self.contentView);
        }];
        
        UILabel* lbPriceUnit = [[UILabel alloc]init];
        [self.contentView addSubview:lbPriceUnit];
        [lbPriceUnit setText:@"元"];
        [lbPriceUnit setFont:[UIFont font_26]];
        [lbPriceUnit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbPrice.mas_right);
            make.bottom.equalTo(lbPriceName.mas_bottom);
        }];
    }
    return self;
}

- (void) setServicePrice:(float) servicePrice
{
    [lbPrice setText:[NSString stringWithFormat:@"%.2f", servicePrice]];
    
}

@end

@interface ServiceOrderConfirmPaywayTableViewCell ()
{
    UIImageView* ivIcon;
    UILabel* lbPayway;
    UIImageView* ivSelected;
}
@end

@implementation ServiceOrderConfirmPaywayTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ivIcon = [[UIImageView alloc]init];
        [self.contentView addSubview:ivIcon];
        [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(12.5);
        }];
        
        lbPayway = [[UILabel alloc]init];
        [self.contentView addSubview:lbPayway];
        [lbPayway setTextColor:[UIColor commonTextColor]];
        [lbPayway setFont:[UIFont font_28]];
        [lbPayway mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ivIcon.mas_right).with.offset(9);
            make.centerY.equalTo(self.contentView);
        }];
        
        ivSelected = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_pay_hit"]];
        [self.contentView addSubview:ivSelected];
        [ivSelected mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(17, 17));
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).with.offset(-12.5);
        }];

        [ivSelected setHidden:YES];
    }
    
    return self;
}

- (void) setPayway:(ServicePayWay*) payway
{
    [lbPayway setText:payway.payWayName];
    
    [ivIcon setImage:nil];
    NSString* imgName = @"icon_pay_aliPay";
    if (!payway.payWayCode || 0 == payway.payWayCode.length) {
        
        return;
    }
    if ([payway.payWayCode isEqualToString:@"ZFB"])
    {
        imgName = @"icon_pay_aliPay";
    }
    else if ([payway.payWayCode isEqualToString:@"WXZF"])
    {
        imgName = @"icon_pay_tiny";
    }
    
    [ivIcon setImage:[UIImage imageNamed:imgName]];
}

- (void) setIsSelected:(BOOL) isSelected
{
    [ivSelected setHidden:!isSelected];
}
@end
