//
//  OrderUserServiceTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OrderUserServiceTableViewCell.h"

@interface OrderUserServiceTableViewCell ()
{
    UIImageView* ivService;
    UILabel* lbServiceName;
    UILabel* lbProviderTitle;
    UILabel* lbBillwayTitle;
    UILabel* lbProvider;
    UILabel* lbBillway;
}
@end

@implementation OrderUserServiceTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ivService = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_default"]];
        [self.contentView addSubview:ivService];
        ivService.layer.borderWidth = 1;
        ivService.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        ivService.layer.cornerRadius = 20;
        ivService.layer.masksToBounds = YES;
        
        lbServiceName = [[UILabel alloc]init];
        [self.contentView addSubview:lbServiceName];
        [lbServiceName setTextColor:[UIColor commonTextColor]];
        [lbServiceName setFont:[UIFont font_30]];
        
        lbProviderTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbProviderTitle];
        [lbProviderTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbProviderTitle setFont:[UIFont font_24]];
        [lbProviderTitle setText:@"医生团队:"];
        
        lbBillwayTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbBillwayTitle];
        [lbBillwayTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbBillwayTitle setFont:[UIFont font_24]];
        [lbBillwayTitle setText:@"服务期限:"];
        
        lbProvider = [[UILabel alloc]init];
        [self.contentView addSubview:lbProvider];
        [lbProvider setTextColor:[UIColor commonGrayTextColor]];
        [lbProvider setFont:[UIFont font_24]];
        
        lbBillway = [[UILabel alloc]init];
        [self.contentView addSubview:lbBillway];
        [lbBillway setTextColor:[UIColor commonGrayTextColor]];
        [lbBillway setFont:[UIFont font_24]];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [ivService mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(self.contentView).with.offset(15);
    }];
    
    [lbServiceName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivService.mas_right).with.offset(8);
        make.top.equalTo(ivService);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
    }];
    
    [lbProviderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbServiceName);
        make.top.equalTo(lbServiceName.mas_bottom).with.offset(3);
    }];
    
    [lbBillwayTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbProviderTitle);
        make.top.equalTo(lbProviderTitle.mas_bottom).with.offset(3);
    }];
    
    [lbProvider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbProviderTitle.mas_right);
        make.top.equalTo(lbProviderTitle);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
    }];
    
    [lbBillway mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbBillwayTitle.mas_right);
        make.top.equalTo(lbBillwayTitle);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
    }];
}

- (void) setUserService:(UserServiceInfo*) userService
{
    if (!userService)
    {
        return;
    }
    
    [ivService sd_setImageWithURL:[NSURL URLWithString:userService.imageUrl] placeholderImage:[UIImage imageNamed:@"img_default"]];
    [lbServiceName setText:userService.serviceName];
    [lbProvider setText:userService.providerName];
    [lbBillway setText:[NSString stringWithFormat:@"%ld%@", userService.billWayNum, userService.billWayName]];
}
@end
