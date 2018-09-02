//
//  BillInfoTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 16/6/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "BillInfoTableViewCell.h"

@interface TotalBillTableViewCell ()
{
    UILabel *lbMonth;
    UILabel *lbYear;
    UILabel *lbTotalMoney;
}
@end

@implementation TotalBillTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM"];
        NSString *currMonth = [formatter stringFromDate:[NSDate date]];
        
        [formatter setDateFormat:@"yyyy"];
        NSString *currYear = [formatter stringFromDate:[NSDate date]];
        
        lbMonth = [[UILabel alloc] init];
        [self addSubview:lbMonth];
        [lbMonth setText:currMonth];
        [lbMonth setTextColor:[UIColor commonTextColor]];
        [lbMonth setFont:[UIFont systemFontOfSize:17]];
        
        lbYear = [[UILabel alloc] init];
        [self addSubview:lbYear];
        [lbYear setText:[NSString stringWithFormat:@"月/%@",currYear]];
        [lbYear setTextColor:[UIColor commonGrayTextColor]];
        [lbYear setFont:[UIFont systemFontOfSize:14]];
        
        lbTotalMoney = [[UILabel alloc] init];
        [self addSubview:lbTotalMoney];
        [lbTotalMoney setText:@"¥ 0.00"];
        [lbTotalMoney setTextColor:[UIColor commonTextColor]];
        [lbTotalMoney setFont:[UIFont systemFontOfSize:17]];
        
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_iconBtn];
        [_iconBtn setBackgroundImage:[UIImage imageNamed:@"icon_bill_calendar"] forState:UIControlStateNormal];

        [self subViewsLayout];
    }

    return self;
}


- (void)subViewsLayout
{
    [lbYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbMonth.mas_right);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    
    [lbMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.bottom.equalTo(lbYear.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(21, 20));
    }];
    
    [lbTotalMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbYear.mas_right);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(94, 25));
    }];
    
    [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-13);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)setBillSum:(NSString *)billSum
{
    
    [lbTotalMoney setText:[NSString stringWithFormat:@"¥%.2f",billSum.floatValue]];
}

- (void)setTime:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSDate *inputDate = [formatter dateFromString:time];
    
    [formatter setDateFormat:@"MM"];
    NSString *currMonth = [formatter stringFromDate:inputDate];
    
    [formatter setDateFormat:@"yyyy"];
    NSString *currYear = [formatter stringFromDate:inputDate];
    
    [lbMonth setText:currMonth];
    [lbYear setText:[NSString stringWithFormat:@"月/%@",currYear]];
}

@end


@interface BillInfoTableViewCell ()
{
    UILabel *lbDay;
    UILabel *lbTime;
    UIImageView *ivIcon;
    UILabel *lbmoney;
    UILabel *lbServiceName;
}

@end

@implementation BillInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbDay = [[UILabel alloc] init];
        [self addSubview:lbDay];
        [lbDay setTextColor:[UIColor commonTextColor]];
        [lbDay setFont:[UIFont systemFontOfSize:14]];
        
        lbTime = [[UILabel alloc] init];
        [self addSubview:lbTime];
        [lbTime setTextColor:[UIColor commonGrayTextColor]];
        [lbTime setFont:[UIFont systemFontOfSize:14]];
        
        ivIcon = [[UIImageView alloc] init];
        [self addSubview:ivIcon];
        
        lbmoney = [[UILabel alloc] init];
        [self addSubview:lbmoney];
        [lbmoney setTextColor:[UIColor commonTextColor]];
        [lbmoney setFont:[UIFont systemFontOfSize:15]];
        
        lbServiceName = [[UILabel alloc] init];
        [self addSubview:lbServiceName];
        [lbServiceName setTextColor:[UIColor commonGrayTextColor]];
        [lbServiceName setFont:[UIFont systemFontOfSize:14]];
        
        [self subViewsLayout];
       
    }
    return self;
}

- (void)subViewsLayout
{
    [lbDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(self).with.offset(12);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    [lbTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(lbDay.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTime.mas_right).with.offset(15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [lbmoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivIcon.mas_right).with.offset(15);
        make.top.equalTo(self).with.offset(12);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [lbServiceName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbmoney.mas_left);
        make.top.equalTo(lbmoney.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
}

- (void) setBillInfoValue:(BillInfo *)billinfo
{
    //
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [formatter dateFromString:billinfo.DIVIDE_TIME];
    
    //天
    [formatter setDateFormat:@"dd"];
    NSString* dayStr = [formatter stringFromDate:inputDate];
    [lbDay setText:[NSString stringWithFormat:@"%@日",dayStr]];
    
    //时间
    [formatter setDateFormat:@"HH:mm"];
    NSString* timeStr = [formatter stringFromDate:inputDate];
    [lbTime setText:[NSString stringWithFormat:@"%@",timeStr]];
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [ivIcon sd_setImageWithURL:[NSURL URLWithString:billinfo.LOGO] placeholderImage:[UIImage imageNamed:@"img_default"]];
    
    [lbmoney setText:[NSString stringWithFormat:@"+%@",billinfo.DIVIDE_MONEY]];
    //[lbServiceName setText:@"高血压套餐服务"];
    [lbServiceName setText:[NSString stringWithFormat:@"%@/%@",billinfo.PRODUCT_PARENT_NAME,billinfo.PRODUCT_NAME]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@interface BillConfirmTableViewCell ()
{
    UILabel *lbConfirm;
}
@end

@implementation BillConfirmTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
        lbConfirm = [[UILabel alloc] init];
        [lbConfirm setBackgroundColor:[UIColor mainThemeColor]];
        [lbConfirm setFont:[UIFont systemFontOfSize:15]];
        [lbConfirm setText:@"确定账单"];
        [lbConfirm setTextColor:[UIColor whiteColor]];
        [lbConfirm setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:lbConfirm];
        
        lbConfirm.layer.borderColor = [[UIColor mainThemeColor] CGColor];
        lbConfirm.layer.borderWidth = 0.5;
        lbConfirm.layer.cornerRadius = 2.5;
        lbConfirm.layer.masksToBounds = YES;
        
        [self subviewsLayout];
    }
    return self;
}

- (void)subviewsLayout
{
    [lbConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.top.and.bottom.equalTo(self.contentView);
        //make.height.mas_equalTo(47);
    }];
}


@end
