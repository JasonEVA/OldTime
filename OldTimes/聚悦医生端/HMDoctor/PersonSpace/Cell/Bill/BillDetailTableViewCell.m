//
//  BillDetailTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 16/6/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "BillDetailTableViewCell.h"

@interface BillDetailTableViewCell ()
{
    UILabel *lbPatient;
    UILabel *lbPatientValue;
    UILabel *lbCreateDate;
    UILabel *lbCreateDateValue;
}
@end

@implementation BillDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbPatient = [[UILabel alloc] init];
        [self addSubview:lbPatient];
        [lbPatient setText:@"用户信息"];
        [lbPatient setTextColor:[UIColor commonTextColor]];
        [lbPatient setFont:[UIFont systemFontOfSize:15]];
        
        lbPatientValue = [[UILabel alloc] init];
        [self addSubview:lbPatientValue];
        [lbPatientValue setText:@"zhangsan"];
        [lbPatientValue setTextColor:[UIColor commonGrayTextColor]];
        [lbPatientValue setFont:[UIFont systemFontOfSize:15]];

        lbCreateDate = [[UILabel alloc] init];
        [self addSubview:lbCreateDate];
        [lbCreateDate setText:@"创建时间"];
        [lbCreateDate setTextColor:[UIColor commonTextColor]];
        [lbCreateDate setFont:[UIFont systemFontOfSize:15]];
        
        lbCreateDateValue = [[UILabel alloc] init];
        [self addSubview:lbCreateDateValue];
        [lbCreateDateValue setText:@"2016-06-15 12:39"];
        [lbCreateDateValue setTextColor:[UIColor commonGrayTextColor]];
        [lbCreateDateValue setFont:[UIFont systemFontOfSize:15]];
        
        [self subviewsLayout];
    }
    return self;
}

- (void) subviewsLayout
{
    [lbPatient mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(self).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [lbPatientValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbPatient.mas_right).with.offset(10);
        make.top.equalTo(self).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [lbCreateDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(lbPatient.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [lbCreateDateValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbCreateDate.mas_right).with.offset(10);
        make.top.equalTo(lbPatient.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
}

- (void)setBillDetailInfo:(BillInfo *)billinfo
{
    [lbPatientValue setText:billinfo.USER_NAME];
    [lbCreateDateValue setText:billinfo.DIVIDE_TIME];
}

@end

@interface BillMoneyTableViewCell ()
{
    UILabel *lbMoney;
}
@end

@implementation BillMoneyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbMoney = [[UILabel alloc] init];
        [self addSubview:lbMoney];
        [lbMoney setText:@"+48.00"];
        [lbMoney setTextColor:[UIColor commonTextColor]];
        [lbMoney setFont:[UIFont systemFontOfSize:24]];
        
        [lbMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];
    }
    return self;
}

- (void)setBillDetailInfo:(BillInfo *)billinfo
{
    [lbMoney setText:[NSString stringWithFormat:@"+%@",billinfo.DIVIDE_MONEY]];
}

@end

@interface BillServiceNameTableViewCell ()
{
    UIImageView *ivImage;
    UILabel *lbServiceName;
}
@end

@implementation BillServiceNameTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ivImage = [[UIImageView alloc] init];
        [self addSubview:ivImage];
        
        [ivImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        lbServiceName = [[UILabel alloc] init];
        [self addSubview:lbServiceName];
        [lbServiceName setTextColor:[UIColor commonTextColor]];
        [lbServiceName setFont:[UIFont systemFontOfSize:15]];
        
        [lbServiceName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ivImage.mas_right).with.offset(10);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(150, 20));
        }];
    }
    return self;
}

- (void)setBillDetailInfo:(BillInfo *)billinfo
{
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [ivImage sd_setImageWithURL:[NSURL URLWithString:billinfo.LOGO] placeholderImage:[UIImage imageNamed:@"img_default"]];
    //[lbServiceName setText:@"高血压服务套餐"];
    [lbServiceName setText:billinfo.PRODUCT_NAME];
}

@end
