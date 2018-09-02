//
//  ServiceDetailTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceDetailTableViewCell.h"

@implementation ServiceDetailTableViewCell



- (void) setServiceDetail:(ServiceDetail*) detail
{
    
}

- (void) setServiceIsGoods:(BOOL) isGoods
{
    
}
@end

@interface ServiceDetailPriceTableViewCell ()
{
    UILabel* lbPrice;
    UILabel* lbCostPrice;
    UIImageView* ivStar;
    NSMutableArray* ivStarArr;
}
@end

@implementation ServiceDetailPriceTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbPrice = [[UILabel alloc]init];
        [self.contentView addSubview:lbPrice];
        [lbPrice setBackgroundColor:[UIColor clearColor]];
        [lbPrice setFont:[UIFont systemFontOfSize:18]];
        [lbPrice setTextColor:[UIColor colorWithHexString:@"FF6666"]];
        
        lbCostPrice = [[UILabel alloc]init];
        [self.contentView addSubview:lbCostPrice];
        [lbCostPrice setBackgroundColor:[UIColor clearColor]];
        [lbCostPrice setFont:[UIFont font_24]];
        [lbCostPrice setTextColor:[UIColor grayColor]];
        
        if (!ivStarArr) {
            ivStarArr = [[NSMutableArray alloc] init];
        }
        for (int i = 0; i < 5; i++)
        {
            ivStar = [[UIImageView alloc] init];
            [self.contentView addSubview:ivStar];
            [ivStar setImage:[UIImage imageNamed:@"icon_37"]];
            [ivStarArr addObject:ivStar];
            
            [ivStar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).with.offset(-12-(i*13));
                make.centerY.equalTo(self.contentView);
                make.size.mas_equalTo(CGSizeMake(15, 15));
            }];
        }
        
        [self subviewLayout];
    }
    
    return self;
}

- (void) subviewLayout
{
    [lbPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.centerY.equalTo(self.contentView);
        
    }];
    
    [lbCostPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbPrice.mas_right).with.offset(2);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void) setServiceIsGoods:(BOOL) isGoods
{
    [ivStarArr enumerateObjectsUsingBlock:^(UIImageView* imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageView setHidden:isGoods];
    }];
}



- (void) setServiceDetail:(ServiceDetail*) detail
{
    //服务详情
    
    NSInteger count = detail.grade/2;
    if (detail.grade%2 != 0)
    {
        count = detail.grade/2 +1;
    }
    
    for (int i = 0; i < count; i++)
    {
        UIImageView *starView = [ivStarArr objectAtIndex:4 - i];
        
        [starView setImage:[UIImage imageNamed:@"icon_38"]];
        if (detail.grade%2 != 0 && i == detail.grade/2)
        {
            [starView setImage:[UIImage imageNamed:@"icon_36"]];
        }
    }
    
    float salePrice = detail.salePrice;
    if (detail.selectMust)
    {
        for (ServiceDetailOption* option in detail.selectMust) {
            salePrice += option.salePrice;
        }
    }
    if ([CommonFuncs isInteger:detail.salePrice])
    {
        [lbPrice setText:[NSString stringWithFormat:@"￥%ld元", (NSInteger)salePrice]];
        
        if (detail.salePrice == 0)
        {
            [lbPrice setText:@"免费"];
        }
    }
    else
    {
        [lbPrice setText:[NSString stringWithFormat:@"￥%.2f元", salePrice]];
    }
   
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr;
    
    float markPrice = detail.salePrice;
    if (detail.selectMust)
    {
        for (ServiceDetailOption* option in detail.selectMust) {
            markPrice += option.salePrice;
        }
    }
    markPrice = detail.markPrice;
    if ([CommonFuncs isInteger:markPrice])
    {
        attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"原价:￥%ld", (NSInteger)markPrice] attributes:attribtDic];
    }
    else
    {
        attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"原价:￥%.2f", markPrice] attributes:attribtDic];
    }
    //NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"原价:￥%.2f", detail.rebate] attributes:attribtDic];
    
    lbCostPrice.attributedText = attribtStr;
}

@end

@interface ServiceDetailProviderTableViewCell ()
{
    UILabel* lbProvider;
    UILabel* lbProviderOrg;
}
@end

@implementation ServiceDetailProviderTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UILabel* lbName = [[UILabel alloc]init];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setFont:[UIFont font_26]];
        [lbName setTextColor:[UIColor commonTextColor]];
        [lbName setText:@"提供者:"];
        [self.contentView addSubview:lbName];
        [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(12.5);
        }];
        
        lbProvider = [[UILabel alloc]init];
        [lbProvider setBackgroundColor:[UIColor clearColor]];
        [lbProvider setFont:[UIFont font_26]];
        [lbProvider setTextColor:[UIColor commonTextColor]];
        [self.contentView addSubview:lbProvider];
        [lbProvider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(lbName.mas_right);
        }];
        
        UIImageView* icArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_x_arrows"]];
        [self.contentView addSubview:icArrow];
        [icArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).with.offset(-12.5);
            make.size.mas_equalTo(CGSizeMake(7, 14));
        }];
        
        lbProviderOrg = [[UILabel alloc]init];
        [lbProviderOrg setBackgroundColor:[UIColor clearColor]];
        [lbProviderOrg setFont:[UIFont font_24]];
        [lbProviderOrg setTextColor:[UIColor commonGrayTextColor]];
        [self.contentView addSubview:lbProviderOrg];
        [lbProviderOrg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(lbProvider.mas_right).with.offset(4);
            make.right.lessThanOrEqualTo(icArrow.mas_left).with.offset(-5);
        }];
        
        
    }
    return self;
}

- (void) setServiceDetail:(ServiceDetail*) detail
{
    if (!detail)
    {
        return;
    }
    [lbProvider setText:detail.mainProviderName];
    
    if (!kStringIsEmpty(detail.orgName)) {
        NSString* orgName = [NSString stringWithFormat:@"(%@)", detail.orgName];
        [lbProviderOrg setText:orgName];
    }

}
@end

@interface ServiceDetailBillWayTableViewCell ()
{
    UILabel* lbBillWay;
}
@end

@implementation ServiceDetailBillWayTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UILabel* lbName = [[UILabel alloc]init];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setFont:[UIFont font_26]];
        [lbName setTextColor:[UIColor commonTextColor]];
        [lbName setText:@"服务期限:"];
        [self.contentView addSubview:lbName];
        [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(12.5);
        }];
        
        lbBillWay = [[UILabel alloc]init];
        [lbBillWay setBackgroundColor:[UIColor clearColor]];
        [lbBillWay setFont:[UIFont font_26]];
        [lbBillWay setTextColor:[UIColor commonTextColor]];
        [self.contentView addSubview:lbBillWay];
        [lbBillWay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(lbName.mas_right);
        }];
    }
    return self;
}

- (void) setServiceDetail:(ServiceDetail*) detail
{
    if (!detail)
    {
        return;
    }
    [lbBillWay setText:[NSString stringWithFormat:@"%ld%@", detail.comboBillWayNum, detail.comboBillWayName]];
}
@end

@interface ServiceGoodsDetailBillWayTableViewCell ()
{
    UILabel* lbBillWay;
}
@end

@implementation ServiceGoodsDetailBillWayTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        
        lbBillWay = [[UILabel alloc]init];
        [lbBillWay setBackgroundColor:[UIColor clearColor]];
        [lbBillWay setFont:[UIFont font_26]];
        [lbBillWay setTextColor:[UIColor commonTextColor]];
        [self.contentView addSubview:lbBillWay];
        [lbBillWay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
        }];
    }
    return self;
}


- (void) setServiceDetail:(ServiceDetail*) detail
{
    if (!detail)
    {
        return;
    }
    [lbBillWay setText:[NSString stringWithFormat:@"%@%ld%@", detail.comboName, detail.comboBillWayNum, detail.comboBillWayName]];
}
@end


@interface ServiceDetailOptionTableViewCell ()
{
    UILabel* lbName;
    UILabel* lbBillWay;
}
@end

@implementation ServiceDetailOptionTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbName = [[UILabel alloc]init];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setFont:[UIFont font_26]];
        [lbName setTextColor:[UIColor commonGrayTextColor]];
        [self.contentView addSubview:lbName];
        [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(12.5);
        }];
        
        lbBillWay = [[UILabel alloc]init];
        [lbBillWay setBackgroundColor:[UIColor clearColor]];
        [lbBillWay setFont:[UIFont font_26]];
        [lbBillWay setTextColor:[UIColor commonTextColor]];
        [self.contentView addSubview:lbBillWay];
        [lbBillWay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).with.offset(-12.5);
        }];
    }
    return self;
}

- (void) setServiceOption:(ServiceDetailOption*) option
{
    [lbName setText:option.productName];
    if (option.billWayNum > 0) {
        [lbBillWay setText:[NSString stringWithFormat:@"%ld%@", option.billWayNum, option.billWayName]];
    }
    else
    {
        [lbBillWay setText:[NSString stringWithFormat:@"%@", option.billWayName]];
    }
    
}
@end

@interface ServiceDetailDescriptionTableViewCell ()
{
    UILabel* lbDesc;
}
@end

@implementation ServiceDetailDescriptionTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbDesc = [[UILabel alloc]init];
        [lbDesc setBackgroundColor:[UIColor clearColor]];
        [lbDesc setFont:[UIFont font_26]];
        [lbDesc setNumberOfLines:0];
        [lbDesc setTextColor:[UIColor commonGrayTextColor]];
        [self.contentView addSubview:lbDesc];
        [lbDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.top.equalTo(self.contentView).with.offset(10);
            
        }];
    }
    return self;
}

- (void) setServiceDetail:(ServiceDetail*) detail
{
    if (!detail)
    {
        return;
    }
    [lbDesc setText:detail.productDes];
}

@end
