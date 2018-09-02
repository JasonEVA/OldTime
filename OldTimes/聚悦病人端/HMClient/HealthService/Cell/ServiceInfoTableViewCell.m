//
//  ServiceInfoTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/4/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceInfoTableViewCell.h"

@interface ServiceInfoTableViewCell ()
{
    UIView* serviceView;
    UIImageView* ivService;
    UIImageView* ivStar;
    NSMutableArray* ivStarArr;
    UILabel* lbServiceName;
    UILabel* lbProviderName;
    UILabel* lbProvider;
    UILabel* lbDurationName;
    UILabel* lbDuration;

    UILabel* lbPrice;
    UILabel* lbCostPrice;
    UILabel* lbDesc;
//    UIButton* buyButton;
    UIImageView* serviceLevelIcon;
}
@end

@implementation ServiceInfoTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        serviceView = [[UIView alloc]init];
        [self.contentView addSubview:serviceView];
        [serviceView setBackgroundColor:[UIColor whiteColor]];
        
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
        
        ivService = [[UIImageView alloc]init];
        [serviceView addSubview:ivService];
        [ivService setImage:[UIImage imageNamed:@"icon_service_default"]];
        
        lbServiceName = [[UILabel alloc]init];
        [serviceView addSubview:lbServiceName];
        [lbServiceName setBackgroundColor:[UIColor clearColor]];
        [lbServiceName setFont:[UIFont font_30]];
        [lbServiceName setTextColor:[UIColor commonTextColor]];

        if (!ivStarArr) {
            
            ivStarArr = [[NSMutableArray alloc] init];
        }
        for (int i = 0; i < 5; i++)
        {
            ivStar = [[UIImageView alloc] init];
            [serviceView addSubview:ivStar];
            [ivStar setImage:[UIImage imageNamed:@"icon_37"]];
            [ivStarArr addObject:ivStar];
            
            [ivStar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).with.offset(-12-(i*13));
                make.top.equalTo(ivService);
                make.size.mas_equalTo(CGSizeMake(15, 15));
            }];
        }

        lbProviderName = [[UILabel alloc]init];
        [serviceView addSubview:lbProviderName];
        [lbProviderName setBackgroundColor:[UIColor clearColor]];
        [lbProviderName setFont:[UIFont font_24]];
        [lbProviderName setTextColor:[UIColor commonTextColor]];
        [lbProviderName setText:@"服务者:"];
        
        lbProvider = [[UILabel alloc]init];
        [serviceView addSubview:lbProvider];
        [lbProvider setBackgroundColor:[UIColor clearColor]];
        [lbProvider setFont:[UIFont font_24]];
        [lbProvider setTextColor:[UIColor commonTextColor]];
        
        lbDurationName = [[UILabel alloc]init];
        [serviceView addSubview:lbDurationName];
        [lbDurationName setBackgroundColor:[UIColor clearColor]];
        [lbDurationName setFont:[UIFont font_24]];
        [lbDurationName setTextColor:[UIColor commonTextColor]];
        [lbDurationName setText:@"服务期限:"];
        
        lbDuration = [[UILabel alloc]init];
        [serviceView addSubview:lbDuration];
        [lbDuration setBackgroundColor:[UIColor clearColor]];
        [lbDuration setFont:[UIFont font_24]];
        [lbDuration setTextColor:[UIColor commonTextColor]];
        
        lbDesc = [[UILabel alloc]init];
        [serviceView addSubview:lbDesc];
        [lbDesc setBackgroundColor:[UIColor clearColor]];
        [lbDesc setFont:[UIFont font_24]];
        [lbDesc setTextColor:[UIColor commonGrayTextColor]];
        [lbDesc setNumberOfLines:0];
        
        lbPrice = [[UILabel alloc]init];
        [serviceView addSubview:lbPrice];
        [lbPrice setBackgroundColor:[UIColor clearColor]];
        [lbPrice setFont:[UIFont systemFontOfSize:18]];
        [lbPrice setTextColor:[UIColor colorWithHexString:@"FF6666"]];

        lbCostPrice = [[UILabel alloc]init];
        [serviceView addSubview:lbCostPrice];
        [lbCostPrice setBackgroundColor:[UIColor clearColor]];
        [lbCostPrice setFont:[UIFont font_24]];
        [lbCostPrice setTextColor:[UIColor grayColor]];
        
        /*buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [serviceView addSubview:buyButton];
        [buyButton setBackgroundImage:[UIImage rectImage:CGSizeMake(120, 49) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [buyButton setTitle:@"我要购买" forState:UIControlStateNormal];
        [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buyButton.titleLabel setFont:[UIFont font_26]];
        [buyButton setHidden:YES];
        buyButton.layer.cornerRadius = 2.5;
        buyButton.layer.masksToBounds = YES;*/
        
        serviceLevelIcon = [[UIImageView alloc] init];
        [serviceView addSubview:serviceLevelIcon];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(-5);
    }];
    
    [ivService mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(33);
        make.left.equalTo(serviceView).with.offset(10);
        make.top.equalTo(serviceView).with.offset(10);
    }];
    
    [lbServiceName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivService.mas_right).with.offset(10);
        make.height.mas_equalTo(@20);
        make.top.equalTo(ivService);
        make.right.lessThanOrEqualTo(ivStar.mas_left).with.offset(-5);
    }];
    
    
    [lbDurationName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbServiceName);
        make.height.mas_equalTo(@19);
        make.top.equalTo(lbServiceName.mas_bottom).with.offset(2);
        
    }];
    
    [lbDuration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbDurationName.mas_right);
        make.height.mas_equalTo(@19);
        make.top.equalTo(lbDurationName);
        make.right.lessThanOrEqualTo(serviceView).with.offset(-12);
    }];
    
    [lbProviderName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbServiceName);
        make.height.mas_equalTo(@19);
        make.top.equalTo(lbDurationName.mas_bottom);
        
    }];
    
    [lbProvider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbProviderName.mas_right);
        make.height.mas_equalTo(@19);
        make.top.equalTo(lbProviderName);
        make.right.lessThanOrEqualTo(serviceView).with.offset(-12);
    }];

    [lbDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbServiceName);
        make.top.equalTo(lbProviderName.mas_bottom).with.offset(4);
        make.right.lessThanOrEqualTo(serviceView).with.offset(-12);
        make.bottom.lessThanOrEqualTo(serviceView).with.offset(-46);
    }];
    
    [lbPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbServiceName);
        make.height.mas_equalTo(@24);
        make.top.equalTo(serviceView).with.offset(114);
        
    }];
    
    [lbCostPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbPrice.mas_right).with.offset(10);
        make.height.mas_equalTo(@15);
        make.bottom.equalTo(lbPrice).with.offset(-1.5);
    }];
    
    [serviceLevelIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(serviceView).with.offset(-12);
        make.width.mas_equalTo(@47);
        make.height.mas_equalTo(@42);
        make.bottom.equalTo(serviceView.mas_bottom);
    }];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setServiceInfo:(ServiceInfo*) service isGrade:(BOOL)isgrade
{
    //提供的服务
    NSInteger count = service.grade/2;
    if (service.grade%2 != 0)
    {
        count = service.grade/2 +1;
    }
    
    if (isgrade)
    {
        for (int i = 0; i < count; i++)
        {
            UIImageView *starView = [ivStarArr objectAtIndex:4 - i];
            
            [starView setImage:[UIImage imageNamed:@"icon_38"]];
            if (service.grade%2 != 0 && i == service.grade/2)
            {
                [starView setImage:[UIImage imageNamed:@"icon_36"]];
            }
        }
    }else{
        for (int i = 0; i < 5 - count; i++)
        {
            UIImageView *starView = [ivStarArr objectAtIndex:4 - i];
            
            [starView setImage:[UIImage imageNamed:@"icon_37"]];
        }
    }

    [lbServiceName setText:service.productName];
    
    if (!service.imgUrl || 0 == service.imgUrl.length)
    {
        [ivService setImage:[UIImage imageNamed:@"icon_service_default"]];
    }
    else
    {
        [ivService sd_setImageWithURL:[NSURL URLWithString:service.imgUrl] placeholderImage:[UIImage imageNamed:@"icon_service_default"]];
    }
    
    NSString* provider = @"";
    if (service.provider)
    {
        provider = service.provider;
    }
    if (service.orgName && 0 < service.orgName.length)
    {
        provider = [provider stringByAppendingFormat:@"(%@)", service.orgName];
    }
    
    [lbProvider setText:provider];
    
    [lbDuration setText:[NSString stringWithFormat:@"%ld%@", service.billWayNum, service.billWayName]];
    [lbDesc setText:[NSString stringWithFormat:@"介绍:%@", service.desc]];
    if ([CommonFuncs isInteger:service.salePrice])
    {
        NSLog(@"salePrice %ld", (NSInteger) service.salePrice);
        [lbPrice setText:[NSString stringWithFormat:@"￥%ld元", (NSInteger) service.salePrice]];
        
        if ((NSInteger)service.salePrice == 0)
        {
            [lbPrice setText:@"免费"];
        }
    }
    else
    {
        [lbPrice setText:[NSString stringWithFormat:@"￥%.2f元", service.salePrice]];
    }
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr;
    if ([CommonFuncs isInteger:service.marketPrice])
    {
        attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"原价:￥%ld", (NSInteger)service.marketPrice] attributes:attribtDic];
    }
    else
    {
        attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"原价:￥%.2f", service.marketPrice] attributes:attribtDic];
    }
    
    
    lbCostPrice.attributedText = attribtStr;
    
    [self setServiceLevel:service.classify];
}

/*
 服务类型
 0单项商品1单项服务2套餐3基础服务4试用服务
 */
- (void) setServiceLevel:(NSInteger)serviceLevel
{
    NSString* imageName = nil;
    switch ((NSInteger)serviceLevel)
    {
        case 0:
        case 1:
        case 2:
            imageName = @"icon_vip";
            break;
            
        case 3:
            imageName = @"icon_jichu";
            break;
            
        case 4:
            imageName = @"icon_shiyong";
            break;
            
        case 5:
            imageName = @"icon_value_added2";
            break;
            
        default:
            break;
    }
    [serviceLevelIcon setImage:[UIImage imageNamed:imageName]];
}
@end
