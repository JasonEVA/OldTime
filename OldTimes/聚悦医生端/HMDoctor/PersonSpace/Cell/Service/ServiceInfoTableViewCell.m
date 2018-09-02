//
//  ServiceInfoTableViewCell.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ServiceInfoTableViewCell.h"
#import "ServiceScannerButton.h"

@interface ServiceInfoTableViewCell ()
{
    UIView* serviceview;
    
    UIImageView* ivService;
    UILabel* lbServiceName;
    UIImageView* ivStar;
    NSMutableArray* ivStarArr;
    UILabel* lbProviderName;
    UILabel* lbProvider;
    UILabel* lbOrgName;
    UILabel* lbOrg;
    
    UILabel* lbPrice;
    UILabel* lbCostPrice;
    UILabel* lbDesc;
    //UIButton* scanerButton;
    UIImageView* serviceLevelIcon;
    ServiceScannerButton* scanerButton;
}
@end

@implementation ServiceInfoTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
        
        serviceview = [[UIView alloc]init];
        [serviceview setBackgroundColor:[UIColor whiteColor]];
        
        [self.contentView addSubview:serviceview];
        serviceview.layer.borderWidth = 0.5;
        serviceview.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        serviceview.layer.cornerRadius = 5;
        serviceview.layer.masksToBounds = YES;
        
        ivService = [[UIImageView alloc]init];
        [serviceview addSubview:ivService];
        [ivService setImage:[UIImage imageNamed:@"icon_service_default"]];
        
        lbServiceName = [[UILabel alloc]init];
        [serviceview addSubview:lbServiceName];
        [lbServiceName setBackgroundColor:[UIColor clearColor]];
        [lbServiceName setFont:[UIFont systemFontOfSize:15]];
        [lbServiceName setTextColor:[UIColor commonTextColor]];
        
        if (!ivStarArr) {
            
            ivStarArr = [[NSMutableArray alloc] init];
        }
        for (int i = 0; i < 5; i++)
        {
            ivStar = [[UIImageView alloc] init];
            [serviceview addSubview:ivStar];
            [ivStar setImage:[UIImage imageNamed:@"icon_37"]];
            [ivStarArr addObject:ivStar];
            
            [ivStar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(serviceview.mas_right).with.offset(-12-(i*15));
                make.top.equalTo(ivService);
                make.size.mas_equalTo(CGSizeMake(15, 15));
            }];
        }
        
        lbProviderName = [[UILabel alloc]init];
        [serviceview addSubview:lbProviderName];
        [lbProviderName setBackgroundColor:[UIColor clearColor]];
        [lbProviderName setFont:[UIFont systemFontOfSize:13]];
        [lbProviderName setTextColor:[UIColor commonGrayTextColor]];
        [lbProviderName setText:@"团队:"];
        
        lbProvider = [[UILabel alloc]init];
        [serviceview addSubview:lbProvider];
        [lbProvider setBackgroundColor:[UIColor clearColor]];
        [lbProvider setFont:[UIFont systemFontOfSize:13]];
        [lbProvider setTextColor:[UIColor commonGrayTextColor]];
        
        lbOrgName = [[UILabel alloc]init];
        [serviceview addSubview:lbOrgName];
        [lbOrgName setBackgroundColor:[UIColor clearColor]];
        [lbOrgName setFont:[UIFont systemFontOfSize:13]];
        [lbOrgName setTextColor:[UIColor commonGrayTextColor]];
        [lbOrgName setText:@"医院:"];
        
        lbOrg = [[UILabel alloc]init];
        [serviceview addSubview:lbOrg];
        [lbOrg setBackgroundColor:[UIColor clearColor]];
        [lbOrg setFont:[UIFont systemFontOfSize:13]];
        [lbOrg setTextColor:[UIColor commonGrayTextColor]];
        
        lbDesc = [[UILabel alloc]init];
        [serviceview addSubview:lbDesc];
        [lbDesc setBackgroundColor:[UIColor clearColor]];
        [lbDesc setFont:[UIFont systemFontOfSize:13]];
        [lbDesc setTextColor:[UIColor commonGrayTextColor]];
        
        lbPrice = [[UILabel alloc]init];
        [serviceview addSubview:lbPrice];
        [lbPrice setBackgroundColor:[UIColor clearColor]];
        [lbPrice setFont:[UIFont systemFontOfSize:18]];
        [lbPrice setTextColor:[UIColor colorWithHexString:@"FF6666"]];
        
        lbCostPrice = [[UILabel alloc]init];
        [serviceview addSubview:lbCostPrice];
        [lbCostPrice setBackgroundColor:[UIColor clearColor]];
        [lbCostPrice setFont:[UIFont systemFontOfSize:12]];
        [lbCostPrice setTextColor:[UIColor grayColor]];
        
        /*scanerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [serviceview addSubview:scanerButton];
        [scanerButton setTitle:@"查看二维码" forState:UIControlStateNormal];
        [scanerButton setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateNormal];
        [scanerButton.titleLabel setFont:[UIFont systemFontOfSize:11]];*/
        scanerButton = [[ServiceScannerButton alloc] init];
        [serviceview addSubview:scanerButton];
        self.scanButton = scanerButton;
        
        serviceLevelIcon = [[UIImageView alloc] init];
        [serviceview addSubview:serviceLevelIcon];

        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    
    [serviceview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.top.equalTo(self.contentView).with.offset(5);
        make.bottom.equalTo(self.contentView);
    }];
    
    [ivService mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(54);
        make.left.equalTo(serviceview).with.offset(10);
        make.top.equalTo(serviceview).with.offset(10);
    }];
    
    [lbServiceName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivService.mas_right).with.offset(10);
        make.height.mas_equalTo(@20);
        make.top.equalTo(serviceview).with.offset(13);
        make.right.lessThanOrEqualTo(serviceview).with.offset(-12);
    }];
    
    
    [lbOrgName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbServiceName);
        make.height.mas_equalTo(@19);
        make.top.equalTo(lbServiceName.mas_bottom).with.offset(4);
        
    }];
    
    [lbOrg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbOrgName.mas_right);
        make.height.mas_equalTo(@19);
        make.top.equalTo(lbOrgName);
        make.right.lessThanOrEqualTo(serviceview).with.offset(-12);
    }];
    
    [lbProviderName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbServiceName);
        make.height.mas_equalTo(@19);
        make.top.equalTo(lbOrgName.mas_bottom).with.offset(4);
        
    }];
    
    [lbProvider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbProviderName.mas_right);
        make.height.mas_equalTo(@19);
        make.top.equalTo(lbProviderName);
        make.right.lessThanOrEqualTo(serviceview).with.offset(-12);
    }];
    
    [lbDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbServiceName);
        make.top.equalTo(lbProviderName.mas_bottom).with.offset(4);
        make.right.lessThanOrEqualTo(serviceview).with.offset(-12);
        make.bottom.lessThanOrEqualTo(serviceview).with.offset(-46);
    }];
    
    [lbPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbServiceName);
        make.height.mas_equalTo(@24);
        make.top.equalTo(serviceview).with.offset(118);
        
    }];
    
    [lbCostPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbPrice.mas_right).with.offset(10);
        make.height.mas_equalTo(@15);
        make.bottom.equalTo(lbPrice).with.offset(-1.5);
    }];
    
    [scanerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivService);
        make.bottom.equalTo(lbPrice).with.offset(-1.5);
    }];
    
    [serviceLevelIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-12);
        make.width.mas_equalTo(@47);
        make.height.mas_equalTo(@42);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [scanerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivService);
        make.bottom.equalTo(lbCostPrice.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(54, 40));
    }];
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
         // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
        // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
        [ivService sd_setImageWithURL:[NSURL URLWithString:service.imgUrl] placeholderImage:[UIImage imageNamed:@"icon_service_default"]];
    }
    
    if (service.provider)
    {
        [lbProvider setText:service.provider];
    }
    
    [lbOrg setText:service.orgName];
    if (service.desc)
    {
        [lbDesc setText:[NSString stringWithFormat:@"介绍:%@", service.desc]];
    }
    else
    {
        [lbDesc setText:@"介绍:"];
    }
    
    if ([CommonFuncs isInteger:service.salePrice])
    {
        [lbPrice setText:[NSString stringWithFormat:@"￥%.ld元", (NSInteger) service.salePrice]];
        
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
