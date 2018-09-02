//
//  IMAlertMessageTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/6/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "IMAlertMessageTableViewCell.h"

@interface IMAlertMessageTableViewCell ()
{
    UIView* timeview;
    UILabel* lbSendTime;
    UIView* alertview;
    UILabel* lbAlert;
}
@end

@implementation IMAlertMessageTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
        
        timeview = [[UIView alloc]init];
        [self.contentView addSubview:timeview];
        [timeview setBackgroundColor:[UIColor commonLightGrayTextColor]];
        [timeview.layer setCornerRadius:2.5];
        [timeview.layer setMasksToBounds:YES];
        
        [timeview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).with.offset(6);
        }];
        
        lbSendTime = [[UILabel alloc]init];
        [timeview addSubview:lbSendTime];
        [lbSendTime setBackgroundColor:[UIColor clearColor]];
        [lbSendTime setTextColor:[UIColor whiteColor]];
        [lbSendTime setFont:[UIFont font_24]];
        
        
        
        [lbSendTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(timeview);
            make.top.and.bottom.equalTo(timeview);
            make.leftMargin.mas_equalTo(@4);
            make.rightMargin.mas_equalTo([NSNumber numberWithFloat:-4]);

            
        }];
        
        alertview = [[UIView alloc]init];
        [self.contentView addSubview:alertview];
        [alertview setBackgroundColor:[UIColor commonLightGrayTextColor]];
        [alertview.layer setCornerRadius:2.5];
        [alertview.layer setMasksToBounds:YES];
        
        [alertview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(timeview.mas_bottom).with.offset(5);
            make.left.greaterThanOrEqualTo(self.contentView).with.offset(12.5);
            make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
        }];
        
        lbAlert = [[UILabel alloc]init];
        [alertview addSubview:lbAlert];
        [lbAlert setBackgroundColor:[UIColor commonLightGrayTextColor]];
        [lbAlert setTextColor:[UIColor whiteColor]];
        [lbAlert setFont:[UIFont font_24]];
        [lbAlert setNumberOfLines:0];
        
        [lbAlert.layer setCornerRadius:2.5];
        [lbAlert.layer setMasksToBounds:YES];
        
        [lbAlert mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(alertview);
            make.top.and.bottom.equalTo(alertview);
            make.leftMargin.mas_equalTo(@5);
            make.rightMargin.mas_equalTo([NSNumber numberWithFloat:-5]);

            
        }];
    }
    return self;
}

- (void) setMessage:(MessageBaseModel*) message
{
    [super setMessage:message];
    [lbSendTime setText:[NSDate im_dateFormaterWithTimeInterval:message._createDate]];
    [lbAlert setText:message._content];
}

@end
