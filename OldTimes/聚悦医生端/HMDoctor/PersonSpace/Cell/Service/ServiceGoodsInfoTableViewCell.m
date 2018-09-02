//
//  ServiceGoodsInfoTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 16/11/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ServiceGoodsInfoTableViewCell.h"
#import "ServiceScannerButton.h"

@interface ServiceGoodsInfoTableViewCell ()
{
    UIView* serviceView;
    UIImageView* ivService;
    UILabel* lbServiceName;
    UILabel* lbPrice;
    UILabel* lbCostPrice;
    UILabel* lbDesc;
    UIImageView* serviceLevelIcon;
    ServiceScannerButton* scanerButton;
}
@end

@implementation ServiceGoodsInfoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        serviceView = [[UIView alloc]init];
        [self.contentView addSubview:serviceView];
        [serviceView setBackgroundColor:[UIColor whiteColor]];
        serviceView.layer.borderWidth = 0.5;
        serviceView.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        serviceView.layer.cornerRadius = 5;
        serviceView.layer.masksToBounds = YES;
        
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
        
        ivService = [[UIImageView alloc]init];
        [serviceView addSubview:ivService];
        [ivService setImage:[UIImage imageNamed:@"icon_service_default"]];
        
        lbServiceName = [[UILabel alloc]init];
        [serviceView addSubview:lbServiceName];
        [lbServiceName setBackgroundColor:[UIColor clearColor]];
        [lbServiceName setFont:[UIFont font_30]];
        [lbServiceName setTextColor:[UIColor commonTextColor]];
        
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
        
        scanerButton = [[ServiceScannerButton alloc] init];
        [serviceView addSubview:scanerButton];
        self.scanButton = scanerButton;

        serviceLevelIcon = [[UIImageView alloc] init];
        [serviceView addSubview:serviceLevelIcon];
        [serviceLevelIcon setImage:[UIImage imageNamed:@"icon_value_added2"]];
        
        [self subviewsLayout];
    }
    return self;
}

- (void)subviewsLayout
{
    [serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.top.equalTo(self.contentView).with.offset(5);
        make.bottom.equalTo(self.contentView);
    }];
    
    [ivService mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(54);
        make.left.equalTo(serviceView).with.offset(10);
        make.top.equalTo(serviceView).with.offset(10);
    }];
    
    [lbServiceName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivService.mas_right).with.offset(10);
        make.height.mas_equalTo(@20);
        make.top.equalTo(serviceView).with.offset(13);
        make.right.lessThanOrEqualTo(serviceView).with.offset(-12);
    }];
    
    [lbDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbServiceName);
        make.top.equalTo(lbServiceName.mas_bottom).with.offset(10);
        make.right.lessThanOrEqualTo(serviceView).with.offset(-12);
        make.bottom.lessThanOrEqualTo(serviceView).with.offset(-46);
    }];
    
    [lbPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbServiceName);
        make.height.mas_equalTo(@24);
        make.top.equalTo(serviceView).with.offset(70);
        
    }];
    
    [lbCostPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbPrice.mas_right).with.offset(10);
        make.height.mas_equalTo(@15);
        make.bottom.equalTo(lbPrice).with.offset(-1.5);
    }];
    
    [serviceLevelIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(serviceView);
        make.width.mas_equalTo(@47);
        make.height.mas_equalTo(@42);
        make.bottom.equalTo(serviceView.mas_bottom);
    }];
    
    [scanerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivService);
        make.bottom.equalTo(lbCostPrice.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(54, 40));
    }];
}

- (void) setServiceGoodsInfo:(ServiceInfo*) service
{
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
    
    [lbServiceName setText:service.productName];
    
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
}


@end
