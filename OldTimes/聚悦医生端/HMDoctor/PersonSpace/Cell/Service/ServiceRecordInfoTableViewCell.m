//
//  ServiceRecordInfoTableViewCell.m
//  HMDoctor
//
//  Created by yinqaun on 16/7/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ServiceRecordInfoTableViewCell.h"

@interface ServiceRecordInfoTableViewCell ()
{
    UIView* serviceview;
    UILabel* lbServiceName;
    UILabel* lbUserName;
    UILabel* lbOrderTime;
    
    UILabel* lbDuration;
}
@end

@implementation ServiceRecordInfoTableViewCell

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
        
        [serviceview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.right.equalTo(self.contentView).with.offset(-12.5);
            make.top.equalTo(self.contentView).with.offset(5);
            make.bottom.equalTo(self.contentView);
        }];
        
        lbServiceName = [[UILabel alloc]init];
        [serviceview addSubview:lbServiceName];
        [lbServiceName setBackgroundColor:[UIColor clearColor]];
        [lbServiceName setFont:[UIFont systemFontOfSize:15]];
        [lbServiceName setTextColor:[UIColor commonTextColor]];
        
        [lbServiceName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(serviceview).with.offset(10);
            make.height.mas_equalTo(@20);
            make.top.equalTo(serviceview).with.offset(13);
            make.right.lessThanOrEqualTo(serviceview).with.offset(-12);
        }];
        
        lbDuration = [[UILabel alloc]init];
        [serviceview addSubview:lbDuration];
        [lbDuration setBackgroundColor:[UIColor clearColor]];
        [lbDuration setFont:[UIFont systemFontOfSize:13]];
        [lbDuration setTextColor:[UIColor commonGrayTextColor]];
        [lbDuration setHidden:YES];
        
        [lbDuration mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(serviceview).with.offset(-10);
            make.bottom.equalTo(lbServiceName.mas_bottom);
        }];
        
        /*UILabel* lbDurationTitle = [[UILabel alloc]init];
        [serviceview addSubview:lbDurationTitle];
        [lbDurationTitle setBackgroundColor:[UIColor clearColor]];
        [lbDurationTitle setFont:[UIFont systemFontOfSize:13]];
        [lbDurationTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbDurationTitle setText:@"期限:"];
        
        [lbDurationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lbDuration.mas_left).with.offset(-2);
            make.bottom.equalTo(lbDuration);
        }];*/
        
        
        UILabel* lbUserNameTitle = [[UILabel alloc]init];
        [serviceview addSubview:lbUserNameTitle];
        [lbUserNameTitle setBackgroundColor:[UIColor clearColor]];
        [lbUserNameTitle setFont:[UIFont systemFontOfSize:13]];
        [lbUserNameTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbUserNameTitle setText:@"订购者:"];
        
        [lbUserNameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(serviceview).with.offset(10);
            make.top.equalTo(lbServiceName.mas_bottom).with.offset(10);
        }];
        
        lbUserName = [[UILabel alloc]init];
        [serviceview addSubview:lbUserName];
        [lbUserName setBackgroundColor:[UIColor clearColor]];
        [lbUserName setFont:[UIFont systemFontOfSize:13]];
        [lbUserName setTextColor:[UIColor commonGrayTextColor]];
        
        [lbUserName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbUserNameTitle.mas_right).with.offset(2);
            make.top.equalTo(lbUserNameTitle);
        }];
        
        UILabel* lbOrderTimeTitle = [[UILabel alloc]init];
        [serviceview addSubview:lbOrderTimeTitle];
        [lbOrderTimeTitle setBackgroundColor:[UIColor clearColor]];
        [lbOrderTimeTitle setFont:[UIFont systemFontOfSize:13]];
        [lbOrderTimeTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbOrderTimeTitle setText:@"订购时间:"];
        
        [lbOrderTimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(serviceview).with.offset(10);
            make.top.equalTo(lbUserNameTitle.mas_bottom).with.offset(10);
        }];
        
        lbOrderTime = [[UILabel alloc]init];
        [serviceview addSubview:lbOrderTime];
        [lbOrderTime setBackgroundColor:[UIColor clearColor]];
        [lbOrderTime setFont:[UIFont systemFontOfSize:13]];
        [lbOrderTime setTextColor:[UIColor commonGrayTextColor]];
        
        [lbOrderTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbOrderTimeTitle.mas_right).with.offset(2);
            make.top.equalTo(lbOrderTimeTitle);
        }];

    }
    return self;
}

- (void) setServiceRecord:(ServiceRecordInfo*) serviceRecord
{
    [lbServiceName setText:serviceRecord.PRODUCT_NAME];
    NSString* userName = serviceRecord.USER_NAME;
    if (0 < serviceRecord.AGE && serviceRecord.SEX)
    {
        userName = [userName stringByAppendingFormat:@"(%@|%ld岁)", serviceRecord.SEX, serviceRecord.AGE];
    }
    [lbUserName setText:userName];
    
    NSDate* orderDate = [NSDate dateWithString:serviceRecord.ORDER_TIME formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString* orderDateStr = serviceRecord.ORDER_TIME;
    if (orderDate)
    {
        orderDateStr = [orderDate formattedDateWithFormat:@"yyyy-MM-dd"];
    }
    [lbOrderTime setText:orderDateStr];
    
    //true实物商品
    if (!serviceRecord.physicalFlag) {
        [lbDuration setHidden:NO];
        [lbDuration setText:[NSString stringWithFormat:@"期限：%ld%@", serviceRecord.BILL_WAY_NUM, serviceRecord.BILL_WAY_NAME]];
    }
    else{
        [lbDuration setHidden:YES];
    }

}

@end
