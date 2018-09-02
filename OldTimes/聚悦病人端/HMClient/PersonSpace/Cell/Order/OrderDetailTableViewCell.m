//
//  OrderDetailTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OrderDetailTableViewCell.h"

@interface OrderDetailTableViewCell ()
{
    UILabel* lbOrderNo;
    UILabel* lbCreateTime;
    UILabel* lbStatus;
}
@end

@implementation OrderDetailTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UILabel* lbOrderNoTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbOrderNoTitle];
        [lbOrderNoTitle setText:@"订单编号:"];
        [lbOrderNoTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbOrderNoTitle setFont:[UIFont font_24]];
        
        [lbOrderNoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.top.equalTo(self.contentView).with.offset(11);
        }];
        
        lbOrderNo = [[UILabel alloc]init];
        [self.contentView addSubview:lbOrderNo];
        [lbOrderNo setTextColor:[UIColor commonGrayTextColor]];
        [lbOrderNo setFont:[UIFont font_24]];
        
        [lbOrderNo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbOrderNoTitle.mas_right);
            make.top.equalTo(lbOrderNoTitle);
        }];
        
        UILabel* lbCreateTimeTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbCreateTimeTitle];
        [lbCreateTimeTitle setText:@"下单时间:"];
        [lbCreateTimeTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbCreateTimeTitle setFont:[UIFont font_24]];
        
        [lbCreateTimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.top.equalTo(lbOrderNoTitle.mas_bottom).with.offset(3);
        }];
        
        lbCreateTime = [[UILabel alloc]init];
        [self.contentView addSubview:lbCreateTime];
        [lbCreateTime setTextColor:[UIColor commonGrayTextColor]];
        [lbCreateTime setFont:[UIFont font_24]];
        
        [lbCreateTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbCreateTimeTitle.mas_right);
            make.top.equalTo(lbCreateTimeTitle);
        }];
        
        UILabel* lbStatusTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbStatusTitle];
        [lbStatusTitle setText:@"订单状态:"];
        [lbStatusTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbStatusTitle setFont:[UIFont font_24]];
        
        [lbStatusTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.top.equalTo(lbCreateTimeTitle.mas_bottom).with.offset(3);
        }];
        
        lbStatus = [[UILabel alloc]init];
        [self.contentView addSubview:lbStatus];
        [lbStatus setTextColor:[UIColor commonGrayTextColor]];
        [lbStatus setFont:[UIFont font_24]];
        
        [lbStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbStatusTitle.mas_right);
            make.top.equalTo(lbStatusTitle);
        }];
    }
    return self;
}

- (void) setOrderInfo:(OrderInfo*) order
{
    [lbOrderNo setText:order.orderNo];
    [lbCreateTime setText:order.createTime];
    [lbStatus setText:order.orderStatusName];
}
@end

@interface OrderDetailNameTableViewCell ()
{
    UILabel* lbName;
}
@end

@implementation OrderDetailNameTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UILabel* lbProduct = [[UILabel alloc]init];
        [self.contentView addSubview:lbProduct];
        [lbProduct setTextColor:[UIColor commonTextColor]];
        [lbProduct setFont:[UIFont font_30]];
        [lbProduct setText:@"商品名称:"];
        
        [lbProduct mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(12.5);
        }];
        
        lbName = [[UILabel alloc]init];
        [self.contentView addSubview:lbName];
        [lbName setTextColor:[UIColor commonTextColor]];
        [lbName setFont:[UIFont font_30]];
        
        [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbProduct.mas_right).with.offset(3);
            make.centerY.equalTo(self.contentView);
            make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
        }];
    }
    return self;
}

- (void) setOrderName:(NSString*) orderName
{
    [lbName setText:orderName];
}
@end

@interface OrderDetailNumTableViewCell ()
{
    UILabel* lbNumber;
}
@end

@implementation OrderDetailNumTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UILabel* lbProduct = [[UILabel alloc]init];
        [self.contentView addSubview:lbProduct];
        [lbProduct setTextColor:[UIColor commonTextColor]];
        [lbProduct setFont:[UIFont font_30]];
        [lbProduct setText:@"购买数量:"];
        
        [lbProduct mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(12.5);
        }];
        
        lbNumber = [[UILabel alloc]init];
        [self.contentView addSubview:lbNumber];
        [lbNumber setTextColor:[UIColor commonTextColor]];
        [lbNumber setFont:[UIFont font_30]];
        
        [lbNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbProduct.mas_right).with.offset(3);
            make.centerY.equalTo(self.contentView);
            make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
        }];
    }
    return self;
}

- (void) setOrderNum:(NSInteger) orderNum
{
    [lbNumber setText:[NSString stringWithFormat:@"%ld", orderNum]];
}

@end

@interface OrderDetailAmountTableViewCell ()
{
    UILabel* lbAmount;
}
@end

@implementation OrderDetailAmountTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UILabel* lbProduct = [[UILabel alloc]init];
        [self.contentView addSubview:lbProduct];
        [lbProduct setTextColor:[UIColor commonTextColor]];
        [lbProduct setFont:[UIFont font_30]];
        [lbProduct setText:@"实付:"];
        
        [lbProduct mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(12.5);
        }];
        
        lbAmount = [[UILabel alloc]init];
        [self.contentView addSubview:lbAmount];
        [lbAmount setTextColor:[UIColor commonRedColor]];
        [lbAmount setFont:[UIFont font_30]];
        
        [lbAmount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbProduct.mas_right).with.offset(3);
            make.centerY.equalTo(self.contentView);
            make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
        }];
        [lbAmount setText:@"￥0.00"];
        
        UILabel* lbUnit = [[UILabel alloc]init];
        [self.contentView addSubview:lbUnit];
        [lbUnit setTextColor:[UIColor commonRedColor]];
        [lbUnit setFont:[UIFont font_30]];
        [lbUnit setText:@"元"];
        
        [lbUnit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(lbAmount.mas_right);
        }];
    }
    return self;
}

- (void) setOrderAmount:(CGFloat) amount
{
    [lbAmount setText:[NSString stringWithFormat:@"￥%.2f", amount]];
}
@end

@interface OrderDetailIntegalTableViewCell ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* integalLabel;

@end

@implementation OrderDetailIntegalTableViewCell

- (void) setIntegal:(NSInteger)integal
{
    [self.integalLabel setText:[NSString stringWithFormat:@"%ld分", integal]];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.integalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).with.offset(12.5);
        make.centerY.equalTo(self.contentView);
    }];
}

#pragma mark - settingAndGetting
- (UILabel*) titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_titleLabel setTextColor:[UIColor commonGrayTextColor]];
        [_titleLabel setText:@"积分奖励："];
    }
    return _titleLabel;
}

- (UILabel*) integalLabel
{
    if (!_integalLabel) {
        _integalLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_integalLabel];
        [_integalLabel setFont:[UIFont systemFontOfSize:15]];
        [_integalLabel setTextColor:[UIColor commonTextColor]];
        [_integalLabel setText:@"0分"];
    }
    return _integalLabel;
}

@end
