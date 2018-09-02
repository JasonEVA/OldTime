//
//  OrderListTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OrderListTableViewCell.h"

@interface OrderListTableViewCell ()
{
    UIImageView* ivOrder;
    UILabel* lbOrderName;
    UILabel* lbCreateTime;
    UILabel* lbStatus;
    UILabel* lbAmount;
    UILabel* lbUnit;
}
@end

@implementation OrderListTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ivOrder = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_default"]];
        [self.contentView addSubview:ivOrder];
        ivOrder.layer.borderWidth = 1;
        ivOrder.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        ivOrder.layer.cornerRadius = 20;
        ivOrder.layer.masksToBounds = YES;
        
        lbOrderName = [[UILabel alloc]init];
        [lbOrderName setFont:[UIFont font_30]];
        [lbOrderName setTextColor:[UIColor commonTextColor]];
        [self.contentView addSubview:lbOrderName];
        
        lbCreateTime = [[UILabel alloc]init];
        [lbCreateTime setFont:[UIFont font_22]];
        [lbCreateTime setTextColor:[UIColor commonGrayTextColor]];
        [self.contentView addSubview:lbCreateTime];
        
        lbStatus = [[UILabel alloc]init];
        [lbStatus setFont:[UIFont font_22]];
        [lbStatus setTextColor:[UIColor commonGrayTextColor]];
        [self.contentView addSubview:lbStatus];
        
        lbAmount = [[UILabel alloc]init];
        [lbAmount setFont:[UIFont font_30]];
        [lbAmount setTextColor:[UIColor commonRedColor]];
        [self.contentView addSubview:lbAmount];
        [lbAmount setText:@"￥0.00"];
        
        lbUnit = [[UILabel alloc]init];
        [lbUnit setFont:[UIFont font_24]];
        [lbUnit setTextColor:[UIColor commonRedColor]];
        [self.contentView addSubview:lbUnit];
        [lbUnit setText:@"元"];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [ivOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.centerY.equalTo(self.contentView);
    }];
    
    [lbAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(lbUnit.mas_left);
    }];
    
    [lbUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.bottom.equalTo(lbAmount.mas_bottom);
    }];
    
    [lbOrderName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivOrder.mas_right).with.offset(10);
        make.top.equalTo(ivOrder);
        make.right.lessThanOrEqualTo(lbAmount.mas_left).offset(-5);
    }];
    
    [lbCreateTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbOrderName);
        make.top.equalTo(lbOrderName.mas_bottom).with.offset(7);
    }];
    
    [lbStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbCreateTime.mas_right).with.offset(6);
        make.top.equalTo(lbCreateTime);
    }];
    
    
}

- (void) setOrderInfo:(OrderInfo*) order
{
    [ivOrder setImage:[UIImage imageNamed:@"img_default"]];
    [lbOrderName setText:@""];
    [lbCreateTime setText:@""];
    [lbStatus setText:@""];
    [lbAmount setText:@"￥0.00"];
    if (!order)
    {
        return;
    }
    
    if (order.imgUrl)
    {
        [ivOrder sd_setImageWithURL:[NSURL URLWithString:order.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default"]];
    }
    
    [lbOrderName setText:order.orderName];
    
    [lbAmount setText:[NSString stringWithFormat:@"￥%.2f", order.orderMoney]];
    
    NSDate* dateCreate = [NSDate dateWithString:order.createTime formatString:@"yyyy-MM-dd HH:mm:ss" ];
    NSString* dateStr = [dateCreate formattedDateWithFormat:@"yyyy-MM-dd"];
    [lbCreateTime setText:dateStr];
    
    [lbStatus setText:order.orderStatusName];
}
@end
